import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LinkOpenPermissionDialog extends StatelessWidget {
  final String? href;
  const LinkOpenPermissionDialog({super.key, this.href});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: AlertDialog(
        title: Row(
          spacing: 8,
          children: [
            const Icon(SpotubeIcons.warning),
            Text(context.l10n.open_link_in_browser),
          ],
        ),
        content: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text:
                    "${context.l10n.do_you_want_to_open_the_following_link}:\n",
              ),
              if (href != null)
                TextSpan(
                  text: "$href\n\n",
                  style: const TextStyle(color: Colors.blue),
                ),
              TextSpan(text: context.l10n.unsafe_url_warning),
            ],
          ),
        ),
        actions: [
          Button.ghost(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          Button.ghost(
            onPressed: () {
              if (href != null) {
                Clipboard.setData(ClipboardData(text: href!));
              }
              Navigator.of(context).pop(false);
            },
            child: Text(context.l10n.copy_link),
          ),
          Button.destructive(
            onPressed: () {
              if (href != null) {
                launchUrlString(
                  href!,
                  mode: LaunchMode.externalApplication,
                );
              }
              Navigator.of(context).pop(true);
            },
            child: Text(context.l10n.open),
          ),
        ],
      ),
    );
  }
}
