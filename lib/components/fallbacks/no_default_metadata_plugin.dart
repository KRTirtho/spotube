import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_undraw/flutter_undraw.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';

class NoDefaultMetadataPlugin extends StatelessWidget {
  const NoDefaultMetadataPlugin({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Undraw(
            height: 200 * context.theme.scaling,
            illustration: UndrawIllustration.stars,
            color: context.theme.colorScheme.primary,
          ),
          AutoSizeText(
            "You've no default metadata provider set",
            style: context.theme.typography.h4,
            maxLines: 1,
          ),
          Button.primary(
            leading: const Icon(SpotubeIcons.extensions),
            child: const Text("Manage metadata providers"),
            onPressed: () {
              context.pushRoute(const SettingsMetadataProviderRoute());
            },
          ),
        ],
      ),
    );
  }
}
