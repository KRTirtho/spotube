import 'package:flutter/widgets.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/links/anchor_button.dart';
import 'package:spotube/pages/artist/artist.dart';
import 'package:spotube/utils/service_utils.dart';

class ArtistLink extends StatelessWidget {
  final List<ArtistSimple> artists;
  final WrapCrossAlignment crossAxisAlignment;
  final WrapAlignment mainAxisAlignment;
  final TextStyle textStyle;
  final void Function(String route)? onRouteChange;

  const ArtistLink({
    super.key,
    required this.artists,
    this.crossAxisAlignment = WrapCrossAlignment.center,
    this.mainAxisAlignment = WrapAlignment.center,
    this.textStyle = const TextStyle(),
    this.onRouteChange,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: crossAxisAlignment,
      alignment: mainAxisAlignment,
      children: artists
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
          )
          .toList(),
    );
  }
}
