import 'package:flutter/material.dart';
import 'package:tasktide/screens/tasks/tasks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Tide',
      home: TasksScreen(),
    );
  }
}
