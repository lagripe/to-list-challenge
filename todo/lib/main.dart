import 'package:flutter/material.dart';
import 'package:todo/pages/SplashPage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => SplashPage(),
    },
  ));
}
