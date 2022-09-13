import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LengthActions extends StatefulWidget {
  @override
  _LengthActionsState createState() => _LengthActionsState();
}
class NumberLimitFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text == "") return newValue;
    //if()
    if(int.parse(newValue.text.toString())<100000000000){
      return newValue;
    }
    return oldValue;
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
                  //controller: fromText,
                  cursorHeight: 20,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    NumberLimitFormatter(),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
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
                _from == 'centimeters' ? 'cm' : _from,
                style: TextStyle(fontSize: 22),
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
                _from == 'centimeters' ? 'cm' : _from,
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