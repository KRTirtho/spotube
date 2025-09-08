import 'package:html_unescape/html_unescape.dart';
import 'package:html/parser.dart';

final htmlEscape = HtmlUnescape();

extension UnescapeHtml on String {
  String cleanHtml() => parse("<p>$this</p>").documentElement!.text;
  String unescapeHtml() => htmlEscape.convert(this);
}

extension NullableUnescapeHtml on String? {
  String? cleanHtml() => this?.cleanHtml();
  String? unescapeHtml() => this?.unescapeHtml();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
