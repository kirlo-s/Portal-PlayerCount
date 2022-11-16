import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class GameDataProvider extends ChangeNotifier {
  dynamic _gameData = null;

  dynamic get gameData => _gameData;
  set gameData(dynamic gameData) {
    _gameData = gameData;
    notifyListeners();
  }
}

Future<void> getServerData(String serverName, BuildContext context) async {
  GameDataProvider gameDataProvider = context.read<GameDataProvider>();
  var r = await http.get(Uri.https(
    'api.gametools.network',
    '/bf2042/players/',
    {
      'name': serverName,
    },
  ));
  var json = jsonDecode(r.body);
  gameDataProvider.gameData = json;
}
