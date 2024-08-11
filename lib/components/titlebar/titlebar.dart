import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/titlebar/titlebar_buttons.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';

import 'package:window_manager/window_manager.dart';

class PageWindowTitleBar extends StatefulHookConsumerWidget
    implements PreferredSizeWidget {
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? actionsIconTheme;
  final bool? centerTitle;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final double? titleWidth;
  final Widget? title;

  final bool _sliver;

  const PageWindowTitleBar({
    super.key,
    this.actions,
    this.title,
    this.toolbarOpacity = 1,
    this.backgroundColor,
    this.actionsIconTheme,
    this.automaticallyImplyLeading = false,
    this.centerTitle,
    this.foregroundColor,
    this.leading,
    this.leadingWidth,
    this.titleSpacing,
    this.titleTextStyle,
    this.titleWidth,
    this.toolbarTextStyle,
  })  : _sliver = false,
        pinned = false,
        floating = false,
        snap = false,
        stretch = false;

  final bool pinned;
  final bool floating;
  final bool snap;
  final bool stretch;

  const PageWindowTitleBar.sliver({
    super.key,
    this.actions,
    this.title,
    this.backgroundColor,
    this.actionsIconTheme,
    this.automaticallyImplyLeading = false,
    this.centerTitle,
    this.foregroundColor,
    this.leading,
    this.leadingWidth,
    this.titleSpacing,
    this.titleTextStyle,
    this.titleWidth,
    this.toolbarTextStyle,
    this.pinned = false,
    this.floating = false,
    this.snap = false,
    this.stretch = false,
  })  : _sliver = true,
        toolbarOpacity = 1;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<PageWindowTitleBar> createState() => _PageWindowTitleBarState();
}

class _PageWindowTitleBarState extends ConsumerState<PageWindowTitleBar> {
  void onDrag(details) {
    final systemTitleBar =
        ref.read(userPreferencesProvider.select((s) => s.systemTitleBar));
    if (kIsDesktop && !systemTitleBar) {
      windowManager.startDragging();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (widget._sliver) {
      return SliverLayoutBuilder(
        builder: (context, constraints) {
          final hasFullscreen =
              mediaQuery.size.width == constraints.crossAxisExtent;
          final hasLeadingOrCanPop =
              widget.leading != null || Navigator.canPop(context);

          return SliverPadding(
            padding: EdgeInsets.only(
              left: kIsMacOS && hasFullscreen && hasLeadingOrCanPop ? 65 : 0,
            ),
            sliver: SliverAppBar(
              leading: widget.leading,
              automaticallyImplyLeading: widget.automaticallyImplyLeading,
              actions: [
                ...?widget.actions,
                WindowTitleBarButtons(foregroundColor: widget.foregroundColor),
              ],
              backgroundColor: widget.backgroundColor,
              foregroundColor: widget.foregroundColor,
              actionsIconTheme: widget.actionsIconTheme,
              centerTitle: widget.centerTitle,
              titleSpacing: widget.titleSpacing,
              leadingWidth: widget.leadingWidth,
              toolbarTextStyle: widget.toolbarTextStyle,
              titleTextStyle: widget.titleTextStyle,
              title: SizedBox(
                width: double.infinity, // workaround to force dragging
                child: widget.title ?? const Text(""),
              ),
              pinned: widget.pinned,
              floating: widget.floating,
              snap: widget.snap,
              stretch: widget.stretch,
            ),
          );
        },
      );
    }

    return LayoutBuilder(builder: (context, constrains) {
      final hasFullscreen = mediaQuery.size.width == constrains.maxWidth;
      final hasLeadingOrCanPop =
          widget.leading != null || Navigator.canPop(context);

      return GestureDetector(
        onHorizontalDragStart: onDrag,
        onVerticalDragStart: onDrag,
        child: Padding(
          padding: EdgeInsets.only(
            left: kIsMacOS && hasFullscreen && hasLeadingOrCanPop ? 65 : 0,
          ),
          child: AppBar(
            leading: widget.leading,
            automaticallyImplyLeading: widget.automaticallyImplyLeading,
            actions: [
              ...?widget.actions,
              WindowTitleBarButtons(foregroundColor: widget.foregroundColor),
            ],
            backgroundColor: widget.backgroundColor,
            foregroundColor: widget.foregroundColor,
            actionsIconTheme: widget.actionsIconTheme,
            centerTitle: widget.centerTitle,
            titleSpacing: widget.titleSpacing,
            toolbarOpacity: widget.toolbarOpacity,
            leadingWidth: widget.leadingWidth,
            toolbarTextStyle: widget.toolbarTextStyle,
            titleTextStyle: widget.titleTextStyle,
            title: SizedBox(
              width: double.infinity, // workaround to force dragging
              child: widget.title ?? const Text(""),
            ),
            scrolledUnderElevation: 0,
            shadowColor: Colors.transparent,
            forceMaterialTransparency: true,
            elevation: 0,
          ),
        ),
      );
    });
  }
}
