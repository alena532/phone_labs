

import 'package:flutter/material.dart';
import 'package:timer/db/notes_database.dart';

import '../model/settings.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

var colorNames = {
  Colors.red: 'Red',
  Colors.pink: 'Pink',
  Colors.purple: 'Purple',
  Colors.deepPurple: 'Deep purple',
  Colors.indigo: 'Indigo',
  Colors.blue: 'Blue',
  Colors.lightBlue: 'Light blue',
  Colors.cyan: 'Cyan',
  Colors.teal: 'Teal',
  Colors.green: 'Green',
  Colors.lightGreen: 'Light green',
  Colors.lime: 'Lime',
  Colors.yellow: 'Yellow',
  Colors.amber: 'Amber',
  Colors.orange: 'Orange',
  Colors.deepOrange: 'Deep orange',
  Colors.brown: 'Brown',
  Colors.blueGrey: 'Blue grey',
};

class SettingsScreen extends StatefulWidget {
  final Settings settings;

  final Function onSettingsChanged;
  final Function refresh;

  SettingsScreen({required this.settings, required this.onSettingsChanged,required this.refresh});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings',
              style: TextStyle(fontSize: widget.settings.fontStyle.toDouble())
          ),
        ),
        body:ListView(
          children:<Widget>[
            ListTile(
              title: Text(
                  'Theme',
                  style: TextStyle(fontSize: widget.settings.fontStyle.toDouble())
              ),
            ),
            SwitchListTile(
              title: Text('Night mode',
                  style: TextStyle(fontSize: widget.settings.fontStyle.toDouble())),
              value: widget.settings.nightMode,
              onChanged: (nightMode) {
                widget.settings.nightMode = nightMode;
                widget.onSettingsChanged();
              },
            ),
            ListTile(
              title: Text('Light theme',
              style: TextStyle(fontSize: widget.settings.fontStyle.toDouble())),
              subtitle: Text(colorNames[widget.settings.primarySwatch] ?? ''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          availableColors: Colors.primaries,
                          pickerColor: widget.settings.primarySwatch,
                          onColorChanged: (Color color) {
                            widget.settings.primarySwatch =
                            color as MaterialColor;
                            widget.onSettingsChanged();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              title:Text('Font size',
                  style: TextStyle(fontSize: widget.settings.fontStyle.toDouble())),
              onTap:(){
                int _value = widget.settings.fontStyle;
                showDialog<int>(
                  context: context,
                  builder: (BuildContext context){
                    return StatefulBuilder(builder: (context, setState){
                      return AlertDialog(
                        title:Text('Set Font size',
                            style: TextStyle(fontSize: widget.settings.fontStyle.toDouble())),
                        content:NumberPicker(
                          value:_value,
                          minValue:15,
                          maxValue: 30,
                          onChanged: (value) {
                            setState(() {
                              _value = value;
                            });
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('CANCEL',
                                style: TextStyle(fontSize: widget.settings.fontStyle.toDouble())),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(_value),
                            child: Text('OK',
                                style: TextStyle(fontSize: widget.settings.fontStyle.toDouble())),
                          )
                        ],
                      );
                    });

                  },
                ).then((value) {
                  if (value == null) return;
                  widget.settings.fontStyle = value;
                  widget.onSettingsChanged();

                });
              }
            ),
            ListTile(
              title: Text('Clear all',
                  style: TextStyle(fontSize: widget.settings.fontStyle.toDouble())),
              onTap: () async {
                final wokrouts =await  NotesDatabase.instance.getAllWorkOuts();
                for(final element in wokrouts){
                  NotesDatabase.instance.deleteWorkOut(element.id!);
                }
                widget.refresh();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('all workouts was deleted successfuly')));
              },

            )
        ]
        )
    );

  }
  
}