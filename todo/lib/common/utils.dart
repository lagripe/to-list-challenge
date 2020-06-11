import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

// algerian phone validator
//const phoneValidator = r'(^(?<code>\+?213)?|0)[576]\d{8}';
const phoneValidator = r'^\+213[567]\d{8}$';
// sms code regex
const codeValidator = r'^\d{6}';
// insert format formatter
const whenInsertDateFormat = 'yyyy-MM-dd HH:mm';
const whenDisplayedDateFormat = 'E, MMM d HH:mm';

showToast(msg) => Fluttertoast.showToast(
    msg: msg, gravity: ToastGravity.BOTTOM, toastLength: Toast.LENGTH_LONG);
validInput(pattern, text) => RegExp(pattern).hasMatch(text);
freeKeyboard(context) => FocusScope.of(context).requestFocus(FocusNode());
