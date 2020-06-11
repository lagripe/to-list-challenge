import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/common/common.dart';
import 'package:todo/database/DBProvider.dart';
import 'package:todo/models/todoModel.dart';
import 'package:todo/pages/HomePage.dart';

class AddTaskPage extends StatefulWidget {
  final GlobalKey<HomePageState> homePageKey;
  AddTaskPage({@required this.homePageKey});
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate;
  TimeOfDay _selectedTime;
  TextEditingController _titleController, _shortDescController;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0);
    _titleController = TextEditingController();
    _shortDescController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _shortDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => freeKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: accentColor,
          title: Text("Add Task"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                freeKeyboard(context);
                if (!beforeSubmissionValidator()) return;

                var newTask = TODO(
                    title: _titleController.text.trim(),
                    date: mergeSelectedDateAndTime(),
                    desc: _shortDescController.text.trim(),
                    isCompleted: false);
                //
                /// Insert Task to db
                ///
                var id = await DBProvider.db.addToDo(newTask);
                if (id != null) {
                  var item = newTask.toMap();
                  item['id'] = id;
                  showToast("Task added");
                  widget.homePageKey.currentState.itemAddedNotifier(item);
                  Navigator.pop(context);
                } else {
                  showToast("Something went wrong, please try again");
                }
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: <Widget>[
                _buildTextField(
                    context: context,
                    controller: _titleController,
                    hint: "type your title here",
                    label: "title"),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      _buildTimeAndDateWidget(_selectedDate, 2,
                          onTap: () async => _selectDate(context)),
                      SizedBox(
                        width: 8,
                      ),
                      _buildTimeAndDateWidget(_selectedTime, 1,
                          onTap: () async => _selectTime(context),
                          context: context)
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _buildTextField(
                    context: context,
                    controller: _shortDescController,
                    hint: "add a short description about your task",
                    label: "short decription",
                    isRichText: true)
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  /// Hybrid widget contructor to build both title & description textfields
  ///
  _buildTextField({context, controller, label, hint, isRichText = false}) =>
      Theme(
        data: Theme.of(context).copyWith(
            primaryColor: accentColor, textSelectionHandleColor: accentColor),
        child: TextField(
          keyboardType:
              isRichText ? TextInputType.multiline : TextInputType.text,
          maxLines: isRichText ? 5 : 1,
          cursorColor: Colors.black,
          controller: controller,
          decoration: InputDecoration(
              hintText: hint,
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: accentColor, width: 1.3),
                borderRadius: BorderRadius.circular(10),
              )),
        ),
      );

  ///
  /// Hybrid widget contructor to build both time & date widgets
  ///
  _buildTimeAndDateWidget(selectedTimeOrDate, flex,
          {context, @required onTap}) =>
      Flexible(
        flex: flex,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Container(
            child: Center(
              child: Text(
                selectedTimeOrDate.runtimeType == DateTime
                    ? DateFormat('E, MMMd').format(selectedTimeOrDate)
                    : (selectedTimeOrDate as TimeOfDay).format(context),
                style: dateAndTimeTextStyle,
              ),
            ),
            decoration: BoxDecoration(
                color: accentColor, borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked_s = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: _selectedDate,
    );
    if (picked_s != null) setState(() => _selectedDate = picked_s);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked_s != null) setState(() => _selectedTime = picked_s);
  }

  ///
  /// Validate data before submission
  ///
  beforeSubmissionValidator() {
    ///
    /// Validate title
    ///
    if (_titleController.text.trim().isEmpty) {
      showToast("Title is required");
      return false;
    }

    ///
    /// Validate date & time
    /// Merge _selectedDate with _selectedTime
    DateTime temporaryDate = mergeSelectedDateAndTime();
    if (DateTime.now().compareTo(temporaryDate) >= 0) {
      showToast("Please select a valid date and time");
      return false;
    }
    return true;
  }

  mergeSelectedDateAndTime() {
    DateTime temp =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    temp = temp.add(
        Duration(hours: _selectedTime.hour, minutes: _selectedTime.minute));
    print(temp);
    return temp;
  }
}
