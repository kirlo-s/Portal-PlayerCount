import 'package:flutter/material.dart';
import 'package:portal_playercount/get_data.dart';
import 'package:portal_playercount/nav_rail.dart';
import 'package:portal_playercount/pages/analytics.dart';
import 'package:portal_playercount/pages/home.dart';
import 'package:portal_playercount/pages/log.dart';
import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:system_tray/system_tray.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<NavIndexProvider>(
          create: (context) => NavIndexProvider(),
        ),
        ChangeNotifierProvider<HomePageProvider>(
          create: (context) => HomePageProvider(),
        ),
        ChangeNotifierProvider<GameDataProvider>(
          create: (context) => GameDataProvider(),
        ),
        ChangeNotifierProvider<GameDataErrorProvider>(
          create: (context) => GameDataErrorProvider(),
        ),
      ],
      child: MaterialApp(
        home: MyApp(),
      ),
    ),
  );
  doWhenWindowReady(() {
    final initialSize = Size(1200, 675);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal PlayerCount',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'PlayerCount'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(children: <Widget>[
        NavRail(),
        MainField(),
      ]),
    );
  }
}

class MainField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NavIndexProvider navIndexProvider = context.watch<NavIndexProvider>();
    return Container(
      child: pages(navIndexProvider.index),
    );
  }
}

Widget pages(int index) {
  if (index == 0) {
    return HomePage();
  } else if (index == 1) {
    return LogPage();
  } else if (index == 2) {
    return AnalyticsPage();
  }
  return Text("null returned");
}
