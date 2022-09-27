import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  final SharedPreferences _prefs;

  late bool nightMode;
  late bool silentMode;
  late MaterialColor primarySwatch;
  late String countdownPip;
  late String startRep;
  late String startRest;
  late String startBreak;
  late String startSet;
  late String endWorkout;
  late int fontStyle;


  Settings(this._prefs) {
    Map<String, dynamic> json =
    jsonDecode(_prefs.getString('settings') ?? '{}');
    nightMode = json['nightMode'] ?? false;
    silentMode = json['silentMode'] ?? false;
    primarySwatch = Colors.primaries[
    json['primarySwatch'] ?? Colors.primaries.indexOf(Colors.deepPurple)];
    fontStyle = json['fontStyle'] ?? 20;
    countdownPip = json['countdownPip'] ?? 'pip.mp3';
    startRep = json['startRep'] ?? 'boop.mp3';
    startRest = json['startRest'] ?? 'dingdingding.mp3';
    startBreak = json['startBreak'] ?? 'dingdingding.mp3';
    startSet = json['startSet'] ?? 'boop.mp3';
    endWorkout = json['endWorkout'] ?? 'dingdingding.mp3';
  }

  save() {
    _prefs.setString('settings', jsonEncode(this));
  }

  Map<String, dynamic> toJson() => {
    'nightMode': nightMode,
    'silentMode': silentMode,
    'primarySwatch': Colors.primaries.indexOf(primarySwatch),
    'countdownPip': countdownPip,
    'startRep': startRep,
    'startRest': startRest,
    'startBreak': startBreak,
    'startSet': startSet,
    'endWorkout': endWorkout,
    'fontStyle': fontStyle,

  };
}
