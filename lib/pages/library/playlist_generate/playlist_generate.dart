import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotify_markets.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/library/playlist_generate/multi_select_field.dart';
import 'package:spotube/modules/library/playlist_generate/recommendation_attribute_dials.dart';
import 'package:spotube/modules/library/playlist_generate/recommendation_attribute_fields.dart';
import 'package:spotube/modules/library/playlist_generate/seeds_multi_autocomplete.dart';
import 'package:spotube/modules/library/playlist_generate/simple_track_tile.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/models/spotify/recommendation_seeds.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

const RecommendationAttribute zeroValues = (min: 0, target: 0, max: 0);

class PlaylistGeneratorPage extends HookConsumerWidget {
  static const name = "playlist_generator";

  const PlaylistGeneratorPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final spotify = ref.watch(spotifyProvider);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final preferences = ref.watch(userPreferencesProvider);

    final genresCollection = ref.watch(categoryGenresProvider);

    final limit = useValueNotifier<int>(10);
    final market = useValueNotifier<Market>(preferences.market);

    final genres = useState<List<String>>([]);
    final artists = useState<List<Artist>>([]);
    final tracks = useState<List<Track>>([]);

    final enabled =
        genres.value.length + artists.value.length + tracks.value.length < 5;

    final leftSeedCount =
        5 - genres.value.length - artists.value.length - tracks.value.length;

    // Dial (int 0-1) attributes
    final min = useState<RecommendationSeeds>(RecommendationSeeds());
    final max = useState<RecommendationSeeds>(RecommendationSeeds());
    final target = useState<RecommendationSeeds>(RecommendationSeeds());

    final artistAutoComplete = SeedsMultiAutocomplete<Artist>(
      seeds: artists,
      enabled: enabled,
      inputDecoration: InputDecoration(
        labelText: context.l10n.artists,
        labelStyle: textTheme.titleMedium,
        helperText: context.l10n.select_up_to_count_type(
          leftSeedCount,
          context.l10n.artists,
        ),
      ),
      fetchSeeds: (textEditingValue) => spotify.search
          .get(
            textEditingValue.text,
            types: [SearchType.artist],
          )
          .first(6)
          .then(
            (v) => List.castFrom<dynamic, Artist>(
              v.expand((e) => e.items ?? []).toList(),
            )
                .where(
                  (element) =>
                      artists.value.none((artist) => element.id == artist.id),
                )
                .toList(),
          ),
      autocompleteOptionBuilder: (option, onSelected) => ListTile(
        leading: CircleAvatar(
          backgroundImage: UniversalImage.imageProvider(
            option.images.asUrlString(
              placeholder: ImagePlaceholder.artist,
            ),
          ),
        ),
        horizontalTitleGap: 20,
        title: Text(option.name!),
        subtitle: option.genres?.isNotEmpty != true
            ? null
            : Wrap(
                spacing: 4,
                runSpacing: 4,
                children: option.genres!.mapIndexed(
                  (index, genre) {
                    return Chip(
                      label: Text(genre),
                      labelStyle: textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                      side: BorderSide.none,
                      backgroundColor: theme.colorScheme.secondaryContainer,
                    );
                  },
                ).toList(),
              ),
        onTap: () => onSelected(option),
      ),
      displayStringForOption: (option) => option.name!,
      selectedSeedBuilder: (artist) => Chip(
        avatar: CircleAvatar(
          backgroundImage: UniversalImage.imageProvider(
            artist.images.asUrlString(
              placeholder: ImagePlaceholder.artist,
            ),
          ),
        ),
        label: Text(artist.name!),
        onDeleted: () {
          artists.value = [
            ...artists.value..removeWhere((element) => element.id == artist.id)
          ];
        },
      ),
    );

