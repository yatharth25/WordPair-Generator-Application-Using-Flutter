import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:wordpair/random_words.dart';
import 'package:wordpair/welcome.dart';
import 'dart:convert';

bool isLogged = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final data = await FlutterSession().get("email");
  print(data);
  if (data != '') {
    isLogged = true;
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.deepPurple[900]),
        home: isLogged ? RandomWords() : HomePage());
  }
}
