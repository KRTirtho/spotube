import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/fallbacks/error_box.dart';
import 'package:spotube/components/fallbacks/no_default_metadata_plugin.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/string.dart';
import 'package:spotube/hooks/controllers/use_shadcn_text_editing_controller.dart';
import 'package:spotube/pages/search/tabs/albums.dart';
import 'package:spotube/pages/search/tabs/all.dart';
import 'package:spotube/pages/search/tabs/artists.dart';
import 'package:spotube/pages/search/tabs/playlists.dart';
import 'package:spotube/pages/search/tabs/tracks.dart';
import 'package:spotube/provider/metadata_plugin/search/all.dart';
import 'package:spotube/services/kv_store/kv_store.dart';
import 'package:auto_route/auto_route.dart';
import 'package:spotube/services/metadata/errors/exceptions.dart';
import 'package:spotube/theme/spotify_colors.dart';
import 'package:spotube/theme/spotify_typography.dart';

final searchTermStateProvider = StateProvider<String>((ref) {
  return "";
});

@RoutePage()
class SearchPage extends HookConsumerWidget {
  static const name = "search";

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final controller = useShadcnTextEditingController();
    final focusNode = useFocusNode();
    final textTheme = SpotifyTypography.buildTextTheme(context);

    final searchTerm = ref.watch(searchTermStateProvider);
    final searchChipSnapshot = ref.watch(metadataPluginSearchChipsProvider);
    final selectedChip = useState<String?>(
      searchChipSnapshot.asData?.value.first ?? "all",
    );

    ref.listen(
      metadataPluginSearchChipsProvider,
      (previous, next) {
        selectedChip.value = next.asData?.value.first ?? "all";
      },
    );

    useEffect(() {
      controller.text = searchTerm;

      return null;
    }, []);

    void onSubmitted(String value) {
      ref.read(searchTermStateProvider.notifier).state = value;
      focusNode.unfocus();
      if (value.trim().isEmpty) {
        return;
      }
      KVStoreService.setRecentSearches(
        {
          value,
          ...KVStoreService.recentSearches,
        }.toList(),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.navigateTo(const HomeRoute());
      },
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: SpotifyColors.background,
          body: Builder(builder: (context) {
            if (searchChipSnapshot.error
                case MetadataPluginException(
                  errorCode: MetadataPluginErrorCode.noDefaultMetadataPlugin,
                  message: _
                )) {
              return const NoDefaultMetadataPlugin();
            }

            if (searchChipSnapshot.hasError) {
              return ErrorBox(
                error: searchChipSnapshot.error!,
                onRetry: () {
                  ref.invalidate(metadataPluginSearchChipsProvider);
                },
              );
            }

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  color: SpotifyColors.background,
                  child: ListenableBuilder(
                      listenable: controller,
                      builder: (context, _) {
                        final suggestions = controller.text.isEmpty
                            ? KVStoreService.recentSearches
                            : KVStoreService.recentSearches
                                .where(
                                  (s) =>
                                      weightedRatio(
                                        s.toLowerCase(),
                                        controller.text.toLowerCase(),
                                      ) >
                                      50,
                                )
                                .toList();

                        return SearchTextField(
                          suggestions: suggestions.length <= 2
                              ? [
                                  ...suggestions,
                                  "Twenty One Pilots",
                                  "Linkin Park",
                                ]
                              : suggestions,
                          controller: controller,
                          focusNode: focusNode,
                          onSubmitted: onSubmitted,
                        );
                      }),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    spacing: 8,
                    children: [
                      if (searchChipSnapshot.asData?.value != null)
                        for (final chip in searchChipSnapshot.asData!.value)
                          SpotifyChip(
                            selected: selectedChip.value == chip,
                            label: chip.capitalize(),
                            onPressed: () {
                              selectedChip.value = chip;
                            },
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: switch (selectedChip.value) {
                      "tracks" => const SearchPageTracksTab(),
                      "albums" => const SearchPageAlbumsTab(),
                      "artists" => const SearchPageArtistsTab(),
                      "playlists" => const SearchPagePlaylistsTab(),
                      _ => const SearchPageAllTab(),
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class SearchTextField extends HookConsumerWidget {
  final List<String> suggestions;
  final Object controller;
  final FocusNode focusNode;
  final void Function(String) onSubmitted;

  const SearchTextField({
    super.key,
    required this.suggestions,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context, ref) {
    final textCtrl = controller as dynamic;
    final textTheme = SpotifyTypography.buildTextTheme(context);
    return AutoComplete(
      suggestions: suggestions,
      completer: (suggestion) => suggestion,
      mode: AutoCompleteMode.replaceAll,
      child: TextField(
        autofocus: true,
        controller: textCtrl,
        focusNode: focusNode,
        style: textTheme.bodyLarge?.copyWith(
          color: SpotifyColors.primaryText,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: SpotifyColors.surface,
          hintText: context.l10n.search,
          hintStyle: textTheme.bodyLarge?.copyWith(
            color: SpotifyColors.disabledText,
          ),
          prefixIcon: const Icon(
            SpotubeIcons.search,
            color: SpotifyColors.secondaryText,
            size: 20,
          ),
          suffixIcon: AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState:
                textCtrl.text.isNotEmpty
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            firstChild: IconButton(
              icon: const Icon(SpotubeIcons.close,
                  color: SpotifyColors.secondaryText, size: 18),
              onPressed: () {
                textCtrl.clear();
              },
            ),
            secondChild: const SizedBox.square(dimension: 28),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(500),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(500),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(500),
            borderSide: const BorderSide(color: SpotifyColors.spotifyGreen),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class SpotifyChip extends HookConsumerWidget {
  final bool selected;
  final String label;
  final VoidCallback onPressed;

  const SpotifyChip({
    super.key,
    required this.selected,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, ref) {
    final textTheme = SpotifyTypography.buildTextTheme(context);
    return HoverBuilder(
      builder: (context, hovering) {
        return ActionChip(
          label: Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: selected
                  ? Colors.black
                  : SpotifyColors.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: selected
              ? SpotifyColors.spotifyGreen
              : (hovering ? SpotifyColors.hover : SpotifyColors.surface),
          side: BorderSide.none,
          shape: const StadiumBorder(),
          onPressed: onPressed,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        );
      },
    );
  }
}
