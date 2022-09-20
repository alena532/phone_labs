import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class LengthActions extends StatefulWidget {
  @override
  _LengthActionsState createState() => _LengthActionsState();
}
class TextNumberLimitFormatter extends TextInputFormatter {
  int countPoints=0;
  TextNumberLimitFormatter();

  RegExp exp = new RegExp("[0-9.]");
  static const String POINTER = ".";
  static const String ZERO = "0";

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.length>=12) {
      return oldValue;
    }
      if (newValue.text.isEmpty) {
        return newValue;
      }
      try{
        double.parse(newValue.text);
      }
      catch(e){
        return oldValue;
      }

      if(newValue.text[0]=='0') return oldValue;
      return newValue;
    }

}



class _LengthActionsState extends State<LengthActions> {
  String _from = 'centimeters';
  String _to = 'feet';
  double _value = 0;
  double _answer = 0;

  final List<String> _measures = [
    'inches',
    'centimeters',
    'feet',
  ];
  final TextEditingController _textController = TextEditingController();

  String? get _errorText{
    final text = _textController.value.text;
    if(text.length >= 11){
      return 'to long';
    }
    return null;
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _textController.text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  void convert(String from, String to, double value) async {

    if (from == 'centimeters' && to == 'feet') {
      setState(() {
        _answer = value * 0.0328084;
      });
    }
    if (from == 'feet' && to == 'centimeters') {
      setState(() {
        _answer = value / 0.0328084;
      });
    }
    if (from == 'inches' && to == 'centimeters') {
      setState(() {
        _answer = value * 2.54;
      });
    }
    if (from == 'centimeters' && to == 'inches') {
      setState(() {
        _answer = value / 2.54;
      });
    }
    if (from == 'feet' && to == 'inches') {
      setState(() {
        _answer = value * 12;
      });
    }
    if (from == 'inches' && to == 'feet') {
      setState(() {
        _answer = value / 12;
      });
    }
    if (from == to) {
      setState(() {
        _answer = value;
      });
    }
    FocusScope.of(context).unfocus();
  }

  Widget _portraitLengthMode(){
    return Container(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
          DropdownButton(
            value: _from,
            hint: Text('Length Scale'),
            items: _measures.map((String value){
              return DropdownMenuItem<String>(
                value:value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _from = value!;
              });
            },
          ),
          SizedBox(
            height: 15,
          ),
          MaterialButton(
            child:Icon(Icons.double_arrow,
              color: Colors.greenAccent,
              size: 30.0,),
            onPressed: (){
              String temp = this._from;
              this._from = _to;
              _to = temp;
              convert(_from, _to, _value);
            },
          ),

          SizedBox(
            width: 30,
          ),
          DropdownButton(
            value: _to,
            hint: Text('Length Scale'),
            items: _measures.map((String value){
              return DropdownMenuItem<String>(
                value:value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _to = value!;
              });
            },
          ),
          SizedBox(
            height: 35,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.30,
                child: TextField(
                  controller: _textController,
                  cursorHeight: 20,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    //TextNumberF(),
                    TextNumberLimitFormatter(),
                    //LengthLimitingTextInputFormatter(11),
                  //  FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                      errorText: _errorText,
                      labelText: '  Enter value...',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                     // icon:IconButton(
                     // icon:const Icon(Icons.copy),
                     // onPressed: _copyToClipboard,
                  ),


                  onChanged: (value) {
                   // if(value.length == 11){

                    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //    content: Text("You cant insert more values"),
                    //  ));
                    //}

                    var rv = double.tryParse(value);
                    if (rv != null && rv >= 0) {
                      setState(() {
                        _value = rv;
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                _from == 'centimeters' ? 'cm' : _from,
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                width: 15,
              ),
              ElevatedButton(
                  style:ElevatedButton.styleFrom(
                      primary: Colors.greenAccent,
                      fixedSize: const Size(20, 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)
                      )
                  ),
                  onPressed: (){
                    Clipboard.setData(ClipboardData(text: _textController.text));
                  },
                  child: Text("Copy"
                  )
              ),
              ElevatedButton(
                onPressed: ()  {
                  print(_textController.text);

                Clipboard.getData(Clipboard.kTextPlain).then((value){

                  if(value==null) return;
                  int textFieldCount=_textController.text.length;
                  int clipBoardCount=value.text.toString().length;
                  if(clipBoardCount+textFieldCount>=12){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('to much')));
                    return;
                  }

                  _textController.text = _textController.text + value.text.toString();
                });
                },
                child: Text("Paste")
                ),

              ],
          ),
          SizedBox(
            width: 25,
          ),
          Row(
            children:[
                Text(
                  '=',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.greenAccent,
                  ),
                ),

            ]
          ),
          SizedBox(
            width: 5,
          ),
          Row(
            children:[
              Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // color: Colors.grey,
                ),
                width: MediaQuery.of(context).size.width * 0.21,
                child: Text(
                  _answer.toStringAsFixed(3),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                _to == 'centimeters' ? 'cm' : _to,
                style: TextStyle(fontSize: 22),
              ),
            ]
          ),
          SizedBox(
            height: 25,
          ),
          ElevatedButton(
            child:Text("convert",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                )
            ),
            onPressed: (){
              convert(_from, _to, _value);
            },
            style:ElevatedButton.styleFrom(
                primary: Colors.greenAccent,
                fixedSize: const Size(120, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)
                )
            ),
          )
        ]
      )
        );
  }

  Widget _landscapeLengthMode(){
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton(
                value: _from,
                hint: Text('Length Scale'),
                items: _measures.map((String value){
                  return DropdownMenuItem<String>(
                    value:value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _from = value!;
                  });
                },

              ),
              SizedBox(
                width: 30,
              ),
              MaterialButton(
                child:Icon(Icons.double_arrow,
                  color: Colors.greenAccent,
                  size: 30.0,),
                onPressed: (){
                  String temp = this._from;
                  this._from = _to;
                  _to = temp;
                  convert(_from, _to, _value);
                },
              ),
              SizedBox(
                width: 30,
              ),
              DropdownButton(
                value: _to,
                hint: Text('Length Scale'),
                items: _measures.map((String value){
                  return DropdownMenuItem<String>(
                    value:value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _to = value!;
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 35,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(4),
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.30,
                child: TextField(
                  controller: _textController,
                  cursorHeight: 20,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    // TextNumberLimitFormatter(),
                    TextNumberLimitFormatter(),
                    LengthLimitingTextInputFormatter(11),
                    //  FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: '  Enter value...',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    // icon:IconButton(
                    // icon:const Icon(Icons.copy),
                    // onPressed: _copyToClipboard,
                  ),
                  onChanged: (value) {
                    var rv = double.tryParse(value);
                    if (rv != null && rv >= 0) {
                      setState(() {
                        _value = rv;
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                _from == 'centimeters' ? 'cm' : _from,
                style: TextStyle(fontSize: 22),
              ),

              SizedBox(
                width: 15,
              ),
              ElevatedButton(
                  style:ElevatedButton.styleFrom(
                      primary: Colors.greenAccent,
                      fixedSize: const Size(20, 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)
                      )
                  ),
                  onPressed: (){
                    Clipboard.setData(ClipboardData(text: _textController.text));
                  },
                  child: Text("Copy"
                  )
              ),

              SizedBox(
                width: 25,
              ),
              Text(
                '=',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.greenAccent,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // color: Colors.grey,
                ),
                width: MediaQuery.of(context).size.width * 0.21,
                child: Text(
                  _answer.toStringAsFixed(3),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                _to == 'inches' ? 'inch' : _to,
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          ElevatedButton(
            child:Text("convert",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                )
            ),
            onPressed: (){
              convert(_from, _to, _value);
            },
            style:ElevatedButton.styleFrom(
                primary: Colors.greenAccent,
                fixedSize: const Size(120, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)
                )
            ),
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child:OrientationBuilder(
        builder: (context,
            orientation){
          if(MediaQuery.of(context).orientation == Orientation.portrait){
            return _portraitLengthMode();
          }else{
            return _landscapeLengthMode();
          }

        },

      ),

    );
  }
}