import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavIndexProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;
  set index(int index) {
    _index = index;
    notifyListeners();
  }
}

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

  @override
  Widget build(BuildContext context) {
    NavIndexProvider navIndexProvider = context.watch<NavIndexProvider>();
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
          navIndexProvider.index = index;
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
