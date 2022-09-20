import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timer/model/settings.dart';

class AddWorkoutScreen extends StatefulWidget{
  final Settings settings;

  final Function onSettingsChanged;



  AddWorkoutScreen({required this.settings, required this.onSettingsChanged});

  @override
  State<StatefulWidget> createState() => _AddWorkoutScreenState();

}
class NumberLimitFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text == "") return newValue;
    //if()
    if(newValue.text.contains(' ')){
      return oldValue;
    }
    if(newValue.text.length>=1){
      _AddWorkoutScreenState.isValidForm =true;
    }
    else{
      _AddWorkoutScreenState.isValidForm =false;
    }
    return newValue;
  }
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {

  late String workoutName;
  static bool isValidForm = false;
  TextEditingController textController = TextEditingController();
  var _nameForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('New workout',
            style: TextStyle(fontSize: widget.settings.fontStyle.toDouble())
        ),
      ),
      body: Form(
        key:_nameForm,
        child:
        Column(
            children:[
              TextField(
                keyboardType: TextInputType.text,
                inputFormatters: [
                  NumberLimitFormatter(),
                ],
                maxLength: 10,
                //controller: textController,
                maxLines: null,
                onChanged: (value){
                  workoutName = value;
                },

              ),
              ElevatedButton(
                onPressed: (){
                  if(isValidForm){
                    Text("Nice");
                  }
                  else{
                    Text("Please Fix error and Submit ");
                  }

                },
                  child: Text("Finish")),




            ]
        ),
      )
    );
  }

}