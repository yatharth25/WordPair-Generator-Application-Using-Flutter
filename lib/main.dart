import 'package:flutter/material.dart';
import 'package:wordpair/welcome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.deepPurple[900]),
        home: HomePage());
  }
}
