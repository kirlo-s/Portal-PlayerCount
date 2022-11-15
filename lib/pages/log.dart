import 'package:flutter/material.dart';

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  bool isSet = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
      child: Text('Log'),
    ));
  }
}
