import 'package:flutter/cupertino.dart';
import 'package:mpv_dart/mpv_dart.dart';

class PlayerDI extends ChangeNotifier {
  MPVPlayer _player;

  PlayerDI(this._player);

  get player => _player;

  setPlayer(MPVPlayer player) {
    _player = player;
    notifyListeners();
  }
}
