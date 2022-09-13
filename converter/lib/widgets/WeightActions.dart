

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeightActions extends StatefulWidget {
  @override
  _WeightActionsState createState() => _WeightActionsState();
}

class _WeightActionsState extends State<WeightActions> {
  String _from = 'kilograms';
  String _to = 'grams';
  double _value = 0;
  double _answer = 0;

  final List<String> _measures = [
    'kilograms',
    'grams',
    'tons',
  ];

  String GetName(String name){
    if(name == 'celsius') return 'dc';
    if(name == 'fahrenheit') return 'df';
    if(name == 'kalvin') return 'dk';
    return '';
  }
  void convert(String from, String to, double value) async {
    if (value == 0) {
      return;
    }
    if (from == to) {
      setState(() {
        _answer = value;
      });
    }
    if (from == 'kilograms' && to == 'grams') {
      setState(() {
        _answer = value * 1000;
      });
    }
    if(from == 'kilograms' && to == 'tons'){
      setState(() {
        _answer = value / 1000;
      });
    }
    if (from == 'grams' && to == 'kilograms') {
      setState(() {
        _answer = value / 1000;
      });
    }
    if (from == 'grams' && to == 'tons') {
      setState(() {
        _answer = value / 1000000;
      });
    }
    if (from == 'tons' && to == 'kilograms') {
      setState(() {
        _answer = value * 1000;
      });
    }
    if (from == 'tons' && to == 'grams') {
      setState(() {
        _answer = value * 1000000;
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
                hint: Text('Weight Scale'),
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
              Icon(
                Icons.arrow_circle_down_rounded,
                color: Colors.greenAccent,
                size: 30.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              SizedBox(
                width: 30,
              ),
              DropdownButton(
                value: _to,
                hint: Text('Temperature Scale'),
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
                      cursorHeight: 20,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: '  Enter value...',
                          floatingLabelBehavior: FloatingLabelBehavior.never),
                      onChanged: (value) {
                        var rv = double.tryParse(value);
                        if (rv != null ) {
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
                    _from == 'kilograms'?'kg':_from,
                    style: TextStyle(fontSize: 22),
                  ),
                ],
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
                        _to == 'kilograms'?'kg':_to,
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
                hint: Text('Temperature Scale'),
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
              Icon(
                Icons.arrow_forward,
                color: Colors.greenAccent,
                size: 30.0,
                semanticLabel: 'Text to announce in accessibility modes',
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
                  cursorHeight: 20,
                  //style: inputStyle,
                  //onSubmitted: (value) =>
                  //    convert(_from, _to, double.parse(value)),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: '  Enter value...',
                      floatingLabelBehavior: FloatingLabelBehavior.never),
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
                _from == 'kilograms'?'kg':_from,
                style: TextStyle(fontSize: 22),
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
                _to == 'kilograms'?'kg':_to,
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