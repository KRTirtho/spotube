import 'package:flutter/cupertino.dart';
import 'package:spotify/spotify.dart';

class SpotifyDI extends ChangeNotifier {
  SpotifyApi _spotifyApi;

  SpotifyDI(this._spotifyApi);

  SpotifyApi get spotifyApi => _spotifyApi;
}
