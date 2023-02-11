import 'package:flutter/material.dart';
import 'package:portal_playercount/pages/registar.dart';
import 'package:portal_playercount/pages/watchdog.dart';
import 'package:provider/provider.dart';
import 'package:portal_playercount/utils/get_data.dart';

class HomePageProvider extends ChangeNotifier {
  String _serverId = "";

  String get serverId => _serverId;
  set serverId(String serverId) {
    _serverId = serverId;
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSet = false;

  @override
  Widget build(BuildContext context) {
    return Pages(context);
  }
}

Widget Pages(BuildContext context) {
  HomePageProvider homePageProvider = context.watch<HomePageProvider>();
  if (homePageProvider.serverId == "") {
    return Registar();
  } else {
    return Watchdog();
  }
}
