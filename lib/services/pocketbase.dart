import 'package:catcher/catcher.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:spotube/collections/env.dart';

final pb = PocketBase(Env.pocketbaseUrl);
bool isLoggedIn = false;
Future<void> initializePocketBase() async {
  try {
    await pb.collection("users").authWithPassword(Env.username, Env.password);
    isLoggedIn = true;
  } catch (e, stack) {
    Catcher.reportCheckedError(e, stack);
  }
}
