import 'package:spotube/collections/env.dart';
import 'package:spotube/models/source_match.dart';
import 'package:supabase/supabase.dart';

class SupabaseService {
  static final api = SupabaseClient(
    Env.supabaseUrl ?? "",
    Env.supabaseAnonKey ?? "",
  );

  Future<void> insertTrack(SourceMatch track) async {
    return null;
    // TODO: Fix this
    await api.from("tracks").insert(track.toJson());
  }
}

final supabase = SupabaseService();
