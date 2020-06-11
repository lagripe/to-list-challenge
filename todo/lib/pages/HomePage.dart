import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/common/common.dart';
import 'package:todo/database/DBProvider.dart';
import 'package:todo/pages/AddTaskPage.dart';
import 'package:todo/widgets/drawer_widget.dart';
import 'package:todo/widgets/expansion_tile_widget.dart';
import 'package:todo/widgets/uncompleted_tasks_widget.dart';

class HomePage extends StatefulWidget {
  final int unCompletedTasksCount;
  final List<Map<String, dynamic>> items;

  ///
  /// Managing home page state without query the new items by passing the global key
  ///
  final GlobalKey<HomePageState> homePageKey;
  HomePage(
      {@required this.unCompletedTasksCount,
      @required this.items,
      @required this.homePageKey})
      : super(key: homePageKey);
  @override
  HomePageState createState() =>
      HomePageState(items: items, unCompletedTasksCount: unCompletedTasksCount);
}

class HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> items;
  int unCompletedTasksCount;
  HomePageState({@required this.items, @required this.unCompletedTasksCount});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: Scaffold(
        drawer: DrawerWidget(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 100,
              backgroundColor: accentColor,
              title: Text("TODO APP"),
              flexibleSpace: FlexibleSpaceBar(
                  background:
                      UncompletedTasksWidget(tasks: unCompletedTasksCount)),
            ),
            items.length == 0
                ? SliverFillRemaining(
                    child: Center(
                      child: Text("Empty"),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildListDelegate(List.generate(
                        items.length,
                        (index) => ExpansionTileWidget(
                            item: items[index],
                            onComplete: (value) async {
                              int rowsAffetcted = await DBProvider.db
                                  .updateToDo(value['id'] as int);

                              if (rowsAffetcted == 0) {
                                showToast(
                                    "Something went wrong, please try again");
                                return;
                              }
                              setState(() {
                                items.remove(value);
                                unCompletedTasksCount--;
                              });
                              showToast("Task marked as completed");
                            },
                            onDeleted: (item) async {
                              var rowsAffetcted = await DBProvider.db
                                  .deleteToDo(item['id'] as int);
                              if (rowsAffetcted == 0) {
                                showToast(
                                    "Something went wrong, please try again");
                                return;
                              }
                              setState(() {
                                items.remove(item);
                                unCompletedTasksCount--;
                              });
                              showToast("Task deleted");
                            }))))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.event),
            backgroundColor: progressBarColor,
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTaskPage(
                          homePageKey: widget.homePageKey,
                        )))),
      ),
    );
  }

  itemAddedNotifier(Map<String, dynamic> item) {
    if (mounted)
      setState(() {
        unCompletedTasksCount++;
        items = [item] + items;
      });
  }
}
