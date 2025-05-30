import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(BucketCatchGameApp());
}

class BucketCatchGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bucket Catch Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}