    final tracksAutocomplete = SeedsMultiAutocomplete<Track>(
      seeds: tracks,
      enabled: enabled,
      selectedItemDisplayType: SelectedItemDisplayType.list,
      inputDecoration: InputDecoration(
        labelText: context.l10n.tracks,
        labelStyle: textTheme.titleMedium,
        helperText: context.l10n.select_up_to_count_type(
          leftSeedCount,
          context.l10n.tracks,
        ),
      ),
      fetchSeeds: (textEditingValue) => spotify.search
          .get(
            textEditingValue.text,
            types: [SearchType.track],
          )
          .first(6)
          .then(
            (v) => List.castFrom<dynamic, Track>(
              v.expand((e) => e.items ?? []).toList(),
            )
                .where(
                  (element) =>
                      tracks.value.none((track) => element.id == track.id),
                )
                .toList(),
          ),
      autocompleteOptionBuilder: (option, onSelected) => ListTile(
        leading: CircleAvatar(
          backgroundImage: UniversalImage.imageProvider(
            (option.album?.images).asUrlString(
              placeholder: ImagePlaceholder.artist,
            ),
          ),
        ),
        horizontalTitleGap: 20,
        title: Text(option.name!),
        subtitle: Text(
          option.artists?.map((e) => e.name).join(", ") ??
              option.album?.name ??
              "",
        ),
        onTap: () => onSelected(option),
      ),
      displayStringForOption: (option) => option.name!,
      selectedSeedBuilder: (option) => SimpleTrackTile(
        track: option,
        onDelete: () {
          tracks.value = [
            ...tracks.value..removeWhere((element) => element.id == option.id)
          ];
        },
      ),
    );

    final genreSelector = MultiSelectField<String>(
      options: genresCollection.asData?.value ?? [],
      selectedOptions: genres.value,
      getValueForOption: (option) => option,
      onSelected: (value) {
        genres.value = value;
      },
      dialogTitle: Text(context.l10n.select_genres),
      label: Text(context.l10n.add_genres),
      helperText: context.l10n.select_up_to_count_type(
        leftSeedCount,
        context.l10n.genre,
      ),
      enabled: enabled,
    );
    final countrySelector = ValueListenableBuilder(
      valueListenable: market,
      builder: (context, value, _) {
        return DropdownButtonFormField<Market>(
          decoration: InputDecoration(
            labelText: context.l10n.country,
            labelStyle: textTheme.titleMedium,
          ),
          isExpanded: true,
          items: spotifyMarkets
              .map(
                (country) => DropdownMenuItem(
                  value: country.$1,
                  child: Text(country.$2),
                ),
              )
              .toList(),
          value: market.value,
          onChanged: (value) {
            market.value = value!;
          },
        );
      },
    );

    final controller = useScrollController();

