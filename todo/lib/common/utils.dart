import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

// algerian phone validator
//const phoneValidator = r'(^(?<code>\+?213)?|0)[576]\d{8}';
const phoneValidator = r'^\+213[567]\d{8}$';
// sms code regex
const codeValidator = r'^\d{6}';
// insert format formatter
const whenInsertDateFormat = 'yyyy-MM-dd HH:mm';
const whenDisplayedDateFormat = 'E, MMM d HH:mm';
// port unique name for workmanager
const portName = 'todo_app';
const taskName = 'notifier';

// due by time timeframe
const timeframe = 5;

showToast(msg) => Fluttertoast.showToast(
    msg: msg, gravity: ToastGravity.BOTTOM, toastLength: Toast.LENGTH_LONG);

validInput(pattern, text) => RegExp(pattern).hasMatch(text);

freeKeyboard(context) => FocusScope.of(context).requestFocus(FocusNode());

Future<void> popNotification(message, flp) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'channel id',
    'channel name',
    'channel description',
    playSound: true,
    priority: Priority.High,
    importance: Importance.High,
    sound: RawResourceAndroidNotificationSound('sound_beep'),
  );
  var iOS = IOSNotificationDetails();
  var platformChannelSpecifics =
      NotificationDetails(androidPlatformChannelSpecifics, iOS);
  await flp.show(
    0,
    'TODO Manager',
    message,
    platformChannelSpecifics,
  );
}
