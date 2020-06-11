import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/common/common.dart';

class ExpansionTileWidget extends StatefulWidget {
  final Map<String, dynamic> item;
  final Function onDeleted;
  final Function onComplete;
  final bool isHistory;
  ExpansionTileWidget(
      {@required this.item,
      this.onDeleted,
      this.isHistory = false,
      this.onComplete});
  @override
  _ExpansionTileWidgetState createState() => _ExpansionTileWidgetState();
}

class _ExpansionTileWidgetState extends State<ExpansionTileWidget> {
  @override
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.item['title']),
      subtitle: Text(DateFormat(whenDisplayedDateFormat)
          .format(DateTime.parse(widget.item['date']))),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.item['desc'],
                style: shortDescColorTextStyle,
              ),
              !widget.isHistory
                  ? Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          color: Colors.red[800],
                          icon: Icon(
                            Icons.delete,
                            size: 30,
                          ),
                          onPressed: () {
                            widget.onDeleted(widget.item);
                          },
                        ),
                        IconButton(
                          color: Colors.green[800],
                          icon: Icon(
                            Icons.check,
                            size: 30,
                          ),
                          onPressed: () {
                            widget.onComplete(widget.item);
                          },
                        )
                      ],
                    )
                  : Container()
            ],
          ),
        )
      ],
    );
  }
}
