import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/settings/section_card_with_heading.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/pages/profile/profile.dart';
import 'package:spotube/pages/mobile_login/hooks/login_callback.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/scrobbler/scrobbler.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:spotube/utils/service_utils.dart';

class SettingsAccountSection extends HookConsumerWidget {
  const SettingsAccountSection({super.key});

  @override
  Widget build(context, ref) {
    final theme = Theme.of(context);
    final router = GoRouter.of(context);

    final auth = ref.watch(authenticationProvider);
    final scrobbler = ref.watch(scrobblerProvider);
    final me = ref.watch(meProvider);
    final meData = me.asData?.value;

    final logoutBtnStyle = FilledButton.styleFrom(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
    );

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
              child: CircleAvatar(
                backgroundImage: UniversalImage.imageProvider(
                  (meData?.images).asUrlString(
                    placeholder: ImagePlaceholder.artist,
                  ),
                ),
              ),
            ),
            onTap: () {
              ServiceUtils.pushNamed(context, ProfilePage.name);
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
                  : FilledButton(
                      onPressed: onLogin,
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
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
              trailing: FilledButton(
                style: logoutBtnStyle,
                onPressed: () async {
                  ref.read(authenticationProvider.notifier).logout();
                  GoRouter.of(context).pop();
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
            trailing: FilledButton.icon(
              icon: const Icon(SpotubeIcons.lastFm),
              label: Text(context.l10n.connect),
              onPressed: () {
                router.push("/lastfm-login");
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 186, 0, 0),
                foregroundColor: Colors.white,
              ),
            ),
          )
        else
          ListTile(
            leading: const Icon(SpotubeIcons.lastFm),
            title: Text(context.l10n.disconnect_lastfm),
            trailing: FilledButton(
              onPressed: () {
                ref.read(scrobblerProvider.notifier).logout();
              },
              style: logoutBtnStyle,
              child: Text(context.l10n.disconnect),
            ),
          ),
      ],
    );
  }
}
