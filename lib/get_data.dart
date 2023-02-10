import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    updateStatistics(context);
  }
}

class TimerStoreProvider with ChangeNotifier {
  String serverName = '';
  late BuildContext context;
  late Timer _timer;
  initTimer(BuildContext context) {
    this.context = context;
  }

  startTimer(String serverName) {
    this.serverName = serverName;
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      updateCounter();
    });
  }

  void updateCounter() {
    getServerData(serverName, context);
  }
}

Future<void> updateStatistics(BuildContext context) async {
  GameDataProvider gameDataProvider = context.read<GameDataProvider>();
  StatisticsProvider statisticsProvider = context.read<StatisticsProvider>();

  Map<String, int> playerlist = {};

  dynamic gamedata = gameDataProvider.gameData;
  dynamic team1 = gamedata["teams"][0]["players"];
  dynamic team2 = gamedata["teams"][1]["players"];
  dynamic team = team1 + team2;
  DateTime now = DateTime.now();
  for (var p in team) {
    String name = p["name"];
    DateTime joined = DateTime.fromMicrosecondsSinceEpoch(p["join_time"]);
    int dif = now.difference(joined).inMinutes;
    playerlist[name] = dif;
  }
  Map<String, int> prev = statisticsProvider.players;

  /*if you add new stat, add here*/
  prev.forEach((key, value) {
    if (playerlist.containsKey(key) == false) {
      int index = (value ~/ 15) > 10 ? 10 : (value ~/ 15);
      print("$value:$index");
      statisticsProvider.playedMin(index);
    }
  });

  statisticsProvider.players = playerlist;
}

class StatisticsProvider extends ChangeNotifier {
  DateTime _startTime = DateTime(0, 0, 0, 0, 0);
  Map<String, int> _players = {};
  List<int> list = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  set players(Map<String, int> players) {
    _players = players;
  }

  set startTime(DateTime time) {
    _startTime = time;
  }

  void playedMin(int index) {
    list[index] += 1;
    notifyListeners();
  }

  List<int> get playedMinList => list;
  Map<String, int> get players => _players;
  DateTime get startTime => _startTime;
}
