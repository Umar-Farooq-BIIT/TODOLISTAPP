import 'package:flutter/material.dart';
import 'package:todo_app1/AppTheme/appTheme.dart';
import 'package:todo_app1/Screens/addnewtask.dart';
import 'package:todo_app1/Screens/homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      home:HomeScreen()
    );
  }
}
