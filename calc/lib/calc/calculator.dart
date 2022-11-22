import 'package:flutter/material.dart';

import 'ScientificCalculator.dart';
import 'SimpleCalculator.dart';

class PremiumCalculator extends StatelessWidget {
  static const routeName = '/premium-screen';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Calculator',
        home: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            //return DemoCalculator();
            return ScientificCalculator();
          } else {
            return ScientificCalculator();
          }
        }));
  }
}