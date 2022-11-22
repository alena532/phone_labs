import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'burger.dart';
import 'longInt.dart';


bool isPremium = false;
class DemoCalculator extends StatefulWidget {
  static const routeName = '/demo-screen';
  @override
  State<DemoCalculator> createState() => _DemoCalculatorState();
}

class _DemoCalculatorState extends State<DemoCalculator> {
  List bin = ['*', '/', '+', '-'];
  String topText = "";
  String botText = "";
  bool isMinor = false;
  List<String> result = [];
  int bracketsCount = 0;

  List<String> calculating(List<String> chars) {
    List out = [];
    List stack = [];
    for (var index = 0; index < chars.length; index++) {
      if (chars[index].runes.last - '0'.runes.last < 10 && chars[index].runes.last - '0'.runes.last >= 0)
      {
        out.add(LongDouble(chars[index]));
      }
      else if (chars[index] == ')')
      {
        if (stack.isNotEmpty) {
          while (stack.isNotEmpty && stack.last != '(') {
            out.add(stack.removeLast());
          }
        }
        stack.removeLast();
      }
      else if (chars[index] == '(')
      {
        stack.add(chars[index]);
      }
      else
      {
        if (stack.isNotEmpty) {
          while (stack.isNotEmpty &&
              stack.last != '(' &&
              (bin.indexOf(chars[index]) / 2 >= bin.indexOf(stack.last) / 2)) {
            out.add(stack.removeLast());
          }
        }
        //LongDouble vv = LongDouble(chars[index]);
        stack.add(chars[index]);
      }
    }
    //print(stack.length);
    out.addAll(stack.reversed);
    stack.clear();
    for (var i = 0; i < out.length; i++) {
      var bo = ' ';
      if(out[i] is LongDouble) {
        List<String> b = out[i].priint(out[i]);
         bo = b.join("");
      }
      if (bo.runes.last - '0'.runes.last < 10 && bo.runes.last - '0'.runes.last >= 0)
      {
        stack.add(out[i]);
        //print(stack.length);
        //print("========");
        bo = ' ';
      }
      else
      {
        switch (out[i]) {
          case "*":
            var se = stack.removeLast();
            stack[stack.length - 1] = stack.last * se;
            break;
          case "/":
            var se = stack.removeLast();
            stack[stack.length - 1] = stack.last / se;
            break;
          case "+":
            var se = stack.removeLast();
            stack[stack.length - 1] = stack.last + se;
            break;
          case "-":
            var se = stack.removeLast();
            stack[stack.length - 1] = stack.last - se;
            break;
        }
      }
    }
    List<String> a = stack.last.priint(stack.last);
    return a;
  }

  void precalculating() {
    var tempString = topText;
    tempString += ')' * bracketsCount;
    while (tempString.contains("()")) {
      tempString = tempString.replaceAll('()', '');
    }
    tempString = tempString
        .replaceAll('(', ' ( ')
        .replaceAll(')', ' ) ')
        .replaceAll('-', ' - ')
        .replaceAll('+', ' + ')
        .replaceAll('*', ' * ')
        .replaceAll('/', ' / ')
        .replaceAll('^', ' ^ ')
        .replaceAll('!', ' ! ');
    var splitString = tempString.split(" ");
    splitString.removeWhere((element) => element.isEmpty);
    splitString.removeWhere((element) => element == '!');
    result = calculating(splitString);
    botText = result.join("");
    //print(botText);
    setState(() {});
    return;
  }

