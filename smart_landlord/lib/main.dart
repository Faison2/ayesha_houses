import 'package:flutter/material.dart';
import 'package:smart_landlord/screens/splash/splash.dart';

void main() => runApp(const BeitbridgeCrusadeApp());

class BeitbridgeCrusadeApp extends StatelessWidget {
  const BeitbridgeCrusadeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Landlord',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const HomeScreen(),
    );
  }
}