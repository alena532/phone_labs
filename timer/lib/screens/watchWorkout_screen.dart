import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:timer/screens/settings_screen.dart';
import 'package:timer/screens/workout_screen.dart';

import '../db/notes_database.dart';
import '../model/note.dart';
import '../model/runWorkOut.dart';
import '../model/settings.dart';
import '../utils.dart';
import '../widgets/durationpicker.dart';

class WatchWorkoutScreen extends StatefulWidget{
  final Settings settings;
   WorkOut workOut;
  final Function onSettingsChanged;
  final Function refresh;

  WatchWorkoutScreen({required this.settings, required this.onSettingsChanged, required this.workOut,required this.refresh});

  @override
  State<StatefulWidget> createState() => _WatchWorkoutScreenState();

}
class _WatchWorkoutScreenState extends State<WatchWorkoutScreen>{

  _onWorkOutChanged() {
    setState(() {});
    _saveWorkOut();
  }

  _saveWorkOut(){
    NotesDatabase.instance.updateWorkOut(widget.workOut);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Detail info',
            style: TextStyle(fontSize: widget.settings.fontStyle.toDouble())
        ),
        actions:<Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                      settings: widget.settings,
                      onSettingsChanged: widget.onSettingsChanged,
                      refresh: widget.refresh),
                ),
              );
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Reps'),
            subtitle: Text('${widget.workOut.rep}'),
            leading: Icon(Icons.repeat),
            onTap: () {
              int? _value = widget.workOut.rep;
              showDialog<int>(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: Text('workout repetition'),
                      content: NumberPicker(
                        value: _value!,
                        minValue: 1,
                        maxValue: 10,
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                          });
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(_value),
                          child: Text('OK'),
                        )
                      ],
                    );
                  });
                },
              ).then((reps) {
                if (reps == null) return;
                widget.workOut.rep = reps;
                _onWorkOutChanged();
              });
            },
          ),
          Divider(
            height: 10,
          ),
          ListTile(
            title: Text('Starting Countdown'),
            subtitle: Text(formatTime(widget.workOut.startDelay)),
            leading: Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: convertToDuration(widget.workOut.startDelay!),
                    title: Text('Countdown before starting workout'),
                  );
                },
              ).then((startDelay) {
                if (startDelay == null) return;
                widget.workOut.startDelay = convertFromDuration(startDelay);
                _onWorkOutChanged();
              });
            },
          ),
          ListTile(
            title: Text('Workout'),
            subtitle: Text(formatTime(widget.workOut.workoutTime)),
            leading: Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: convertToDuration(widget.workOut.workoutTime!),
                    title: Text('Workout'),
                  );
                },
              ).then((startDelay) {
                if (startDelay == null) return;
                widget.workOut.workoutTime = convertFromDuration(startDelay);
                _onWorkOutChanged();
              });
            },
          ),
          ListTile(
            title: Text('Rest'),
            subtitle: Text(formatTime(widget.workOut.restTime)),
            leading: Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: convertToDuration(widget.workOut.restTime!),
                    title: Text('Rest'),
                  );
                },
              ).then((startDelay) {
                if (startDelay == null) return;
                widget.workOut.restTime = convertFromDuration(startDelay);
                _onWorkOutChanged();
              });
            },
          ),
          ListTile(
            title: Text('Warm-up'),
            subtitle: Text(formatTime(widget.workOut.warmUpTime)),
            leading: Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: convertToDuration(widget.workOut.warmUpTime!),
                    title: Text('Warm-up'),
                  );
                },
              ).then((startDelay) {
                if (startDelay == null) return;
                widget.workOut.warmUpTime = convertFromDuration(startDelay);
                _onWorkOutChanged();
              });
            },
          ),
          ListTile(
            title: Text('Cooldown'),
            subtitle: Text(formatTime(widget.workOut.coolDownTime)),
            leading: Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: convertToDuration(widget.workOut.coolDownTime!),
                    title: Text('Cooldown'),
                  );
                },
              ).then((startDelay) {
                if (startDelay == null) return;
                widget.workOut.coolDownTime = convertFromDuration(startDelay);
                _onWorkOutChanged();
              });
            },
          ),

          ListTile(
            leading: Icon(Icons.cancel),
            title: Text('Delete'),
            onTap: () {
              NotesDatabase.instance.deleteWorkOut(widget.workOut.id!);
              widget.refresh();
              Navigator.of(context).pop();
            },
          ),

        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          WorkOutDTO play= WorkOutDTO(
              startDelay:convertToDuration(widget.workOut.startDelay!),
              workoutTime:convertToDuration(widget.workOut.workoutTime!),
              restTime:convertToDuration(widget.workOut.restTime!),
              warmUpTime:convertToDuration(widget.workOut.warmUpTime!),
              coolDownTime:convertToDuration(widget.workOut.coolDownTime!),
              rep:widget.workOut.rep!,
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkoutScreen(
                      settings: widget.settings, dto: play,)));
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryTextTheme.button?.color,
        tooltip: 'Start Workout',
        child: Icon(Icons.play_arrow),
      ),
    );


  }

}