    return Scaffold(
      appBar: PageWindowTitleBar(
        leading: const BackButton(),
        title: Text(context.l10n.generate_playlist),
        centerTitle: true,
      ),
      body: Scrollbar(
        controller: controller,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Breakpoints.lg),
            child: SliderTheme(
              data: const SliderThemeData(
                overlayShape: RoundSliderOverlayShape(),
              ),
              child: SafeArea(
                child: LayoutBuilder(builder: (context, constrains) {
                  return ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.all(16),
                      children: [
                        ValueListenableBuilder(
                          valueListenable: limit,
                          builder: (context, value, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.number_of_tracks_generate,
                                  style: textTheme.titleMedium,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        value.round().toString(),
                                        style: textTheme.bodyLarge?.copyWith(
                                          color: theme
                                              .colorScheme.primaryContainer,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Slider(
                                        value: value.toDouble(),
                                        min: 10,
                                        max: 100,
                                        divisions: 9,
                                        label: value.round().toString(),
                                        onChanged: (value) {
                                          limit.value = value.round();
                                        },
                                      ),
                                    )
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        if (constrains.mdAndUp)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: countrySelector,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: genreSelector,
                              ),
                            ],
                          )
                        else ...[
                          countrySelector,
                          const SizedBox(height: 16),
                          genreSelector,
                        ],
                        const SizedBox(height: 16),
                        if (constrains.mdAndUp)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: artistAutoComplete,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: tracksAutocomplete,
                              ),
                            ],
                          )
                        else ...[
                          artistAutoComplete,
                          const SizedBox(height: 16),
                          tracksAutocomplete,
                        ],
                        const SizedBox(height: 16),
                        RecommendationAttributeDials(
                          title: Text(context.l10n.acousticness),
                          values: (
                            target: target.value.acousticness?.toDouble() ?? 0,
                            min: min.value.acousticness?.toDouble() ?? 0,
                            max: max.value.acousticness?.toDouble() ?? 0,
                          ),
                          onChanged: (value) {
                            target.value = target.value.copyWith(
                              acousticness: value.target,
                            );
                            min.value = min.value.copyWith(
                              acousticness: value.min,
                            );
                            max.value = max.value.copyWith(
                              acousticness: value.max,
                            );
                          },
                        ),
                        RecommendationAttributeDials(
                          title: Text(context.l10n.danceability),
                          values: (
                            target: target.value.danceability?.toDouble() ?? 0,
                            min: min.value.danceability?.toDouble() ?? 0,
                            max: max.value.danceability?.toDouble() ?? 0,
                          ),
                          onChanged: (value) {
                            target.value = target.value.copyWith(
                              danceability: value.target,
                            );
                            min.value = min.value.copyWith(
                              danceability: value.min,
                            );
                            max.value = max.value.copyWith(
                              danceability: value.max,
                            );
                          },
                        ),
                        RecommendationAttributeDials(
                          title: Text(context.l10n.energy),
                          values: (
                            target: target.value.energy?.toDouble() ?? 0,
                            min: min.value.energy?.toDouble() ?? 0,
                            max: max.value.energy?.toDouble() ?? 0,
                          ),
                          onChanged: (value) {
                            target.value = target.value.copyWith(
                              energy: value.target,
                            );
                            min.value = min.value.copyWith(
                              energy: value.min,
                            );
                            max.value = max.value.copyWith(
                              energy: value.max,
                            );
                          },
                        ),
                        RecommendationAttributeDials(
                          title: Text(context.l10n.instrumentalness),
                          values: (
                            target:
                                target.value.instrumentalness?.toDouble() ?? 0,
                            min: min.value.instrumentalness?.toDouble() ?? 0,
                            max: max.value.instrumentalness?.toDouble() ?? 0,
                          ),
                          onChanged: (value) {
                            target.value = target.value.copyWith(
                              instrumentalness: value.target,
                            );
                            min.value = min.value.copyWith(
                              instrumentalness: value.min,
                            );
                            max.value = max.value.copyWith(
                              instrumentalness: value.max,
                            );
                          },
                        ),
                        RecommendationAttributeDials(
                          title: Text(context.l10n.liveness),
                          values: (
                            target: target.value.liveness?.toDouble() ?? 0,
                            min: min.value.liveness?.toDouble() ?? 0,
                            max: max.value.liveness?.toDouble() ?? 0,
                          ),
                          onChanged: (value) {
                            target.value = target.value.copyWith(
                              liveness: value.target,
                            );
                            min.value = min.value.copyWith(
                              liveness: value.min,
                            );
                            max.value = max.value.copyWith(
                              liveness: value.max,
                            );
                          },
                        ),
                        RecommendationAttributeDials(
                          title: Text(context.l10n.loudness),
                          values: (
                            target: target.value.loudness?.toDouble() ?? 0,
                            min: min.value.loudness?.toDouble() ?? 0,
                            max: max.value.loudness?.toDouble() ?? 0,
                          ),
                          onChanged: (value) {
                            target.value = target.value.copyWith(
                              loudness: value.target,
                            );
                            min.value = min.value.copyWith(
                              loudness: value.min,
                            );
                            max.value = max.value.copyWith(
                              loudness: value.max,
                            );
                          },
                        ),
                        RecommendationAttributeDials(
                          title: Text(context.l10n.speechiness),
                          values: (
                            target: target.value.speechiness?.toDouble() ?? 0,
                            min: min.value.speechiness?.toDouble() ?? 0,
                            max: max.value.speechiness?.toDouble() ?? 0,
                          ),
                          onChanged: (value) {
                            target.value = target.value.copyWith(
                              speechiness: value.target,
                            );
                            min.value = min.value.copyWith(
                              speechiness: value.min,
                            );
                            max.value = max.value.copyWith(
                              speechiness: value.max,
                            );
                          },
                        ),
                        RecommendationAttributeDials(
                          title: Text(context.l10n.valence),
                          values: (
                            target: target.value.valence?.toDouble() ?? 0,
                            min: min.value.valence?.toDouble() ?? 0,
                            max: max.value.valence?.toDouble() ?? 0,
                          ),
                          onChanged: (value) {
                            target.value = target.value.copyWith(
                              valence: value.target,
                            );
                            min.value = min.value.copyWith(
                              valence: value.min,
                            );
                            max.value = max.value.copyWith(
                              valence: value.max,
                            );
                          },
                        ),
                        RecommendationAttributeDials(
                          title: Text(context.l10n.popularity),
                          base: 100,
                          values: (
                            target: target.value.popularity?.toDouble() ?? 0,
                            min: min.value.popularity?.toDouble() ?? 0,
                            max: max.value.popularity?.toDouble() ?? 0,
                          ),
                          onChanged: (value) {
                            target.value = target.value.copyWith(
                              popularity: value.target,
                            );
                            min.value = min.value.copyWith(
                              popularity: value.min,
                            );
                            max.value = max.value.copyWith(
                              popularity: value.max,
                            );
                          },
                        ),
                        RecommendationAttributeDials(
                          title: Text(context.l10n.key),
                          base: 11,
                          values: (
                            target: target.value.key?.toDouble() ?? 0,
                            min: min.value.key?.toDouble() ?? 0,
                            max: max.value.key?.toDouble() ?? 0,
                          ),
                          onChanged: (value) {
                            target.value = target.value.copyWith(
                              key: value.target,
                            );
                            min.value = min.value.copyWith(
                              key: value.min,
                            );
                            max.value = max.value.copyWith(
                              key: value.max,
                            );
                          },
                        ),
                        RecommendationAttributeFields(
                          title: Text(context.l10n.duration),
                          values: (
                            max: (max.value.durationMs ?? 0) / 1000,
                            target: (target.value.durationMs ?? 0) / 1000,
                            min: (min.value.durationMs ?? 0) / 1000,
                          ),
                          onChanged: (value) {
                            target.value = target.value.copyWith(
                              durationMs: (value.target * 1000).toInt(),
                            );
                            min.value = min.value.copyWith(
                              durationMs: (value.min * 1000).toInt(),
                            );
                            max.value = max.value.copyWith(
                              durationMs: (value.max * 1000).toInt(),
                            );
                          },
                          presets: {
                            context.l10n.short: (min: 50, target: 90, max: 120),
                            context.l10n.medium: (
                              min: 120,
                              target: 180,
                              max: 200
                            ),
                            context.l10n.long: (min: 480, target: 560, max: 640)
                          },
                        ),
                        RecommendationAttributeFields(
                          title: Text(context.l10n.tempo),
                          values: (
                            max: max.value.tempo?.toDouble() ?? 0,
                            target: target.value.tempo?.toDouble() ?? 0,
                            min: min.value.tempo?.toDouble() ?? 0,
                          ),
                          onChanged: (value) {
                            target.value = target.value.copyWith(
                              tempo: value.target,
                            );
                            min.value = min.value.copyWith(
                              tempo: value.min,
                            );
                            max.value = max.value.copyWith(
                              tempo: value.max,
                            );
                          },
                        ),
                        RecommendationAttributeFields(
                          title: Text(context.l10n.mode),
                          values: (
                            max: max.value.mode?.toDouble() ?? 0,
                            target: target.value.mode?.toDouble() ?? 0,
                            min: min.value.mode?.toDouble() ?? 0,
                          ),
                          onChanged: (value) {
                            target.value = target.value.copyWith(
                              mode: value.target,
                            );
                            min.value = min.value.copyWith(
                              mode: value.min,
                            );
                            max.value = max.value.copyWith(
                              mode: value.max,
                            );
                          },
                        ),
                        RecommendationAttributeFields(
                          title: Text(context.l10n.time_signature),
                          values: (
                            max: max.value.timeSignature?.toDouble() ?? 0,
                            target: target.value.timeSignature?.toDouble() ?? 0,
                            min: min.value.timeSignature?.toDouble() ?? 0,
                          ),
                          onChanged: (value) {
                            target.value = target.value.copyWith(
                              timeSignature: value.target,
                            );
                            min.value = min.value.copyWith(
                              timeSignature: value.min,
                            );
                            max.value = max.value.copyWith(
                              timeSignature: value.max,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          icon: const Icon(SpotubeIcons.magic),
                          label: Text(context.l10n.generate_playlist),
                          onPressed: artists.value.isEmpty &&
                                  tracks.value.isEmpty &&
                                  genres.value.isEmpty
                              ? null
                              : () {
                                  final routeState =
                                      GeneratePlaylistProviderInput(
                                    seedArtists: artists.value
                                        .map((a) => a.id!)
                                        .toList(),
                                    seedTracks:
                                        tracks.value.map((t) => t.id!).toList(),
                                    seedGenres: genres.value,
                                    limit: limit.value,
                                    max: max.value,
                                    min: min.value,
                                    target: target.value,
                                  );
                                  GoRouter.of(context).push(
                                    "/library/generate/result",
                                    extra: routeState,
                                  );
                                },
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
