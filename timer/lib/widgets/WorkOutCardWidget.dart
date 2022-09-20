
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/note.dart';
import '../model/settings.dart';

class WorkOutCardWidget extends StatelessWidget {
  WorkOutCardWidget({
    Key? key,
    required this.workout,
    required this.index,
    required this.settings,
  }) : super(key: key);

  final WorkOut workout;
  final int index;
  final Settings settings;

  Color? getColor(WorkOut workout ){
    if(workout.color == 'red') return Colors.red;
    if(workout.color == 'blue') return Colors.blue;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final minHeight = getMinHeight(index);

    return Card(
      color: getColor(workout),
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workout.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: settings.fontStyle.toDouble(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}