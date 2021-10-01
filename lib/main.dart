import 'package:flutter/material.dart';
import 'package:note_keper/Homepage.dart';
import 'package:note_keper/addNote.dart';

import 'package:note_keper/sqflit_hleper.dart';
import 'package:note_keper/sqflit_model.dart';

void main() {
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
      debugShowCheckedModeBanner: false,
      title: 'NOTE KEPER',
      home: Home(),
    );
  }
}
