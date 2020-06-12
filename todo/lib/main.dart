import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo/pages/SplashPage.dart';
import 'package:workmanager/workmanager.dart';

import 'common/common.dart';
import 'database/DBProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager.initialize(callbackDispatcher, isInDebugMode: false);
  await Workmanager.registerPeriodicTask(portName, taskName,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: Duration(minutes: 15),
      initialDelay: Duration(seconds: 10),
      constraints: Constraints(networkType: NetworkType.not_required));

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => SplashPage(),
    },
  ));
}

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) async {
    print('############### Background Notifier');
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('notifier_icon');
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, ios);
    flp.initialize(initSettings);
    var tasks = await DBProvider.db.getDueByTimeTasks();
    if (tasks > 0)
      popNotification("You have $tasks uncompleted task(s)", flp);

    return Future.value(true);
  });
}
