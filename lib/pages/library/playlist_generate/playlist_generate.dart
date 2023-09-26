import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotify_markets.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/library/playlist_generate/multi_select_field.dart';
import 'package:spotube/components/library/playlist_generate/recommendation_attribute_dials.dart';
import 'package:spotube/components/library/playlist_generate/recommendation_attribute_fields.dart';
import 'package:spotube/components/library/playlist_generate/seeds_multi_autocomplete.dart';
import 'package:spotube/components/library/playlist_generate/simple_track_tile.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/library/playlist_generate/playlist_generate_result.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

const RecommendationAttribute zeroValues = (min: 0, target: 0, max: 0);

class PlaylistGeneratorPage extends HookConsumerWidget {
  const PlaylistGeneratorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final spotify = ref.watch(spotifyProvider);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final preferences = ref.watch(userPreferencesProvider);

    final genresCollection = useQueries.category.genreSeeds(ref);

    final limit = useValueNotifier<int>(10);
    final market = useValueNotifier<Market>(preferences.recommendationMarket);

    final genres = useState<List<String>>([]);
    final artists = useState<List<Artist>>([]);
    final tracks = useState<List<Track>>([]);

    final enabled =
        genres.value.length + artists.value.length + tracks.value.length < 5;

    final leftSeedCount =
        5 - genres.value.length - artists.value.length - tracks.value.length;

    // Dial (int 0-1) attributes
    final acousticness = useState<RecommendationAttribute>(zeroValues);
    final danceability = useState<RecommendationAttribute>(zeroValues);
    final energy = useState<RecommendationAttribute>(zeroValues);
    final instrumentalness = useState<RecommendationAttribute>(zeroValues);
    final key = useState<RecommendationAttribute>(zeroValues);
    final liveness = useState<RecommendationAttribute>(zeroValues);
    final loudness = useState<RecommendationAttribute>(zeroValues);
    final popularity = useState<RecommendationAttribute>(zeroValues);
    final speechiness = useState<RecommendationAttribute>(zeroValues);
    final valence = useState<RecommendationAttribute>(zeroValues);

    // Field editable attributes
    final tempo = useState<RecommendationAttribute>(zeroValues);
    final durationMs = useState<RecommendationAttribute>(zeroValues);
    final mode = useState<RecommendationAttribute>(zeroValues);
    final timeSignature = useState<RecommendationAttribute>(zeroValues);

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
            TypeConversionUtils.image_X_UrlString(
              option.images,
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
            TypeConversionUtils.image_X_UrlString(
              artist.images,
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
            TypeConversionUtils.image_X_UrlString(
              option.album?.images,
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
      options: genresCollection.data ?? [],
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

    return Scaffold(
      appBar: PageWindowTitleBar(
        leading: const BackButton(),
        title: Text(context.l10n.generate_playlist),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Breakpoints.lg),
          child: SliderTheme(
            data: const SliderThemeData(
              overlayShape: RoundSliderOverlayShape(),
            ),
            child: SafeArea(
              child: LayoutBuilder(builder: (context, constrains) {
                return ListView(
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
                                      color: theme.colorScheme.primaryContainer,
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
                      values: acousticness.value,
                      onChanged: (value) {
                        acousticness.value = value;
                      },
                    ),
                    RecommendationAttributeDials(
                      title: Text(context.l10n.danceability),
                      values: danceability.value,
                      onChanged: (value) {
                        danceability.value = value;
                      },
                    ),
                    RecommendationAttributeDials(
                      title: Text(context.l10n.energy),
                      values: energy.value,
                      onChanged: (value) {
                        energy.value = value;
                      },
                    ),
                    RecommendationAttributeDials(
                      title: Text(context.l10n.instrumentalness),
                      values: instrumentalness.value,
                      onChanged: (value) {
                        instrumentalness.value = value;
                      },
                    ),
                    RecommendationAttributeDials(
                      title: Text(context.l10n.liveness),
                      values: liveness.value,
                      onChanged: (value) {
                        liveness.value = value;
                      },
                    ),
                    RecommendationAttributeDials(
                      title: Text(context.l10n.loudness),
                      values: loudness.value,
                      onChanged: (value) {
                        loudness.value = value;
                      },
                    ),
                    RecommendationAttributeDials(
                      title: Text(context.l10n.speechiness),
                      values: speechiness.value,
                      onChanged: (value) {
                        speechiness.value = value;
                      },
                    ),
                    RecommendationAttributeDials(
                      title: Text(context.l10n.valence),
                      values: valence.value,
                      onChanged: (value) {
                        valence.value = value;
                      },
                    ),
                    RecommendationAttributeDials(
                      title: Text(context.l10n.popularity),
                      values: popularity.value,
                      base: 100,
                      onChanged: (value) {
                        popularity.value = value;
                      },
                    ),
                    RecommendationAttributeDials(
                      title: Text(context.l10n.key),
                      values: key.value,
                      base: 11,
                      onChanged: (value) {
                        key.value = value;
                      },
                    ),
                    RecommendationAttributeFields(
                      title: Text(context.l10n.duration),
                      values: (
                        max: durationMs.value.max / 1000,
                        target: durationMs.value.target / 1000,
                        min: durationMs.value.min / 1000,
                      ),
                      onChanged: (value) {
                        durationMs.value = (
                          max: value.max * 1000,
                          target: value.target * 1000,
                          min: value.min * 1000,
                        );
                      },
                      presets: {
                        context.l10n.short: (min: 50, target: 90, max: 120),
                        context.l10n.medium: (min: 120, target: 180, max: 200),
                        context.l10n.long: (min: 480, target: 560, max: 640)
                      },
                    ),
                    RecommendationAttributeFields(
                      title: Text(context.l10n.tempo),
                      values: tempo.value,
                      onChanged: (value) {
                        tempo.value = value;
                      },
                    ),
                    RecommendationAttributeFields(
                      title: Text(context.l10n.mode),
                      values: mode.value,
                      onChanged: (value) {
                        mode.value = value;
                      },
                    ),
                    RecommendationAttributeFields(
                      title: Text(context.l10n.time_signature),
                      values: timeSignature.value,
                      onChanged: (value) {
                        timeSignature.value = value;
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
                              final PlaylistGenerateResultRouteState
                                  routeState = (
                                seeds: (
                                  artists:
                                      artists.value.map((a) => a.id!).toList(),
                                  tracks:
                                      tracks.value.map((t) => t.id!).toList(),
                                  genres: genres.value
                                ),
                                market: market.value,
                                limit: limit.value,
                                parameters: (
                                  acousticness: acousticness.value,
                                  danceability: danceability.value,
                                  energy: energy.value,
                                  instrumentalness: instrumentalness.value,
                                  liveness: liveness.value,
                                  loudness: loudness.value,
                                  speechiness: speechiness.value,
                                  valence: valence.value,
                                  popularity: popularity.value,
                                  key: key.value,
                                  duration_ms: durationMs.value,
                                  tempo: tempo.value,
                                  mode: mode.value,
                                  time_signature: timeSignature.value,
                                )
                              );
                              GoRouter.of(context).push(
                                "/library/generate/result",
                                extra: routeState,
                              );
                            },
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
