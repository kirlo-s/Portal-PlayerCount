import 'package:flutter/material.dart';
import 'package:portal_playercount/pages/home.dart';
import "package:provider/provider.dart";
import "package:portal_playercount/get_data.dart";

class Registar extends StatefulWidget {
  _RegistarState createState() => _RegistarState();
}

class _RegistarState extends State<Registar> {
  String serverName = "";

  void showProgressDialog(context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration.zero, // これを入れると遅延を入れなくて
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    HomePageProvider homePageProvider = context.watch<HomePageProvider>();
    final BuildContext context2 = context;
    return Expanded(
      child: Scaffold(
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
                child: SizedBox(
              width: 400,
              child: TextFormField(
                decoration: InputDecoration(labelText: 'ServerName'),
                onChanged: (text) {
                  setState(() {
                    serverName = text;
                  });
                },
              ),
            )),
            Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                child: const Text('Button'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  elevation: 0,
                ),
                onPressed: serverName == ""
                    ? null
                    : () async {
                        showProgressDialog(context);
                        await Future<dynamic>.delayed(Duration(seconds: 2));
                        await getServerData(serverName, context);
                        Navigator.of(context, rootNavigator: true).pop();
                        homePageProvider.serverId = serverName;
                      },
              ),
            ),
          ],
        )),
      ),
    );
  }
}
