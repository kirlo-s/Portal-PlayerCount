import 'package:flutter/material.dart';
import 'package:portal_playercount/utils/get_data.dart';
import 'package:portal_playercount/pages/home.dart';
import 'package:portal_playercount/pages/registar.dart';
import "package:provider/provider.dart";
import "package:intl/intl.dart";

class Watchdog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _screenSize = MediaQuery.of(context).size;
    GameDataProvider gameDataProvider = context.watch<GameDataProvider>();
    GameDataErrorProvider gameDataErrorProvider =
        context.watch<GameDataErrorProvider>();
    dynamic gamedata = gameDataProvider.gameData;
    int _playercount = 0;

    if (gamedata == null) {
      return ErrorPage(context);
    } else {
      dynamic team1 = gamedata["teams"][0];
      dynamic team2 = gamedata["teams"][1];
      _playercount = gamedata["teams"][0]["players"].length +
          gamedata["teams"][1]["players"].length;
      DateTime _time_d = gameDataProvider.time;
      String _time = DateFormat("yyyy-MM-dd(E) hh:mm").format(_time_d);
      return Expanded(
        child: Column(children: [
          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      gamedata["serverinfo"]["name"],
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 0,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Map:" + gamedata["serverinfo"]["currentMap"],
                                style: const TextStyle(fontSize: 25)),
                            Column(mainAxisSize: MainAxisSize.min, children: [
                              const Text(
                                "PlayerAmount:",
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "$_playercount",
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.green),
                              )
                            ]),
                          ]),
                    )),
                    Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 0.1,
                              blurRadius: 5.0,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.all(10),
                        width: _screenSize.width * 0.3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Image.network(gamedata["serverinfo"]["url"],
                              fit: BoxFit.cover),
                        )),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Card(
              child: Column(
                children: [
                  Row(
                    children: [
                      TeamCard(team1),
                      TeamCard(team2),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        PlayerList(context, team1),
                        PlayerList(context, team2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: _screenSize.width,
            child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "Last Update:$_time",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                )),
          )
        ]),
      );
    }
  }
}

Widget ErrorPage(BuildContext context) {
  GameDataProvider gameDataProvider = context.watch<GameDataProvider>();
  HomePageProvider homePageProvider = context.watch<HomePageProvider>();
  GameDataErrorProvider gameDataErrorProvider =
      context.watch<GameDataErrorProvider>();
  int _status = gameDataErrorProvider.error;
  return Expanded(
      child: Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text("Error:Cannot get the server data!"),
      ErrorText(_status),
      Padding(
        padding: EdgeInsets.all(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
            elevation: 0,
          ),
          onPressed: () {
            homePageProvider.serverId = "";
          },
          child: const Text('Return'),
        ),
      ),
    ]),
  ));
}

Widget ErrorText(int status) {
  if (status == 201) {
    return const Text("Error 201:API error");
  } else if (status == 404) {
    return const Text("Error 404: Server not found");
  } else if (status == 422) {
    return const Text("Error 422: Validation error");
  } else {
    return const Text("Unknown error");
  }
}

Widget PlayerList(BuildContext context, dynamic team) {
  return Expanded(
      child: Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(2),
    ),
    child: team["players"].length > 0
        ? ListView.builder(
            itemCount: team["players"].length,
            itemBuilder: (BuildContext context, int index) {
              return PlayerCard(team["players"][index]);
            },
          )
        : const Text("No Items"),
  ));
}

Widget PlayerCard(dynamic playerdata) {
  DateTime now = DateTime.now();
  DateTime joined =
      DateTime.fromMicrosecondsSinceEpoch(playerdata["join_time"]);
  var dif = now.difference(joined).inMinutes;
  return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      margin: const EdgeInsets.all(1),
      child: Container(
          margin: EdgeInsets.all(1),
          child: Row(
            children: [
              Expanded(child: Text(playerdata["name"])),
              Text("$dif min")
            ],
          )));
}

Widget TeamCard(team) {
  return Expanded(
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Row(
            children: [
              Expanded(
                  child: Text(team["shortName"],
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Image.network(
                team["image"],
                width: 16 * 2,
                height: 9 * 2,
              ),
            ],
          )));
}