  void processing(String textButton) {
    switch (textButton) {
      case ".":
        if (!isMinor && topText.runes.last - '0'.runes.last < 10 &&
            topText.runes.last - '0'.runes.last >= 0)
        {
          isMinor = true;
          topText += '.';
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Введите сначала число!!')));
        }
        break;

      case '⌫':
        if (topText.endsWith(')')) bracketsCount++;
        if (topText.endsWith('(')) bracketsCount--;
        if (topText.endsWith('.')) isMinor = false;
        topText = topText.substring(0, topText.length - 1);
        break;
      case "÷":
        if (topText.runes.last - '0'.runes.last < 10 &&
            topText.runes.last - '0'.runes.last >= 0 ||
            topText.characters.last == ')') {
          isMinor = false;
          bracketsCount++;
          topText += '/(';
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Введите сначала число!!')));
        }
        break;

      case "-":
        if (topText.isEmpty ||
            topText.runes.last - '0'.runes.last < 10 &&
                topText.runes.last - '0'.runes.last >= 0 ||
            topText.characters.last == ')') {
          isMinor = false;
          topText += '-';
        }
        break;

      case "()":
        if (topText.isNotEmpty &&
            (topText.runes.last - '0'.runes.last < 10 &&
                topText.runes.last - '0'.runes.last >= 0 ||
                topText.characters.last == ')') &&
            bracketsCount > 0) {
          isMinor = false;
          bracketsCount--;
          topText += ')';
        } else if (topText.isEmpty ||
            ((topText.runes.last - '0'.runes.last > 10 ||
                topText.runes.last - '0'.runes.last < 0) &&
                topText.characters.last != ')')) {
          isMinor = false;
          bracketsCount++;
          topText += '(';
        }
        break;

      case "AC":
        result = [];

        isMinor = false;
        topText = "";
        botText = "";
        result = [];
        bracketsCount = 0;
        break;

      case "×":
        if (topText.runes.last - '0'.runes.last < 10 &&
            topText.runes.last - '0'.runes.last >= 0 ||
            topText.characters.last == ')') {
          isMinor = false;
          topText += '*';
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Введите сначала число!!')));
        }
        break;

      case "+":
        if ((topText.runes.last - '0'.runes.last < 10 &&
            topText.runes.last - '0'.runes.last >= 0) ||
            topText.characters.last == ')') {
          isMinor = false;
          topText += '+';
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Введите сначала число!!')));
        }
        break;
      case "=":
        isMinor = false;
        topText = result.join("");
        break;

      default:
        if (topText.isEmpty || topText.characters.last != ')') {
          topText += textButton;
        }
    }
    setState(() {});
    precalculating();
    return;
  }

  Widget calcButton(String text, Color buttonColor, Color textColor) {
    return FloatingActionButton(
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.zero
      ),
      backgroundColor: buttonColor,
      onPressed: () {
          processing(text);
      },
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:AppDrawer(),
      appBar: AppBar(

        title:
        //if (isPremium)
        Text('Demo Calculator'),

        //}
        //else {
        //Text('Calculator Demo')
        //}
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        elevation: 10.0,
        actions: [
          Padding(
              padding:EdgeInsets.only(left:50.0),
              child:GestureDetector(
                  onTap:(){
                    //final isPremium = MediaQuer;
                    if (isPremium) {
                      isPremium=false;
                    } else {
                      isPremium = true;
                    }
                  },
                  child:Icon(

                      Icons.linear_scale

                  )
              )
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
        SingleChildScrollView(
        reverse: true,
        scrollDirection: Axis.horizontal,
          child: Text('$topText',
              maxLines: 1,
              style: TextStyle(
                fontSize: 30,
                color: Colors.brown,
              ))
      ),
           SingleChildScrollView(
            //width: MediaQuery.of(context).size.width,
            //alignment: Alignment.centerRight,
               reverse: true,
               scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text('$botText',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                  ))),

              Expanded(
                  child: Divider(),
              ),
              Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.55,
                child: Table(
                  children: [
                    TableRow(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child: calcButton("AC", Colors.grey, Colors.black),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child: calcButton("⌫", Colors.grey, Colors.black),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child: calcButton("()", Colors.orange, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child: calcButton("÷", Colors.orange, Colors.white),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("7", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("8", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("9", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child: calcButton("×", Colors.orange, Colors.white),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("4", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("5", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("6", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child: calcButton("-", Colors.orange, Colors.white),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("1", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("2", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("3", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child: calcButton("+", Colors.orange, Colors.white),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("0", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child: calcButton(
                            "00", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton(".", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.all(10),
                        child: calcButton("=", Colors.orange, Colors.white),
                      ),
                    ])
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}