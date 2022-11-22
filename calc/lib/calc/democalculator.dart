import 'package:flutter/material.dart';

import 'ScientificCalculator.dart';
import 'SimpleCalculator.dart';

class DdemoCalculator extends StatelessWidget {
  DdemoCalculator({Key? key}) : super(key: key);
  static const routeName = '/demo-screen';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Calculator',
        home: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return DemoCalculator();
          } else {
            return DemoCalculator();
          }
        }));
  }

}