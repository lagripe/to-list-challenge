import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/common/common.dart';

class TODO {
  String title;
  DateTime date;
  String desc;
  bool isCompleted;
  TODO(
      {@required this.title,
      @required this.date,
      @required this.desc,
      @required this.isCompleted});
  toMap() => {
        'title': title,
        'date': DateFormat(whenInsertDateFormat).format(date),
        'desc': desc,
        'isCompleted': isCompleted ? 1 : 0
      };
  readyInsert() =>
      [title, DateFormat(whenInsertDateFormat).format(date), desc, '0'];
}
