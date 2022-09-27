import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:timer/model/settings.dart';
import 'package:timer/screens/watchWorkout_screen.dart';

import '../db/notes_database.dart';
import '../model/note.dart';

var colorNames = {
  'red':Colors.red,
  'pink':Colors.pink,
  'purple':Colors.purple,
  'blue':Colors.blue,
  'yellow':Colors.yellow,
  'brown':Colors.brown
};

class AddWorkoutScreen extends StatefulWidget{
  final Settings settings;

  final Function onSettingsChanged;
  final Function refresh;


  AddWorkoutScreen({required this.settings, required this.onSettingsChanged,required this.refresh});

  @override
  State<StatefulWidget> createState() => _AddWorkoutScreenState();

}
class TitleLimitFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    if(newValue.text.contains(' ')){
      return oldValue;
    }
    if(newValue.text.length >= 1){
      _AddWorkoutScreenState.isValidForm =true;
    }
    else{
      _AddWorkoutScreenState.isValidForm =false;
    }
    if(newValue.text == "") return newValue;
    return newValue;
  }
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {

  late String workoutName;
   String color= 'red';
  static bool isValidForm = false;

  getColor(Color color){
    if(color == Colors.red){
      this.color = 'red';
    }
    if(color == Colors.pink){
      this.color = 'pink';
    }
    if(color == Colors.purple){
      this.color = 'purple';
    }
    if(color == Colors.blue){
      this.color = 'blue';
    }
    if(color == Colors.yellow){
      this.color = 'yellow';
    }
    if(color == Colors.brown){
      this.color = 'brown';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('New workout',
            style: TextStyle(fontSize: widget.settings.fontStyle.toDouble())
        ),
      ),
      body: Form(
        child:
        Column(
            children:[
              TextField(
                keyboardType: TextInputType.text,
                inputFormatters: [
                  TitleLimitFormatter(),
                ],
                maxLength: 10,
                maxLines: null,
                decoration:InputDecoration(
                  labelText: 'Enter name...',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                onChanged: (value){
                  workoutName = value;
                },
              ),
              ListTile(
                title: Text('Choose color',
                    style: TextStyle(fontSize: widget.settings.fontStyle.toDouble())),
                subtitle: Text(color ?? 'red'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: SingleChildScrollView(
                          child: BlockPicker(
                            availableColors: [Colors.red,Colors.pink,Colors.purple,Colors.yellow,Colors.brown,Colors.blue],
                            pickerColor: Colors.red,
                            onColorChanged: (Color color) {
                              getColor(color);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if(isValidForm){
                    final NotesDatabase db = await NotesDatabase.instance;
                    List<WorkOut> works;
                    works = await db.getAllWorkOuts();
                    if(works.length >= 10){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('too match workouts!')));
                      return;
                    }

                    WorkOut workout = WorkOut(
                      name: this.workoutName,
                      color:this.color,
                    );

                    int id = await NotesDatabase.instance.createWorkOut(workout);
                    workout = await NotesDatabase.instance.getWorkOutById(id);
                    Navigator.of(context).pop();
                    await Navigator.of(context).push(
                             MaterialPageRoute(builder: (context) => WatchWorkoutScreen(settings: widget.settings, onSettingsChanged: widget.onSettingsChanged, workOut: workout,refresh: widget.refresh,)),
                           );
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('enter workout name')));
                  }
                },
                  child: Text("Create")
              ),

            ]
        ),
      )
    );
  }

}