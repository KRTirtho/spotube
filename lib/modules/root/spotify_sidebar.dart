import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:spotube/collections/side_bar_tiles.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/theme/spotify_colors.dart';
import 'package:spotube/theme/spotify_typography.dart';
import 'package:spotube/components/hover_builder.dart';
import 'package:spotube/collections/spotube_icons.dart';

class SpotifySidebar extends HookConsumerWidget {
  const SpotifySidebar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final l10n = context.l10n;
    final router = context.watchRouter;

    final tileList = [...getSidebarTileList(l10n), ...getSidebarLibraryTileList(l10n)];

    final collapsed = useState(false);
    final selectedIndex = useState(
      tileList.indexWhere((e) => router.currentPath.startsWith(e.pathPrefix)),
    );

    router.addListener(() {
      final index = tileList.indexWhere(
        (e) => router.currentPath.startsWith(e.pathPrefix),
      );
      if (index != -1 && index != selectedIndex.value) {
        selectedIndex.value = index;
      }
    });

    final width = collapsed.value ? 72.0 : 240.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      color: SpotifyColors.sidebarBackground,
      child: Column(
        children: [
          const SizedBox(height: 16),
          _NavButton(
            selected: false,
            icon: SpotubeIcons.home,
            label: collapsed.value ? null : l10n.browse,
            tooltip: l10n.browse,
            onPressed: () => context.navigateTo(const HomeRoute()),
          ),
          _NavButton(
            selected: false,
            icon: SpotubeIcons.search,
            label: collapsed.value ? null : l10n.search,
            tooltip: l10n.search,
            onPressed: () => context.navigateTo(const SearchRoute()),
          ),
          const Divider(height: 1, color: SpotifyColors.separator),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Row(
              mainAxisAlignment: collapsed.value
                  ? MainAxisSize.min
                  : MainAxisSize.spaceBetween,
              children: [
                if (!collapsed.value)
                  Text(l10n.library, style: SpotifyTypography.buildTextTheme(context).titleMedium),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(SpotubeIcons.add), onPressed: {}),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(SpotubeIcons.filter), onPressed: {}),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tileList.length,
              itemBuilder: (context, index) {
                final tile = tileList[index];
                final selected = selectedIndex.value == index;
                return _NavButton(
                  selected: selected,
                  icon: tile.icon,
                  label: collapsed.value ? null : tile.title,
                  tooltip: tile.title,
                  onPressed: () => context.navigateTo(tile.route),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _CollapseToggle(collapsed: collapsed),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _NavButton extends HookConsumerWidget {
  final bool selected;
  final IconData icon;
    final String? label;
  final String tooltip;
  final VoidCallback onPressed;

  const _NavButton({
    required this.selected,
    required this.icon,
    this.label,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, ref) {
    final textTheme = SpotifyTypography.buildTextTheme(context);
    return HoverBuilder(
      builder: (context, hovering) {
        final active = selected || hovering;
        return InkWell(
          onTap: onPressed,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            height: 56,
            color: active ? SpotifyColors.hover : Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: active ? SpotifyColors.primaryText : SpotifyColors.secondaryText, size: 20),
                const SizedBox(width: 16),
                if (label != null)
                  Expanded(
                    child: Text(
                      label!,
                      style: textTheme.labelLarge?.copyWith(
                        color: active ? SpotifyColors.primaryText : SpotifyColors.secondaryText,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CollapseToggle extends HookConsumerWidget {
  final ValueNotifier<bool> collapsed;

  const _CollapseToggle({required this.collapsed});

  @override
  Widget build(BuildContext context, ref) {
    return InkWell(
      onTap: () => collapsed.value = !collapsed.value,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        child: Icon(
          collapsed.value ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
          color: SpotifyColors.secondaryText,
          size: 18,
        ),
      ),
    );
  }
}
