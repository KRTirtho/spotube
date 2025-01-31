import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart' show ListTile;

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/settings/section_card_with_heading.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/pages/mobile_login/hooks/login_callback.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/scrobbler/scrobbler.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class SettingsAccountSection extends HookConsumerWidget {
  const SettingsAccountSection({super.key});

  @override
  Widget build(context, ref) {
    final theme = Theme.of(context);

    final auth = ref.watch(authenticationProvider);
    final scrobbler = ref.watch(scrobblerProvider);
    final me = ref.watch(meProvider);
    final meData = me.asData?.value;

    final onLogin = useLoginCallback(ref);

    return SectionCardWithHeading(
      heading: context.l10n.account,
      children: [
        if (auth.asData?.value != null)
          ListTile(
            leading: const Icon(SpotubeIcons.user),
            title: Text(context.l10n.user_profile),
            trailing: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Avatar(
                initials: Avatar.getInitials(meData?.displayName ?? "User"),
                provider: UniversalImage.imageProvider(
                  (meData?.images).asUrlString(
                    placeholder: ImagePlaceholder.artist,
                  ),
                ),
              ),
            ),
            onTap: () {
              context.navigateTo(ProfileRoute());
            },
          ),
        if (auth.asData?.value == null)
          LayoutBuilder(builder: (context, constrains) {
            return ListTile(
              leading: Icon(
                SpotubeIcons.spotify,
                color: theme.colorScheme.primary,
              ),
              title: Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  context.l10n.login_with_spotify,
                  maxLines: 1,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              onTap: constrains.mdAndUp ? null : onLogin,
              trailing: constrains.smAndDown
                  ? null
                  : Button.primary(
                      onPressed: onLogin,
                      child: Text(
                        context.l10n.connect_with_spotify.toUpperCase(),
                      ),
                    ),
            );
          })
        else
          Builder(builder: (context) {
            return ListTile(
              leading: const Icon(SpotubeIcons.spotify),
              title: SizedBox(
                height: 50,
                width: 180,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    context.l10n.logout_of_this_account,
                    maxLines: 1,
                  ),
                ),
              ),
              trailing: Button.destructive(
                onPressed: () async {
                  ref.read(authenticationProvider.notifier).logout();
                  context.maybePop();
                },
                child: Text(context.l10n.logout),
              ),
            );
          }),
        if (scrobbler.asData?.value == null)
          ListTile(
            leading: const Icon(SpotubeIcons.lastFm),
            title: Text(context.l10n.login_with_lastfm),
            subtitle: Text(context.l10n.scrobble_to_lastfm),
            trailing: Button.secondary(
              leading: const Icon(SpotubeIcons.lastFm),
              onPressed: () {
                context.navigateTo(const LastFMLoginRoute());
              },
              child: Text(context.l10n.connect),
            ),
          )
        else
          ListTile(
            leading: const Icon(SpotubeIcons.lastFm),
            title: Text(context.l10n.disconnect_lastfm),
            trailing: Button.destructive(
              onPressed: () {
                ref.read(scrobblerProvider.notifier).logout();
              },
              child: Text(context.l10n.disconnect),
            ),
          ),
      ],
    );
  }
}
