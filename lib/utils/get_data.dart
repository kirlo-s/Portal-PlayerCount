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
  DateTime now = DateTime.now();
  GameDataProvider gameDataProvider = context.read<GameDataProvider>();
  StatisticsProvider statisticsProvider = context.read<StatisticsProvider>();

  Map<String, int> playerMinutesList = {};
  Map<String, String> playerPlatformList = {};

  dynamic gamedata = gameDataProvider.gameData;
  dynamic team1 = gamedata["teams"][0]["players"];
  dynamic team2 = gamedata["teams"][1]["players"];
  dynamic team = team1 + team2;
  String serverName = gamedata["serverinfo"]["name"];
  statisticsProvider.serverName = serverName;
  for (var p in team) {
    String name = p["name"];
    DateTime joined = DateTime.fromMicrosecondsSinceEpoch(p["join_time"]);
    int dif = now.difference(joined).inMinutes;
    String platform = p["platform"];
    playerMinutesList[name] = dif;
    playerPlatformList[name] = platform;
  }
  Map<String, int> prevMin = statisticsProvider.playersMin;
  Map<String, String> prevPl = statisticsProvider.playersPl;

  /*if you add new stat, add here*/
  int count = 0;
  playerMinutesList.forEach((key, value) {
    if (prevMin.containsKey(key) == false) {
      count++;
      if (playerPlatformList[key] == "pc") {
        statisticsProvider.platform(0);
      } else if (playerPlatformList[key] == "psn") {
        statisticsProvider.platform(1);
      } else if (playerPlatformList[key] == "xbox") {
        statisticsProvider.platform(2);
      }
    }
  });
  DateTime baseTime = statisticsProvider.graphTime;
  if (statisticsProvider.graphCount < 5) {
    statisticsProvider.addTimeData(baseTime, count);
    statisticsProvider.addCount();
  } else {
    statisticsProvider.addTimeData(now, count);
    statisticsProvider.graphTime = now;
    statisticsProvider.resetCount();
    statisticsProvider.addCount();
  }
  statisticsProvider.addCountJoined = count;
  prevMin.forEach((key, value) {
    if (playerMinutesList.containsKey(key) == false) {
      int index = (value ~/ 15) >= 10 ? 9 : (value ~/ 15);
      statisticsProvider.playedMin(index);
    }
  });
  statisticsProvider.playersMin = playerMinutesList;
}

class StatisticsProvider extends ChangeNotifier {
  DateTime _startTime = DateTime(0, 0, 0, 0, 0);
  DateTime _graphTime = DateTime(0, 0, 0, 0, 0);
  int _graphCount = 0;
  Map<String, int> _players = {};
  Map<String, String> _playersPl = {};
  List<int> list = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  int _countJoined = 0;
  String _serverName = "";
  List<int> _platform = [0, 0, 0];
  Map<DateTime, int> _timeData = {};

  set graphTime(DateTime graphTime) {
    _graphTime = graphTime;
  }

  void addTimeData(DateTime time, int count) {
    _timeData[time] = (_timeData[time] == null ? 0 : _timeData[time]!) + count;
  }

  void addCount() {
    _graphCount += 1;
  }

  void resetCount() {
    _graphCount = 0;
  }

  set playersPl(Map<String, String> playersPl) {
    _playersPl = playersPl;
  }

  set playersMin(Map<String, int> players) {
    _players = players;
  }

  set startTime(DateTime time) {
    _startTime = time;
  }

  void playedMin(int index) {
    list[index] += 1;
    notifyListeners();
  }

  set addCountJoined(int newplayers) {
    _countJoined += newplayers;
  }

  set serverName(String serverName) {
    _serverName = serverName;
  }

  void platform(int index) {
    _platform[index] += 1;
  }

  List<int> get platformList => _platform;
  List<int> get playedMinList => list;
  Map<String, int> get playersMin => _players;
  Map<String, String> get playersPl => _playersPl;
  Map<DateTime, int> get timeData => _timeData;
  DateTime get startTime => _startTime;
  DateTime get graphTime => _graphTime;
  int get countJoined => _countJoined;
  String get serverName => _serverName;
  int get graphCount => _graphCount;
}
