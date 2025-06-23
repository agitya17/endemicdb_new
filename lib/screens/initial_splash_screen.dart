// screens/initial_splash_screen.dart

import 'package:flutter/material.dart';
import 'package:endemicdb_new/screens/splash_screen.dart';

class InitialSplashScreen extends StatelessWidget {
  const InitialSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SplashScreen()),
            );
          },
          child: Image.asset(
            'assets/images/app_logo.png', // Pastikan path ini benar
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}