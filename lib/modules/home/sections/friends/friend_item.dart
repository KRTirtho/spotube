import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/models/spotify_friends.dart';
import 'package:spotube/pages/album/album.dart';
import 'package:spotube/pages/artist/artist.dart';
import 'package:spotube/pages/track/track.dart';
import 'package:spotube/provider/spotify_provider.dart';

class FriendItem extends HookConsumerWidget {
  final SpotifyFriendActivity friend;
  const FriendItem({
    super.key,
    required this.friend,
  });

  @override
  Widget build(BuildContext context, ref) {
    final spotify = ref.watch(spotifyProvider);

    return Card(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Avatar(
            initials: Avatar.getInitials(friend.user.name),
            provider: UniversalImage.imageProvider(
              friend.user.imageUrl,
            ),
          ),
          const Gap(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                friend.user.name,
                style: context.theme.typography.bold,
              ),
              RichText(
                text: TextSpan(
                  style: context.theme.typography.normal.copyWith(
                    color: context.theme.colorScheme.foreground,
                  ),
                  children: [
                    TextSpan(
                      text: friend.track.name,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.pushNamed(TrackPage.name, pathParameters: {
                            "id": friend.track.id,
                          });
                        },
                    ),
                    const TextSpan(text: " • "),
                    const WidgetSpan(
                      child: Icon(
                        SpotubeIcons.artist,
                        size: 12,
                      ),
                    ),
                    TextSpan(
                      text: " ${friend.track.artist.name}",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.pushNamed(
                            ArtistPage.name,
                            pathParameters: {
                              "id": friend.track.artist.id,
                            },
                            extra: friend.track.artist,
                          );
                        },
                    ),
                    const TextSpan(text: "\n"),
                    TextSpan(
                      text: friend.track.context.name,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          context.push(
                            "/${friend.track.context.path}",
                            extra:
                                !friend.track.context.path.startsWith("album")
                                    ? null
                                    : await spotify.albums
                                        .get(friend.track.context.id),
                          );
                        },
                    ),
                    const TextSpan(text: " • "),
                    const WidgetSpan(
                      child: Icon(
                        SpotubeIcons.album,
                        size: 12,
                      ),
                    ),
                    TextSpan(
                      text: " ${friend.track.album.name}",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final album =
                              await spotify.albums.get(friend.track.album.id);
                          if (context.mounted) {
                            context.pushNamed(
                              AlbumPage.name,
                              pathParameters: {
                                "id": friend.track.album.id,
                              },
                              extra: album,
                            );
                          }
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
