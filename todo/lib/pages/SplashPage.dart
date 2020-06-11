import 'package:flutter/material.dart';
import 'package:todo/common/common.dart';
import 'package:todo/database/DBProvider.dart';
import 'package:todo/pages/HomePage.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  GlobalKey<HomePageState> homePageKey;
  @override
  initState() {
    super.initState();
    homePageKey = GlobalKey<HomePageState>();
    print(homePageKey);
    Timer(Duration(seconds: 1), () async {
      var unCompletedTasksCount = await DBProvider.db.countToDo(completed: 0);
      var items = await DBProvider.db.getToDo(
        completed: 0,
      );
      items = items.map((e) => Map<String, dynamic>.from(e)).toList();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    items: items,
                    unCompletedTasksCount: unCompletedTasksCount,
                    homePageKey: homePageKey,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      body: Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
      )),
    );
  }
}
