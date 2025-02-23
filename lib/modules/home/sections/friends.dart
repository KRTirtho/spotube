import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/modules/home/sections/friends/friend_item.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class HomePageFriendsSection extends HookConsumerWidget {
  const HomePageFriendsSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authenticationProvider);
    final friendsQuery = ref.watch(friendsProvider);
    final friends =
        friendsQuery.asData?.value.friends ?? FakeData.friends.friends;

    if (friendsQuery.isLoading ||
        friendsQuery.asData?.value.friends.isEmpty == true ||
        auth.asData?.value == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            context.l10n.friends,
            style: context.theme.typography.h4,
          ),
        ),
        SizedBox(
          height: 80 * context.theme.scaling,
          width: double.infinity,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: PointerDeviceKind.values.toSet(),
              scrollbars: false,
            ),
            child: Skeletonizer(
              enabled: friendsQuery.isLoading,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: friends.length,
                separatorBuilder: (context, index) => const Gap(8),
                itemBuilder: (context, index) {
                  return FriendItem(friend: friends[index]);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
