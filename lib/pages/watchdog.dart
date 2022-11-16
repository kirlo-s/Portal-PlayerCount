import 'package:flutter/material.dart';
import 'package:portal_playercount/get_data.dart';
import 'package:portal_playercount/pages/home.dart';
import 'package:portal_playercount/pages/registar.dart';
import "package:provider/provider.dart";
import "package:intl/intl.dart";

class Watchdog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _screenSize = MediaQuery.of(context).size;
    GameDataProvider gameDataProvider = context.watch<GameDataProvider>();
    dynamic gamedata = gameDataProvider.gameData;
    int _playercount = 0;

    try {
      dynamic team1 = gamedata["teams"][0];
      dynamic team2 = gamedata["teams"][1];
      _playercount = gamedata["teams"][0]["players"].length +
          gamedata["teams"][1]["players"].length;
      return Expanded(
        child: Column(children: [
          Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
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
                              Text(
                                "PlayerAmount:",
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "$_playercount",
                                style: TextStyle(
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
            child: Row(
              children: <Widget>[
                PlayerList(context, team1),
                PlayerList(context, team2),
              ],
            ),
          ),
        ]),
      );
    } catch (e) {
      return ErrorPage(context);
    }
  }
}

Widget ErrorPage(BuildContext context) {
  GameDataProvider gameDataProvider = context.watch<GameDataProvider>();
  HomePageProvider homePageProvider = context.watch<HomePageProvider>();
  return Expanded(
      child: Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text("Error:Cannot get the server data!"),
      Padding(
        padding: EdgeInsets.all(10),
        child: ElevatedButton(
          child: const Text('Return'),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
            elevation: 0,
          ),
          onPressed: () {
            homePageProvider.serverId = "";
          },
        ),
      ),
    ]),
  ));
}

Widget PlayerList(BuildContext context, dynamic team) {
  return Expanded(
      child: Card(
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
