
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'calc/ScientificCalculator.dart';
import 'calc/SimpleCalculator.dart';
import 'calc/calculator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scientific Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.orange,
      ),
      home: ScientificCalculator(),
    );
  }
}