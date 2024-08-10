import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/links/anchor_button.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/artist/artist.dart';
import 'package:spotube/utils/service_utils.dart';

class ArtistLink extends StatelessWidget {
  final List<ArtistSimple> artists;
  final WrapCrossAlignment crossAxisAlignment;
  final WrapAlignment mainAxisAlignment;
  final TextStyle textStyle;
  final bool hideOverflowArtist;
  final void Function(String route)? onRouteChange;
  final VoidCallback? onOverflowArtistClick;

  const ArtistLink({
    super.key,
    required this.artists,
    this.crossAxisAlignment = WrapCrossAlignment.center,
    this.mainAxisAlignment = WrapAlignment.center,
    this.textStyle = const TextStyle(),
    this.onRouteChange,
    this.hideOverflowArtist = true,
    this.onOverflowArtistClick,
  }) : assert(hideOverflowArtist ? onOverflowArtistClick != null : true);

  @override
  Widget build(BuildContext context) {
    final ThemeData(:colorScheme) = Theme.of(context);

    return Wrap(
      crossAxisAlignment: crossAxisAlignment,
      alignment: mainAxisAlignment,
      children: [
        ...(hideOverflowArtist ? artists.take(3).toList() : artists)
            .asMap()
            .entries
            .map(
              (artist) => Builder(builder: (context) {
                if (artist.value.name == null) {
                  return Text("Spotify", style: textStyle);
                }
                return AnchorButton(
                  (artist.key != artists.length - 1)
                      ? "${artist.value.name}, "
                      : artist.value.name!,
                  onTap: () {
                    if (onRouteChange != null) {
                      onRouteChange?.call("/artist/${artist.value.id}");
                    } else {
                      ServiceUtils.pushNamed(
                        context,
                        ArtistPage.name,
                        pathParameters: {
                          "id": artist.value.id!,
                        },
                      );
                    }
                  },
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                );
              }),
            ),
        if (hideOverflowArtist && artists.length > 3)
          AnchorButton(
            context.l10n.and_n_more(artists.length - 3),
            onTap: () {
              onOverflowArtistClick?.call();
            },
            overflow: TextOverflow.ellipsis,
            style: textStyle.copyWith(
              color: colorScheme.secondary,
              decoration: TextDecoration.underline,
            ),
          ),
      ],
    );
  }
}
