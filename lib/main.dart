// main.dart

import 'package:flutter/material.dart';
import 'package:endemicdb_new/screens/initial_splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EndemikDB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InitialSplashScreen(),
    );
  }
}