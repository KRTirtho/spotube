bool containsTextInBracket(String matcher, String text) {
  return RegExp(r"(?<=\().+?(?=\))")
      .allMatches(matcher)
      .map((e) => e.group(0))
      .every((match) => match?.contains(text) ?? false);
}
