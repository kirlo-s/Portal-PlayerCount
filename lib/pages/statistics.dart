import 'package:flutter/material.dart';
import 'package:portal_playercount/get_data.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool isSet = false;

  @override
  Widget build(BuildContext context) {
    StatisticsProvider statisticsProvider = context.read<StatisticsProvider>();
    DateTime _start = statisticsProvider.startTime;
    if (_start == DateTime(0, 0, 0, 0, 0)) {
      return Expanded(
        child: Center(
          child: Text("Set the server first!"),
        ),
      );
    } else {
      return Expanded(
          child: Center(
        child: Text(statisticsProvider.playedMinList.toString()),
      ));
    }
  }
}
