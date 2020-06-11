import 'package:flutter/material.dart';
import 'package:todo/common/common.dart';
import 'package:todo/common/firebaseManager.dart';

class SyncPage extends StatefulWidget {
  @override
  _SyncPageState createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentColor,
        title: Text("Sync to cloud"),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            color: progressBarColor,
            child: Text("Sign out"),
            onPressed: () async {
              await FirebaseManager.auth.signOut();
              showToast("You've signed out from the cloud");
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: FlatButton(
              color: accentColor,
              textColor: Colors.white,
              child: Text("Sync now"),
              onPressed: () async {
                if (await FirebaseManager.syncNow()) {
                  showToast("Your tasks has been synced up");
                } else {
                  showToast("Unable to sync, please check you connection");
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
