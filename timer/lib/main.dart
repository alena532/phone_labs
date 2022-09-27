import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timer/model/note.dart';
import 'package:timer/screens/tabata_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'db/notes_database.dart';
import 'model/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  final NotesDatabase db = await NotesDatabase.instance;

 // late final NotificationService notificationService;

  final workout = WorkOut(
    name: "third",
    color:"yellow",
  );


  await NotesDatabase.instance.createWorkOut(workout);
  final all=await NotesDatabase.instance.getAllWorkOuts();
  var prefs = await SharedPreferences.getInstance();
  runApp(TimerApp(settings: Settings(prefs), prefs: prefs));
}

class TimerApp extends StatefulWidget {
  final Settings settings;
  final SharedPreferences prefs;

  TimerApp({required this.settings, required this.prefs});


  @override
  State<StatefulWidget> createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {

  _onSettingsChanged() {
    setState(() {});
    widget.settings.save();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabata Timer',
      theme: ThemeData(
        primarySwatch: widget.settings.primarySwatch,
        brightness:
            widget.settings.nightMode ? Brightness.dark : Brightness.light,
      ),

        home: TabataScreen(
          settings: widget.settings,
          prefs: widget.prefs,
          onSettingsChanged: _onSettingsChanged,
        )

    );


  }
}
