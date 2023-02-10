import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:async';

class GameDataProvider extends ChangeNotifier {
  dynamic _gameData = null;
  late DateTime _time;
  dynamic get gameData => _gameData;
  set gameData(dynamic gameData) {
    _gameData = gameData;
    _time = DateTime.now();
    notifyListeners();
  }

  DateTime get time => _time;
}

class GameDataErrorProvider extends ChangeNotifier {
  int _error = 0;
  late DateTime _time;

  int get error => _error;
  set error(int error) {
    _time = DateTime.now();
    _error = error;
    notifyListeners();
  }

  DateTime get time => _time;
}

Future<void> getServerData(String serverName, BuildContext context) async {
  GameDataProvider gameDataProvider = context.read<GameDataProvider>();
  GameDataErrorProvider gameDataErrorProvider =
      context.read<GameDataErrorProvider>();
  var r = await http.get(Uri.https(
    'api.gametools.network',
    '/bf2042/players/',
    {
      'name': serverName,
    },
  ));
  var json = jsonDecode(r.body);
  if (json["serverinfo"] == null) {
    gameDataErrorProvider.error = r.statusCode;
  } else {
    gameDataProvider.gameData = json;
  }
}
