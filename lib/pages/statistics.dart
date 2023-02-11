import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portal_playercount/utils/get_data.dart';
import 'package:portal_playercount/utils/indicator.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int touchedIndex = -1;
  bool isSet = false;
  final label = [
    "15",
    "30",
    "45",
    "60",
    "75",
    "90",
    "105",
    "120",
    "135",
    "135"
  ];
  final color = [
    Colors.indigo,
    Colors.blue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.red,
    Colors.pink,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    StatisticsProvider statisticsProvider = context.watch<StatisticsProvider>();
    DateTime _start = statisticsProvider.startTime;
    DateTime now = DateTime.now();
    var dif = now.difference(_start).inMinutes;
    String countPlayer = statisticsProvider.countJoined.toString();
    String serverName = statisticsProvider.serverName;
    int all = 0;
    List<int> playedMinList = statisticsProvider.playedMinList;
    /*  statisticsProvider.playedMinList */
    for (var i in playedMinList) {
      all += i;
    }
    if (_start == DateTime(0, 0, 0, 0, 0)) {
      return const Expanded(
        child: Center(
          child: Text("Set the server first!"),
        ),
      );
    } else if (all == 0) {
      return const Expanded(
        child: Center(
          child: Text("Wait for initialize!"),
        ),
      );
    } else {
      return Expanded(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Card(
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  serverName,
                                  style: const TextStyle(fontSize: 30),
                                )))),
                    Column(
                      children: [
                        Text("${dif.toString()} minutes elapsed "),
                        Text("$countPlayer players joined")
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: Card(
              child: elapsedMinutesGraph(playedMinList),
            ))
          ],
        ),
      );
    }
  }

  Widget elapsedMinutesGraph(List<int> list) {
    return Column(children: [
      const Padding(
          padding: EdgeInsets.all(10),
          child: Align(
              alignment: Alignment.center,
              child: Text(
                "Participation time",
                style: TextStyle(fontSize: 20),
              ))),
      Expanded(
          child: Row(children: [
        Expanded(
            child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            }),
            sections: pieChartSections(list),
            startDegreeOffset: -90,
          ),
          swapAnimationDuration: const Duration(milliseconds: 150), // Optional
          swapAnimationCurve: Curves.linear, // Optional
        )),
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: indicatiors(list),
          ),
          width: 100,
        )
      ]))
    ]);
  }

  List<PieChartSectionData> pieChartSections(List<int> list) {
    int all = 0;
    for (var i in list) {
      all += i;
    }

    List<PieChartSectionData> selections = [];
    int n = 0;
    for (int i = 0; i < 10; i++) {
      if (list[i] > 0) {
        PieChartSectionData select = PieChartSectionData(
            title: ((list[i] / all) * 100).round().toString() + "%",
            value: list[i].toDouble(),
            color: color[i],
            borderSide: touchedIndex == n
                ? const BorderSide(color: Colors.black, width: 6)
                : const BorderSide(color: Colors.transparent));
        selections.add(select);
        n++;
      }
    }
    return selections;
  }

  List<Widget> indicatiors(List<int> list) {
    List<Widget> indicators = [];
    int n = 0;
    for (int i = 0; i < 10; i++) {
      if (list[i] > 0) {
        indicators.add(Indicator(
            color: touchedIndex == n || touchedIndex == -1
                ? color[i]
                : Colors.transparent,
            text: i < 9 ? "~${label[i]}min" : label[i] + "min~",
            size: touchedIndex == n || touchedIndex == -1 ? 25 : 16,
            textColor: touchedIndex == n || touchedIndex == -1
                ? Colors.black
                : Colors.grey,
            isSquare: false));
        n++;
      }
    }
    return indicators;
  }
}
