import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSet = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
      child: Text('Home'),
    ));
  }
}
