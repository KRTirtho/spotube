bool containsTextInBracket(String matcher, String text) {
  final allMatches = RegExp(r"(?<=\().+?(?=\))").allMatches(matcher);
  if (allMatches.isEmpty) return false;
  return allMatches
      .map((e) => e.group(0))
      .every((match) => match?.contains(text) ?? false);
}
