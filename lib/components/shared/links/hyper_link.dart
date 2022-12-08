import 'package:flutter/material.dart';
import 'package:spotube/components/shared/links/anchor_button.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Hyperlink extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final String url;
  const Hyperlink(
    this.text,
    this.url, {
    Key? key,
    this.textAlign,
    this.overflow,
    this.style = const TextStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnchorButton(
      text,
      onTap: () async {
        await launchUrlString(
          url,
          mode: LaunchMode.externalApplication,
        );
      },
      key: key,
      overflow: overflow,
      style: style.copyWith(color: Colors.blue),
      textAlign: textAlign,
    );
  }
}
