import 'package:spotube/models/matched_track.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient get api => Supabase.instance.client;

  Future<void> insertTrack(MatchedTrack track) async {
    await api.from("tracks").insert(track.toJson());
  }
}

final supabase = SupabaseService();
