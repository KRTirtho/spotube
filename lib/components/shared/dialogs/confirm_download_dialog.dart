import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/root/sidebar.dart';

class ConfirmDownloadDialog extends StatelessWidget {
  const ConfirmDownloadDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformAlertDialog(
      macosAppIcon: Sidebar.brandLogo(),
      title: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: const [
            Text("Are you sure?"),
            SizedBox(width: 10),
            UniversalImage(
              path:
                  "https://c.tenor.com/kHcmsxlKHEAAAAAM/rock-one-eyebrow-raised-rock-staring.gif",
              height: 40,
              width: 40,
            )
          ],
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "If you download all Tracks at bulk you're clearly pirating Music & causing damage to the creative society of Music. I hope you are aware of this. Always, try respecting & supporting Artist's hard work",
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 10),
              Text(
                "BTW, your IP can get blocked on YouTube due excessive download requests than usual. IP block means you can't use YouTube (even if you're logged in) for at least 2-3 months from that IP device. And Spotube doesn't hold any responsibility if this ever happens",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 10),
              Text(
                "By clicking 'accept' you agree to following terms:",
              ),
              SizedBox(height: 10),
              BulletPoint("I know I'm pirating Music. I'm bad"),
              SizedBox(height: 10),
              BulletPoint(
                  "I'll support the Artist wherever I can and I'm only doing this because I don't have money to buy their art"),
              SizedBox(height: 10),
              BulletPoint(
                  "I'm completely aware that my IP can get blocked on YouTube & I don't hold Spotube or his owners/contributors responsible for any accidents caused by my current action"),
            ],
          ),
        ),
      ),
      primaryActions: [
        PlatformBuilder(
          android: (context, _) {
            return PlatformFilledButton(
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                backgroundColor: MaterialStatePropertyAll(Colors.red),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Accept"),
            );
          },
          ios: (context, data) {
            return CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(true),
              isDestructiveAction: true,
              child: const Text("Accept"),
            );
          },
        )
      ],
      secondaryActions: [
        PlatformBuilder(
          fallback: PlatformBuilderFallback.android,
          android: (context, _) {
            return PlatformFilledButton(
              child: const Text("Decline"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            );
          },
          ios: (context, data) {
            return CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context, false);
              },
              isDefaultAction: true,
              child: const Text("Decline"),
            );
          },
        ),
      ],
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("●"),
        const SizedBox(width: 5),
        Flexible(child: Text(text)),
      ],
    );
  }
}
