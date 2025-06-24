// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <<< Tambahkan ini
import 'package:endemicdb_new/providers/favorite_provider.dart'; // <<< Tambahkan ini
import 'package:endemicdb_new/screens/initial_splash_screen.dart';

void main() {
  runApp(const MyApp()); // Ganti MyApp() menjadi const MyApp() jika memungkinkan
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Tambahkan const constructor

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( // <<< Tambahkan ini
      create: (context) => FavoriteProvider(), // <<< Inisialisasi FavoriteProvider
      child: MaterialApp(
        title: 'EndemikDB',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: InitialSplashScreen(),
      ),
    );
  }
}