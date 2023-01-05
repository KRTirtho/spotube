import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

extension MultiSortListMap on List<Map> {
  /// [preference] - List of properties in which you want to sort the list
  /// i.e.
  /// ```
  /// List<String> preference = ['property1','property2'];
  /// ```
  /// This will first sort the list by property1 then by property2
  ///
  /// [criteria] - List of booleans that specifies the criteria of sort
  /// i.e., For ascending order `true` and for descending order `false`.
  /// ```
  /// List<bool> criteria = [true. false];
  /// ```
  List<Map> sortByProperties(List<bool> criteria, List<String> preference) {
    if (preference.isEmpty || criteria.isEmpty || isEmpty) {
      return this;
    }
    if (preference.length != criteria.length) {
      print('Criteria length is not equal to preference');
      return this;
    }

    int compare(int i, Map a, Map b) {
      if (a[preference[i]] == b[preference[i]]) {
        return 0;
      } else if (a[preference[i]] > b[preference[i]]) {
        return criteria[i] ? 1 : -1;
      } else {
        return criteria[i] ? -1 : 1;
      }
    }

    int sortAll(Map a, Map b) {
      int i = 0;
      int result = 0;
      while (i < preference.length) {
        result = compare(i, a, b);
        if (result != 0) break;
        i++;
      }
      return result;
    }

    return sorted((a, b) => sortAll(a, b));
  }
}

extension MultiSortListTupleMap<V> on List<Tuple2<Map, V>> {
  /// [preference] - List of properties in which you want to sort the list
  /// i.e.
  /// ```
  /// List<String> preference = ['property1','property2'];
  /// ```
  /// This will first sort the list by property1 then by property2
  ///
  /// [criteria] - List of booleans that specifies the criteria of sort
  /// i.e., For ascending order `true` and for descending order `false`.
  /// ```
  /// List<bool> criteria = [true. false];
  /// ```
  List<Tuple2<Map, V>> sortByProperties(
      List<bool> criteria, List<String> preference) {
    if (preference.isEmpty || criteria.isEmpty || isEmpty) {
      return this;
    }
    if (preference.length != criteria.length) {
      print('Criteria length is not equal to preference');
      return this;
    }

    int compare(int i, Tuple2<Map, V> a, Tuple2<Map, V> b) {
      if (a.item1[preference[i]] == b.item1[preference[i]]) {
        return 0;
      } else if (a.item1[preference[i]] > b.item1[preference[i]]) {
        return criteria[i] ? 1 : -1;
      } else {
        return criteria[i] ? -1 : 1;
      }
    }

    int sortAll(Tuple2<Map, V> a, Tuple2<Map, V> b) {
      int i = 0;
      int result = 0;
      while (i < preference.length) {
        result = compare(i, a, b);
        if (result != 0) break;
        i++;
      }
      return result;
    }

    return sorted((a, b) => sortAll(a, b));
  }
}
