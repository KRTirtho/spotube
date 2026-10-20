import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/theme/spotify_colors.dart';
import 'package:spotube/theme/spotify_typography.dart';
import 'package:spotube/components/hover_builder.dart';

class SpotifyTopBar extends HookConsumerWidget {
  final ScrollController? scrollController;

  const SpotifyTopBar({this.scrollController, super.key});

  @override
  Widget build(BuildContext context, ref) {
    final textTheme = SpotifyTypography.buildTextTheme(context);
    final scrolled = useState(false);

    useEffect(() {
      void listener() {
        final value = (scrollController?.offset ?? 0) > 8;
        if (value != scrolled.value) scrolled.value = value;
      }
      scrollController?.addListener(listener);
      return () => scrollController?.removeListener(listener);
    }, [scrollController]);

    final bgColor = scrolled.value
        ? SpotifyColors.background.withValues(alpha: 0.92)
        : Colors.transparent;

    return SizedBox(
      height: 64,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            color: bgColor,
            child: Row(
              children: [
                _NavButton(icon: Icons.arrow_back_rounded, tooltip: 'Back'),
                const SizedBox(width: 8),
                _NavButton(icon: Icons.arrow_forward_rounded, tooltip: 'Forward'),
                const SizedBox(width: 24),
                const Spacer(),
                _PremiumButton(),
                const SizedBox(width: 16),
                _IconButton(icon: Icons.notifications_none_rounded, tooltip: 'Notifications'),
                const SizedBox(width: 12),
                _ProfileAvatar(),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends HookConsumerWidget {
  final IconData icon;
  final String tooltip;

  const _NavButton({required this.icon, required this.tooltip});

  @override
  Widget build(BuildContext context, ref) {
    final textTheme = SpotifyTypography.buildTextTheme(context);
    return HoverBuilder(
      builder: (context, hovering) {
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: hovering ? SpotifyColors.hover : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: Icon(icon, color: SpotifyColors.primaryText, size: 18),
            onPressed: () {},
            tooltip: tooltip,
          ),
        );
      },
    );
  }
}

class _PremiumButton extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final textTheme = SpotifyTypography.buildTextTheme(context);
    return HoverBuilder(
      builder: (context, hovering) {
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: SpotifyColors.primaryText,
            side: const BorderSide(color: SpotifyColors.primaryText),
            backgroundColor: hovering ? SpotifyColors.hover : Colors.transparent,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {},
          child: Text(
            'Explore Premium',
            style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }
}

class _IconButton extends HookConsumerWidget {
  final IconData icon;
  final String tooltip;

  const _IconButton({required this.icon, required this.tooltip});

  @override
  Widget build(BuildContext context, ref) {
    return HoverBuilder(
      builder: (context, hovering) {
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: hovering ? SpotifyColors.hover : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: Icon(icon, color: SpotifyColors.primaryText, size: 18),
            onPressed: () {},
            tooltip: tooltip,
          ),
        );
      },
    );
  }
}

class _ProfileAvatar extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    return HoverBuilder(
      builder: (context, hovering) {
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: hovering ? SpotifyColors.hover : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: SpotifyColors.secondaryText, width: 0.5),
          ),
          child: const Icon(Icons.person_rounded, color: SpotifyColors.primaryText, size: 18),
        );
      },
    );
  }
}
