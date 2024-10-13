extension UniqueItemExtension<T> on List<T> {
  List<T> unique(bool Function(T a, T b) equals) {
    final copy = <T>[];

    for (final item in this) {
      if (copy.any((element) => equals(element, item))) continue;
      copy.add(item);
    }

    return copy;
  }

  bool containsBy(T item, dynamic Function(T a) fn) {
    for (final el in this) {
      if (fn(el) == fn(item)) return true;
    }
    return false;
  }
}
