import 'package:spotube/collections/env.dart';
import 'package:spotube/models/matched_track.dart';
import 'package:supabase/supabase.dart';

class SupabaseService {
  static final api = SupabaseClient(
    Env.supabaseUrl ?? "",
    Env.supabaseAnonKey ?? "",
  );

  Future<void> insertTrack(MatchedTrack track) async {
    await api.from("tracks").insert(track.toJson());
  }
}

final supabase = SupabaseService();
