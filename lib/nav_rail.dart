import 'package:flutter/material.dart';
import 'package:portal_playercount/pages/analytics.dart';
import 'package:portal_playercount/pages/home.dart';
import 'package:portal_playercount/pages/log.dart';

class NavRail extends StatefulWidget {
  _NavRailState createState() => _NavRailState();
}

class _NavRailState extends State<NavRail> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();

    _selectedIndex = 0;
  }

/*
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    LogPage(),
    AnalyticsPage(),
  ];
*/
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
        elevation: 5,
        extended: true,
        minExtendedWidth: 200,
        selectedIndex: _selectedIndex,
        destinations: _buildDestinations(),
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        });
  }

  List<NavigationRailDestination> _buildDestinations() {
    return [
      const NavigationRailDestination(
        icon: Icon(Icons.home),
        label: Text('Home'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.notes),
        label: Text('Log'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.analytics),
        label: Text('Analytics'),
      ),
    ];
  }
}
