import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_undraw/flutter_undraw.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';

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
            context.l10n.no_default_metadata_provider_selected,
            style: context.theme.typography.h4,
            maxLines: 1,
          ),
          Button.primary(
            leading: const Icon(SpotubeIcons.extensions),
            child: Text(context.l10n.manage_metadata_providers),
            onPressed: () {
              context.pushRoute(const SettingsMetadataProviderRoute());
            },
          ),
        ],
      ),
    );
  }
}
