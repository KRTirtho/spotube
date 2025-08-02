import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
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
            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: AlertDialog(
                title: const Row(
                  spacing: 8,
                  children: [
                    Icon(SpotubeIcons.warning),
                    Text("Open Link in Browser?"),
                  ],
                ),
                content: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Do you want to open the following link:\n",
                      ),
                      if (href != null)
                        TextSpan(
                          text: "$href\n\n",
                          style: const TextStyle(color: Colors.blue),
                        ),
                      const TextSpan(
                        text:
                            "It can be unsafe to open links from untrusted sources. Be cautious!\n"
                            "You can also copy the link to your clipboard.",
                      ),
                    ],
                  ),
                ),
                actions: [
                  Button.ghost(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  Button.ghost(
                    onPressed: () {
                      if (href != null) {
                        Clipboard.setData(ClipboardData(text: href));
                      }
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("Copy Link"),
                  ),
                  Button.destructive(
                    onPressed: () {
                      if (href != null) {
                        launchUrlString(
                          href,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Open"),
                  ),
                ],
              ),
            );
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
