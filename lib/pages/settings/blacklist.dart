import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/button/back_button.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/components/ui/button_tile.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class BlackListPage extends HookConsumerWidget {
  static const name = "blacklist";

  const BlackListPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final controller = useScrollController();
    final blacklist = ref.watch(blacklistProvider);
    final searchText = useState("");

    final filteredBlacklist = useMemoized(
      () {
        if (searchText.value.isEmpty) {
          return blacklist.asData?.value ?? [];
        }
        return blacklist.asData?.value
                .map(
                  (e) => (
                    weightedRatio(
                        "${e.name} ${e.elementType.name}", searchText.value),
                    e,
                  ),
                )
                .sorted((a, b) => b.$1.compareTo(a.$1))
                .where((e) => e.$1 > 50)
                .map((e) => e.$2)
                .toList() ??
            [];
      },
      [blacklist, searchText.value],
    );

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: [
          TitleBar(
            title: Text(context.l10n.blacklist),
            leading: const [BackButton()],
          )
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => searchText.value = value,
                placeholder: Text(context.l10n.search),
                // prefixIcon: const Icon(SpotubeIcons.search),
              ),
            ),
            InterScrollbar(
              controller: controller,
              child: ListView.builder(
                controller: controller,
                shrinkWrap: true,
                itemCount: filteredBlacklist.length,
                itemBuilder: (context, index) {
                  final item = filteredBlacklist.elementAt(index);
                  return ButtonTile(
                    style: ButtonVariance.ghost,
                    leading: Text("${index + 1}."),
                    title: Text("${item.name} (${item.elementType.name})"),
                    subtitle: Text(item.elementId),
                    trailing: IconButton.ghost(
                      icon: Icon(SpotubeIcons.trash, color: Colors.red[400]),
                      onPressed: () {
                        ref.read(blacklistProvider.notifier).remove(
                            filteredBlacklist.elementAt(index).elementId);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
