import 'package:flutter/material.dart';
import 'package:mis_lab_1/screens/details.dart';
import 'package:mis_lab_1/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Распоред за испити',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade300),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) =>
            const MyHomePage(title: 'Распоред за испити - 215046'),
        "/details": (context) => const DetailsPage(),
      },
    );
  }
}
