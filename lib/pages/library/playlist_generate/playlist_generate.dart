import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotify_markets.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/library/playlist_generate/multi_select_field.dart';
import 'package:spotube/components/library/playlist_generate/seeds_multi_autocomplete.dart';
import 'package:spotube/components/library/playlist_generate/simple_track_tile.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/library/playlist_generate/playlist_generate_result.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

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
    final market = useValueNotifier<String>(preferences.recommendationMarket);

    final genres = useState<List<String>>([]);
    final artists = useState<List<Artist>>([]);
    final tracks = useState<List<Track>>([]);

    final enabled =
        genres.value.length + artists.value.length + tracks.value.length < 5;

    final leftSeedCount =
        5 - genres.value.length - artists.value.length - tracks.value.length;

    return Scaffold(
      appBar: PageWindowTitleBar(
        leading: const BackButton(),
        title: Text(context.l10n.generate_playlist),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ValueListenableBuilder(
              valueListenable: limit,
              builder: (context, value, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Number of tracks to generate",
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
            ValueListenableBuilder(
              valueListenable: market,
              builder: (context, value, _) {
                return DropdownMenu<String>(
                  hintText: "Select a country",
                  dropdownMenuEntries: spotifyMarkets
                      .map(
                        (country) => DropdownMenuEntry(
                          value: country.first,
                          label: country.last,
                        ),
                      )
                      .toList(),
                  initialSelection: market.value,
                  onSelected: (value) {
                    market.value = value!;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            MultiSelectField<String>(
              options: genresCollection.data ?? [],
              selectedOptions: genres.value,
              getValueForOption: (option) => option,
              onSelected: (value) {
                genres.value = value;
              },
              dialogTitle: const Text("Select genres"),
              label: const Text("Add genres"),
              helperText: "Select up to $leftSeedCount genres",
              enabled: enabled,
            ),
            const SizedBox(height: 16),
            SeedsMultiAutocomplete<Artist>(
              seeds: artists,
              enabled: enabled,
              inputDecoration: InputDecoration(
                labelText: "Artists",
                labelStyle: textTheme.titleMedium,
                helperText: "Select up to $leftSeedCount artists",
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
                          (element) => artists.value
                              .none((artist) => element.id == artist.id),
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
                              backgroundColor:
                                  theme.colorScheme.secondaryContainer,
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
                    ...artists.value
                      ..removeWhere((element) => element.id == artist.id)
                  ];
                },
              ),
            ),
            const SizedBox(height: 16),
            SeedsMultiAutocomplete<Track>(
              seeds: tracks,
              enabled: enabled,
              selectedItemDisplayType: SelectedItemDisplayType.list,
              inputDecoration: InputDecoration(
                labelText: "Tracks",
                labelStyle: textTheme.titleMedium,
                helperText: "Select up to $leftSeedCount tracks",
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
                          (element) => tracks.value
                              .none((track) => element.id == track.id),
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
                    ...tracks.value
                      ..removeWhere((element) => element.id == option.id)
                  ];
                },
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              icon: const Icon(SpotubeIcons.magic),
              label: Text("Generate"),
              onPressed: () {
                final PlaylistGenerateResultRouteState routeState = (
                  seeds: (
                    artists: artists.value.map((a) => a.id!).toList(),
                    tracks: tracks.value.map((t) => t.id!).toList(),
                    genres: genres.value
                  ),
                  market: market.value,
                  limit: limit.value,
                  max: null,
                  min: null,
                  target: null,
                );
                GoRouter.of(context).push(
                  "/library/generate/result",
                  extra: routeState,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
