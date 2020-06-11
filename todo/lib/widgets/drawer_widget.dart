import 'package:flutter/material.dart';
import 'package:todo/common/common.dart';
import 'package:todo/common/firebaseManager.dart';
import 'package:todo/pages/HistoryPage.dart';
import 'package:todo/pages/SyncPage.dart';

class DrawerWidget extends StatefulWidget {
  @override
  DrawerWidgetState createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 8.0,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text("Some logo"),
            ),
            decoration: BoxDecoration(color: accentColor),
          ),
          ListTile(
            title: Text("History"),
            subtitle: Text("My completed tasks"),
            leading: Icon(Icons.history),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(),
                )),
          ),
          ListTile(
            title: Text("Cloud Synchronization"),
            subtitle: Text("upload all tasks to cloud"),
            leading: Icon(Icons.history),
            onTap: () async {
              var firebaseUser = await FirebaseManager.auth.currentUser();
              TextEditingController _phoneController = TextEditingController();
              if (firebaseUser != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SyncPage(),
                    ));
                return;
              }
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                    title: Text("Sync"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Phone textfield
                        Theme(
                          data: Theme.of(context).copyWith(
                              primaryColor: accentColor,
                              textSelectionHandleColor: accentColor),
                          child: TextField(
                            cursorColor: Colors.black,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                labelText: 'Phone Number',
                                hintText: 'Your phone number (+2136...)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ),
                        FlatButton(
                          color: accentColor,
                          textColor: Colors.white,
                          child: Text('Send Code'),
                          onPressed: () async {
                            try {
                              await FirebaseManager.sendVerificationCode(
                                context,
                                _phoneController.text,
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              showToast("Please check your connectivity");
                            }
                            // send sms code
                          },
                        )
                      ],
                    )),
              );
            },
          ),
        ],
      ),
    );
  }
}
