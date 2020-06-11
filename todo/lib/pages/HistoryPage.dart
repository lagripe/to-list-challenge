import 'package:flutter/material.dart';
import 'package:todo/common/common.dart';
import 'package:todo/database/DBProvider.dart';
import 'package:todo/widgets/expansion_tile_widget.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> history = [];
  @override
  void initState() {
    super.initState();
    DBProvider.db.getToDo(completed: 1).then((value) => setState(() =>
        history = value.map((e) => Map<String, dynamic>.from(e)).toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        backgroundColor: accentColor,
        actions: <Widget>[
          FlatButton(
            color: progressBarColor,
            textColor: Colors.white,
            child: Text(
              "Clear all",
            ),
            onPressed: () async {
              if (history.length == 0) {
                showToast("nothing to clear");
                return;
              }
              var rawsAffected = await DBProvider.db.deleteHistory();
              if (rawsAffected == 0) {
                showToast("Something went wrong, please try again");
                return;
              }
              if (mounted) {
                showToast("History cleared");
                setState(() {
                  history.clear();
                });
              }
            },
          )
        ],
      ),
      body: ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) => ExpansionTileWidget(
                item: history[index],
                isHistory: true,
              )),
    );
  }
}
