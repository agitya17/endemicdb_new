// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/favorite_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EndemicDB',
      theme: ThemeData(primarySwatch: Colors.green),
      home: SplashScreen(),
    );
  }
}