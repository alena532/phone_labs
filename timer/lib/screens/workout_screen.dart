import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final bool testMode;

  WorkoutScreen({required this.settings, required this.dto, this.testMode = false});



  @override
  State<StatefulWidget> createState() => _WorkoutScreenState(testMode);
}

class _WorkoutScreenState extends State<WorkoutScreen> with WidgetsBindingObserver{
  _WorkoutScreenState(this.testMode);
  final bool testMode;
  bool _connectedToService = false;
  int _currentSeconds = 1;
  late BeginWorkout _workout;


  static const MethodChannel platform =
      MethodChannel('com.example.timer/service');

  @override
  initState() {
    super.initState();

    if (!testMode) {
      WidgetsBinding.instance.addObserver(this);
      connectToService();
      _workout = BeginWorkout(widget.settings, widget.dto, _onWorkoutChanged);
      _currentSeconds = _workout.getTotalTime();
      _start();
    } else {
      _connectedToService = true;
    }

    //_workout = BeginWorkout(widget.settings, widget.dto, _onWorkoutChanged);


  }

  Future<void> connectToService() async {
    try {
      await platform.invokeMethod<void>('connect');
      print('Connected to service');
    } on Exception catch (e) {
      print(e.toString());
      return;
    }

    try {
      final int? serviceCurrentSeconds = await getServiceCurrentSeconds();
      setState(() {
        _connectedToService = true;
        if (serviceCurrentSeconds! <= 0) {
          _currentSeconds = _workout.getTotalTime();
        } else {
          _currentSeconds = serviceCurrentSeconds;
        }
      });
    } on PlatformException catch (e) {
      print(e.toString());
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<void> startServiceTimer(int duration) async {
    if (testMode) {
      return;
    }

    try {
      await platform
          .invokeMethod<void>('start', <String, int>{'duration': duration});
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> stopServiceTimer() async {
    if (testMode) {
      return;
    }

    try {
      await platform.invokeMethod<void>('stop');
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<int?> getServiceCurrentSeconds() async {
    try {
      final int? result = await platform.invokeMethod<int>('getCurrentSeconds');
      return result;
    } on PlatformException catch (e) {
      print(e.toString());
    }

    return 0;
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached ||  state == AppLifecycleState.inactive) return;

    if (state == AppLifecycleState.paused) connectToService();

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

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

  }

  _pause() { _workout.pause(); }

  _onWorkoutChanged() {
    if (!mounted) return;

    if (_workout.currentStep == WorkoutState.finished) {
      Wakelock.disable();
    }
    if(this.mounted) {
      this.setState(() {});
    }

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
    startServiceTimer(_workout.getTotalTime()).then((void _) => setState(() {
      _workout.start();
      _currentSeconds--;
    }));


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
          onPressed: () async => {
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