import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/dialogs/link_open_permission_dialog.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppMarkdown extends StatelessWidget {
  final String data;
  const AppMarkdown({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      imageBuilder: (uri, title, alt) {
        final url = uri.toString();
        return CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
        );
      },
      onTapLink: (text, href, title) async {
        final allowOpeningLink = await showDialog<bool>(
          context: context,
          builder: (context) {
            return LinkOpenPermissionDialog(href: href);
          },
        );

        if (href != null && allowOpeningLink == true) {
          launchUrlString(
            href,
            mode: LaunchMode.externalApplication,
          );
        }
      },
    );
  }
}
