import 'package:html_unescape/html_unescape.dart';

final htmlEscape = HtmlUnescape();

extension UnescapeHtml on String {
  String unescapeHtml() => htmlEscape.convert(this);
}

extension NullableUnescapeHtml on String? {
  String? unescapeHtml() => this?.unescapeHtml();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
