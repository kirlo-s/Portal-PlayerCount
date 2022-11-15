import 'package:flutter/material.dart';

class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  bool isSet = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
      child: Text('Analytics'),
    ));
  }
}
