import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer/screens/settings_screen.dart';
import'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../db/notes_database.dart';
import '../model/note.dart';
import '../model/settings.dart';
import '../widgets/WorkOutCardWidget.dart';
import 'addWorkout_screen.dart';

class TabataScreen extends StatefulWidget {
  final Settings settings;
  final SharedPreferences prefs;
  final Function onSettingsChanged;

  TabataScreen({
    required this.settings,
    required this.prefs,
    required this.onSettingsChanged,
  });

  @override
  State<StatefulWidget> createState() => _TabataScreenState();
}

class _TabataScreenState extends State<TabataScreen> {
  late List<WorkOut> works;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading=true;
    });
    this.works = await NotesDatabase.instance.getAllWorkOuts();
    setState(() {
      isLoading=false;
    });
  }

  Color? getColor(WorkOut workout ){
    if(workout.color == 'red') return Colors.red;
    if(workout.color == 'blue') return Colors.blue;
    return null;
  }

  Widget buildWorkOuts() => StaggeredGridView.countBuilder(
    padding: EdgeInsets.all(8),
    itemCount: works.length,
    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final workout = works[index];
      //return note;

      return GestureDetector(
        //onTap: () async {
        //  await Navigator.of(context).push(MaterialPageRoute(
        //    builder: (context) => NoteDetailPage(noteId: note.id!),
        //  ));


     //   },
       child: WorkOutCardWidget(workout: works[index], index: index,settings:widget.settings),
          );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                'Workouts',
                style: TextStyle(fontSize: widget.settings.fontStyle.toDouble())
            ),
          leading: Icon(Icons.timer),
          actions: <Widget>[
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
                        onSettingsChanged: widget.onSettingsChanged),
                  ),
                );
              },
              tooltip: 'Settings',
            )
          ],

        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : workOutNotes.isEmpty
              ? Text(
            'No Notes',
            style: TextStyle(fontSize: widget.settings.fontStyle.toDouble()),
          )
              : buildWorkOuts(),
        ),
        floatingActionButton:FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddWorkoutScreen(settings: widget.settings,onSettingsChanged: widget.onSettingsChanged)),
            );

            refreshNotes();
          },

        )
      // floatingActionButton: FloatingActionButton(
       // backgroundColor: Colors.black,
      //  child: Icon(Icons.add),
       // onPressed: () async {
       //   await Navigator.of(context).push(
       //     MaterialPageRoute(builder: (context) => AddEditNotePage()),
       //   );

      //    refreshNotes();
     //   },
   //   ),
    );
  }
}