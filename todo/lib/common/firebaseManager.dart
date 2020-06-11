import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/common/common.dart';
import 'package:todo/common/utils.dart';
import 'package:todo/database/DBProvider.dart';
import 'package:todo/pages/SyncPage.dart';

abstract class FirebaseManager {
  // Auth
  static FirebaseAuth auth = FirebaseAuth.instance;
  static Firestore firestore = Firestore.instance;
  static Future<void> logOut() async {
    await auth.signOut();
  }

  static Future sendVerificationCode(context, phoneNumber) async {
    if (!RegExp(phoneValidator).hasMatch(phoneNumber)) {
      showToast("Please enter a valid phone number");
    }
    await FirebaseManager.auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 120),
        verificationCompleted: (AuthCredential credential) async {
          var user =
              await FirebaseManager.auth.signInWithCredential(credential);
          if (user == null) {
            showToast("Authentification error");

            return;
          }
          //Success
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SyncPage(),
              ));
        },
        verificationFailed: (AuthException e) {
          showToast("Unable to sign in");
        },
        codeSent: (verificationId, [_]) => showDialog(
            barrierDismissible: true,
            context: context,
            builder: (contextDialog) {
              TextEditingController _codeController = TextEditingController();
              return AlertDialog(
                title: Text('SMS Verification'),
                content: Theme(
                  data: Theme.of(context).copyWith(
                      primaryColor: accentColor,
                      textSelectionHandleColor: accentColor),
                  child: TextField(
                      cursorColor: Colors.black,
                      controller: _codeController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.verified_user),
                          labelText: 'Code received',
                          hintText: '6 digits number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: accentColor),
                            borderRadius: BorderRadius.circular(10),
                          ))),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Submit"),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (!validInput(codeValidator, _codeController.text)) {
                        showToast(
                            "Verification code must be of 6 digits length");
                        return;
                      }
                      try {
                        var credentials = PhoneAuthProvider.getCredential(
                            verificationId: verificationId,
                            smsCode: _codeController.text);
                        var user = await FirebaseManager.auth
                            .signInWithCredential(credentials);
                        if (user == null) {
                          showToast("Authentification error");
                        }
                        //Success
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SyncPage(),
                            ));
                      } catch (e) {
                        showToast("Invalid Verification Code");
                      }
                    },
                  )
                ],
              );
            }),
        codeAutoRetrievalTimeout: null);
  }

  static deleteOldSync() async => await firestore
      .collection('todo')
      .document((await auth.currentUser()).phoneNumber)
      .collection('tasks')
      .getDocuments()
      .then((value) => value.documents.forEach((doc) {
            doc.reference.delete();
          }));
  static Future<bool> syncNow() async {
    try {
      var phoneId = (await auth.currentUser()).phoneNumber;
      var refCollection =
          firestore.collection('todo').document(phoneId).collection('tasks');
      await deleteOldSync();
      return await DBProvider.db.getAllToDo().then((tasks) {
        try {
          tasks.forEach((element) async {
            //element['phoneId'] = phoneId;
            await refCollection.add(element);
          });
          return true;
        } catch (e) {
          return false;
        }
      }).catchError((e) => false);
    } catch (e) {
      return false;
    }
  }
}
