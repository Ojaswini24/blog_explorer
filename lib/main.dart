import 'package:blog_explorer/get_started.dart';
import 'package:flutter/material.dart';
import 'blog_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetStarted(),
    );
  }
}
