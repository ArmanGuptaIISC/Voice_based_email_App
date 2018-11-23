import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttermail/login_page.dart';
import 'flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:fluttermail/recognizer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Voice Based Email",
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.lightBlue,
        brightness: Brightness.light
      ),
      home: new LoginPage(),
    );

  }
}


