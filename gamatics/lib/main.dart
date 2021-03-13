import 'package:flutter/material.dart';
import 'package:gamatics/form.dart';
import 'package:gamatics/Add_Competition.dart';
import 'package:provider/provider.dart';
import 'meet_name.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: Form_screen(),
      routes: {
        "add_competition": (context) => Add_competition(),
        "Form_screen": (context) => Form_screen(),
        "Competition_name": (context) => Competition_name(),
      },
    );
  }
}
