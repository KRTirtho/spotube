import 'package:flutter/material.dart';

import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';

class ConfirmDownloadDialog extends StatelessWidget {
  const ConfirmDownloadDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Text(context.l10n.are_you_sure),
            const SizedBox(width: 10),
            const UniversalImage(
              path:
                  "https://c.tenor.com/kHcmsxlKHEAAAAAM/rock-one-eyebrow-raised-rock-staring.gif",
              height: 40,
              width: 40,
            )
          ],
        ),
      ),
      content: Container(
        padding: const EdgeInsets.all(15),
        constraints: BoxConstraints(maxWidth: Breakpoints.sm),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.download_warning,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              Text(
                context.l10n.download_ip_ban_warning,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              Text(
                context.l10n.by_clicking_accept_terms,
              ),
              const SizedBox(height: 10),
              BulletPoint(context.l10n.download_agreement_1),
              const SizedBox(height: 10),
              BulletPoint(context.l10n.download_agreement_2),
              const SizedBox(height: 10),
              BulletPoint(context.l10n.download_agreement_3),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          child: Text(context.l10n.decline),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(context.l10n.accept),
        ),
      ],
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("\u2022"),
        const SizedBox(width: 5),
        Flexible(child: Text(text)),
      ],
    );
  }
}
