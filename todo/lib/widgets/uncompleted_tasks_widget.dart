import 'package:flutter/cupertino.dart';
import 'package:todo/common/common.dart';

class UncompletedTasksWidget extends StatelessWidget {
  final int tasks;
  UncompletedTasksWidget({@required this.tasks});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RichText(
            textAlign: TextAlign.end,
            
            text: TextSpan(
                text: tasks.toString(),
                style: countTasksStyle,
                children: [
                  TextSpan(
                      text: " Uncompleted ${tasks > 1 ? 'tasks' : 'task'}",
                      style: spanCountTasks)
                ]),
          )
        ],
      ),
    );
  }
}
