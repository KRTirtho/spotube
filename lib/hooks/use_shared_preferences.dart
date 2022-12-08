import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? useSharedPreferences() {
  final future = useMemoized(SharedPreferences.getInstance);
  final snapshot = useFuture(future, initialData: null);

  return snapshot.data;
}
