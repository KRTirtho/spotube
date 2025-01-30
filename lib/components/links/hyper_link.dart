import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/links/anchor_button.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Hyperlink extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final String url;
  final int? maxLines;

  const Hyperlink(
    this.text,
    this.url, {
    super.key,
    this.textAlign,
    this.overflow,
    this.style = const TextStyle(),
    this.maxLines,
  });

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
      maxLines: maxLines,
      style: style.copyWith(color: Colors.blue),
      textAlign: textAlign,
    );
  }
}
