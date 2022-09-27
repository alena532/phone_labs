import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/runWorkOut.dart';
import '../model/settings.dart';
import 'package:wakelock/wakelock.dart';

import '../utils.dart';

String stepName(WorkoutState step) {
  switch (step) {
    case WorkoutState.exercising:
      return 'Exercise';
    case WorkoutState.resting:
      return 'Rest';
    case WorkoutState.warmingUp:
      return 'WarmUp';
    case WorkoutState.coolingDown:
      return 'CoolDown';
    case WorkoutState.finished:
      return 'Finished';
    case WorkoutState.starting:
      return 'Starting';
    default:
      return '';
  }
}

class WorkoutScreen extends StatefulWidget{
  final Settings settings;
  final WorkOutDTO dto;

  WorkoutScreen({required this.settings, required this.dto,});

  @override
  State<StatefulWidget> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>{
  late BeginWorkout _workout;

  @override
  initState() {
    super.initState();
    _workout = BeginWorkout(widget.settings, widget.dto, _onWorkoutChanged);
    _start();
  }

  _getBackgroundColor(ThemeData theme) {
    switch (_workout.step) {
      case WorkoutState.exercising:
        return Colors.green;
      case WorkoutState.starting:
      case WorkoutState.resting:
        return Colors.blue;
      case WorkoutState.warmingUp:
        return Colors.red;
      case WorkoutState.coolingDown:
        return Colors.pink;
      default:
        return theme.scaffoldBackgroundColor;
    }
  }

  @override
  dispose() {
    _workout.dispose();
    Wakelock.disable();
    super.dispose();
  }

  _pause() { _workout.pause(); }

  _onWorkoutChanged() {
    if (_workout.currentStep == WorkoutState.finished) {
      Wakelock.disable();
    }
    this.setState(() {});
  }
  int countSeconds(){
    Duration seconds = Duration(seconds: 0);
    int rep = widget.dto.rep;
    while(rep != 0){
      seconds+=widget.dto.startDelay;
      seconds+=widget.dto.coolDownTime;
      seconds+=widget.dto.restTime;
      seconds+=widget.dto.warmUpTime;
      seconds+=widget.dto.workoutTime;
      --rep;
    }
    return seconds.inSeconds;
  }

  _start() {
    _workout.start();
    Wakelock.enable();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var lightTextColor = theme.textTheme.bodyText2?.color?.withOpacity(0.8);
    return Scaffold(
      body: Container(
        color: _getBackgroundColor(theme),
        //padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Expanded(child: Row(children:[
        IconButton(
        iconSize: MediaQuery.of(context).size.height * 0.10,
          onPressed: () => {
            //_workout.player1.stop(),
            _workout.dispose(),
            Navigator.pop(context),
          },
          // Icon on the button
          icon: Icon(Icons.cancel, color: Colors.purple)
      )
            ])),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(stepName(_workout.step), style: TextStyle(fontSize: 60.0))
            ]),
            Divider(height: 32, color: lightTextColor),
            Container(
                width: MediaQuery.of(context).size.width,
                child: FittedBox(child: Text(formatTimeForDuration(_workout.timeLeft)))),
            Divider(height: 32, color: lightTextColor),
            Table(columnWidths: {
              0: FlexColumnWidth(0.5),
              1: FlexColumnWidth(0.5),
              2: FlexColumnWidth(1.0)
            }, children: [
              TableRow(children: [
                TableCell(child: Text('Rep', style: TextStyle(fontSize: 30.0))),

              ]),
              TableRow(children: [
                TableCell(
                  child:
                  Text('${_workout.rep}', style: TextStyle(fontSize: 60.0)),
                ),

              ]),
            ]),
            Expanded(child: _buildButtonBar()),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonBar() {
    //if (_workout.currentStep == WorkoutState.finished) {
    //  return Container();
   // }
    if (_workout.step == WorkoutState.finished) {

    }else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              iconSize: MediaQuery.of(context).size.height * 0.12,
              // When pressed, dispose the workout and pop the current screen
              onPressed: () => {
                _workout.previous,
              },
              // Icon on the button
              icon: Icon(Icons.arrow_circle_left_rounded, color: Colors.white70)
          ),
          IconButton(
              iconSize: MediaQuery.of(context).size.height * 0.12,
              onPressed: _workout.isActive? _pause : _start,
              // Icon on the button depends on if the workout is active or not
              icon: Icon(_workout.isActive ?
              // If active pause icon, if inactive play icon
              Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: Colors.white70
              )
          ),
          IconButton(
              iconSize: MediaQuery.of(context).size.height * 0.12,
              // When pressed, dispose the workout and pop the current screen
              onPressed: () => {
                _workout.next,
              },
              // Icon on the button
              icon: Icon(Icons.arrow_circle_right_rounded, color: Colors.white70)
          ),


        ],
      );
    }
    return Align(
      alignment: Alignment.bottomCenter,
      //child: TextButton(
        //onPressed: _workout.isActive ? _pause : _start,
      //  child: Icon(_workout.isActive ? Icons.pause : Icons.play_arrow),
      //),
    );
  }


}