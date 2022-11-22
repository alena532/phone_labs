import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'burger.dart';
import 'longInt.dart';

class ScientificCalculator extends StatefulWidget {
  static const routeName = '/premium-screen';

  @override
  State<ScientificCalculator> createState() => _ScientificCalculatorState();

}


class _ScientificCalculatorState extends State<ScientificCalculator> {
  List pref = [
    'sin',
    'cos',
    'tan',
    'ctg',
    'abs',
    'ln',
    'sqrt',
    'sqr',
    'lg',
    'log'
  ];
  List bin = ['^', '^', '*', '/', '+', '-'];
  //List<LongDouble> topText = [];
  String topText = "";
  String botText = "";
  //String lastChar = 'n';
  String degRad = 'RAD';
  double trigConst = 1;
  bool isPresent = false;
  bool isMinor = false;
  List<String> result = [];
  double beforeResult = 0.0;
  int bracketsCount = 0;

  double calcLog(double x, double y) {
    return log(x) / log(y);
  }

  String fact(String x) {
    LongDouble xx = LongDouble(x);
    ///var newX = double.parse(x).ceil();
    LongDouble res = LongDouble("1");
    LongDouble prov = LongDouble("3500");
    if (xx<prov) {
      for (LongDouble i = LongDouble("1"); i <= xx; i = i + LongDouble("1")) {
        res *= i;
      }
      List f = res.priint(res);
      String ff = f.join("");
      return ff;
    }
    else
      {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Слишком большое число для факториала ;)')));
        return x;
      }
  }

  List<String> calculating(List<String> chars) {
    List out = [];
    List stack = [];
    for (var index = 0; index < chars.length; index++) {
      if (chars[index] == 'pi') {
        out.add(LongDouble(pi.toString()));
      } else if (chars[index] == 'e') {
        out.add(LongDouble(e.toString()));
      }
      else if (chars[index].runes.last - '0'.runes.last < 10 && chars[index].runes.last - '0'.runes.last >= 0) {
        out.add(LongDouble(chars[index]));
      }
      else if (chars[index] == ')') {
        if (stack.isNotEmpty) {
          while (stack.isNotEmpty && stack.last != '(') {
            out.add(stack.removeLast());
          }
        }
        stack.removeLast();
      }
      else if (pref.contains(chars[index]) || chars[index] == '(') {
        stack.add(chars[index]);
      }
      else {
        if (stack.isNotEmpty) {
          while (stack.isNotEmpty &&
              stack.last != '(' &&
              (pref.contains(stack.last) ||
                  bin.indexOf(chars[index]) / 2 >=
                      bin.indexOf(stack.last) / 2)) {
            out.add(stack.removeLast());
          }
        }
        stack.add(chars[index]);
      }
    }
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
      //else if (pref.contains(out[i]))
        //var ss = out[i];
        switch (out[i]) {
          case "sin":
            List<String> a = stack.last.priint(stack.last);
            var aa = a.join("");
            double val = double.parse(aa);
            stack[stack.length - 1] = LongDouble(sin(trigConst * val).toString());
            break;
          case "cos":
            List<String> a = stack.last.priint(stack.last);
            var aa = a.join("");
            double val = double.parse(aa);
            print(val);
            stack[stack.length - 1] = LongDouble(cos(trigConst * val).toString());
            break;
          case "tan":
            List<String> a = stack.last.priint(stack.last);
            var aa = a.join("");
            double val = double.parse(aa);
            if (degRad =='RAD') {
              if (val % (pi / 2) == 0&& val!=0&& val%pi!=0) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                    content: Text('Вспомните пределы тангенса!!!')));
                stack.removeLast();
                break;
              }
            }
            else
              {
                if (val % 90 == 0 && val!=0&&val%180!=0) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                      content: Text('Вспомните пределы тангенса!!!')));
                  stack.removeLast();
                  break;
                }
              }
            stack[stack.length - 1] = LongDouble(tan(trigConst * val).toString());
            break;
          case "ctg":
            List<String> a = stack.last.priint(stack.last);
            var aa = a.join("");
            double val = double.parse(aa);
            if (degRad =='RAD') {
              if (val % pi  == 0) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                    content: Text('Вспомните пределы котангенса!!!')));
                stack.removeLast();
                break;
              }
            }
            else
            {
              if (val % 180 == 0 ) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                    content: Text('Вспомните пределы котангенса!!!')));
                stack.removeLast();
                break;
              }
            }
            stack[stack.length - 1] =LongDouble(
                (cos(trigConst * val) / sin(trigConst * val)).toString());
            break;
        //case "abs":
        //LongDouble a = stack.last;
        //var aa = a.join("");
        //int val = int.parse(aa);
        //a.sign = 1;
        //stack[stack.length - 1] = a;
        //break;
          case "ln":
            List<String> a = stack.last.priint(stack.last);
            var aa = a.join("");
            double val = double.parse(aa);
            if (val<=0)
              {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                        content: Text('Что ты пишешь под логарифмом?))')));
                    stack.removeLast();
                    break;
              }
            stack[stack.length - 1] = LongDouble(log(val).toString());
            break;
          case "lg":
            List<String> a = stack.last.priint(stack.last);
            var aa = a.join("");
            double val = double.parse(aa);
            if (val<=0)
            {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(
                  content: Text('Что ты пишешь под логарифмом?))')));
              stack.removeLast();
              break;
            }
            stack[stack.length - 1] = LongDouble(calcLog(val, 10).toString());
            break;
        //case "log":
        //List<String> a = stack.last.priint(stack.last);
        //var aa = a.join("");
        //double val = double.parse(aa);
        //stack[stack.length - 1] = LongDouble(calcLog(val, 2).toString());
        //break;
          case "sqr":
            try {
              stack[stack.length - 1] = stack.last * stack.last;
              break;
            }
            catch(e){
              break;
            }
          case "sq3":
            try {
              stack[stack.length] = stack.last * stack.last;
              stack[stack.length-1] = stack.last * stack.last;
              break;
            }
            catch(e){
              break;
            }
          case "sqrt":
            List<String> a = stack.last.priint(stack.last);
            var aa = a.join("");
            int val = int.parse(aa);
            if (val<0)
            {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(
                  content: Text('Нельзя найти корень от этого числа!!))')));
              stack.removeLast();
              break;
            }
            stack[stack.length - 1] = LongDouble(pow(val, 1.0 / 2).toString());
            break;
        }

        switch (out[i]) {
          case "^":
            List<String> a = stack.last.priint(stack.removeLast());
            var aa = a.join("");
            double se = double.parse(aa);//показатель степени
            List<String> b = stack.last.priint(stack.last);
            var bb = b.join("");
            double val = double.parse(bb);
            if(val == 0 && se<0)
              {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                    content: Text('Нельзя посчитать!!))')));
                break;
              }
            stack[stack.length - 1] = LongDouble(pow(val, se).toString());
            break;
          case "/":
            var se = stack.removeLast();
            //LongDouble nul = LongDouble("0");
            List<String> a = stack.last.priint(se);
            var aa = a.join("");
            double bb = double.parse(aa);//показатель степени
            if(bb == 0)
              {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                    content: Text('Нельзя делить на нуль!!))')));
                //stack.add(se);
                break;
              }
            stack[stack.length - 1] = stack.last / se;
            break;
          case "*":
            var se = stack.removeLast();
            stack[stack.length - 1] = stack.last * se;
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
    for (var i = 0; i < splitString.length; i++) {
      if (splitString[i] == '!') {
        splitString[i - 1] = fact(splitString[i - 1]);
      }
    }
    splitString.removeWhere((element) => element == '!');
    for (int i=0; i<splitString.length; i++)
      {
        if(splitString[i]=='-')
          {
            if (i==0&& splitString.length>1)
              {
                splitString[i]+=splitString[i+1];
                splitString.removeAt(i+1);
              }
            else if(splitString[i-1]=="("&&splitString.length>i+1)
              {
                if (splitString.length>i+2&&splitString[i+2]==")")
                  {
                    splitString[i]+=splitString[i+1];
                    splitString.removeAt(i+1);
                  }
                else {
                  splitString[i] += splitString[i + 1];
                  splitString.removeAt(i + 1);
                }
              }

          }
      }
    //List<LongDouble> ll = splitString.cast<LongDouble>();
    result = calculating(splitString);
    botText = result.join("");
    setState(() {});
    return;
  }

  void processing(String textButton) {
    switch (textButton) {
      case "RAD":
        trigConst = 1;
        degRad = 'DEG';
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Вы выбрали радианы')));
        break;
      case "DEG":
        trigConst = pi / 180;
        degRad = 'RAD';
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Вы выбрали градусы')));
        break;

      case "π":
        if (topText.isEmpty ||
            ((topText.runes.last - '0'.runes.last > 10 ||
                topText.runes.last - '0'.runes.last < 0) &&
                topText.characters.last != 'i' &&
                topText.characters.last != '!' &&
                topText.characters.last != ')' &&
                topText.characters.last != 'e')) {
          isMinor = false;
          topText += 'pi';
        }
        break;
      case "e":
        if (topText.isEmpty ||
            ((topText.runes.last - '0'.runes.last > 10 ||
                topText.runes.last - '0'.runes.last < 0) &&
                topText.characters.last != 'i' &&
                topText.characters.last != '!' &&
                topText.characters.last != ')' &&
                topText.characters.last != 'e')) {
          isMinor = false;
          topText += 'e';
        }
        break;
      case "n!":
        if (topText.runes.last - '0'.runes.last < 10 &&
            topText.runes.last - '0'.runes.last >= 0 ||
            topText.characters.last == 'i' ||
            topText.characters.last == 'e') {
          isMinor = false;
          topText += '!';
        }
        else
          {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Введите сначала число!!')));
          }
        break;

      case "sin":
        if (topText.isEmpty ||
            ((topText.runes.last - '0'.runes.last > 10 ||
                topText.runes.last - '0'.runes.last < 0) &&
                topText.characters.last != 'i' &&
                topText.characters.last != '!' &&
                topText.characters.last != ')' &&
                topText.characters.last != 'e')) {
          isMinor = false;
          bracketsCount++;
          topText += 'sin(';
        }
        else
          {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Неправильно!!')));
          }
        break;
      case "cos":
        if (topText.isEmpty ||
            ((topText.runes.last - '0'.runes.last > 10 ||
                topText.runes.last - '0'.runes.last < 0) &&
                topText.characters.last != 'i' &&
                topText.characters.last != '!' &&
                topText.characters.last != ')' &&
                topText.characters.last != 'e')) {
          isMinor = false;
          bracketsCount++;
          topText += 'cos(';
        }
        else
          {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('WOWOWOWOWO')));
          }
        break;
      case "tan":
        if (topText.isEmpty ||
            ((topText.runes.last - '0'.runes.last > 10 ||
                topText.runes.last - '0'.runes.last < 0) &&
                topText.characters.last != 'i' &&
                topText.characters.last != '!' &&
                topText.characters.last != ')' &&
                topText.characters.last != 'e')) {
          isMinor = false;
          bracketsCount++;
          topText += 'tan(';
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('owowowowowowo')));
        }
        break;
      case "ctg":
        if (topText.isEmpty ||
            ((topText.runes.last - '0'.runes.last > 10 ||
                topText.runes.last - '0'.runes.last < 0) &&
                topText.characters.last != 'i' &&
                topText.characters.last != '!' &&
                topText.characters.last != ')' &&
                topText.characters.last != 'e')) {
          isMinor = false;
          bracketsCount++;
          topText += 'ctg(';
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('owowowowowow')));
        }
        break;

      case '10^n':
        if (topText.isEmpty ||
            ((topText.runes.last - '0'.runes.last > 10 ||
                topText.runes.last - '0'.runes.last < 0) &&
                topText.characters.last != 'i' &&
                topText.characters.last != '!' &&
                topText.characters.last != ')' &&
                topText.characters.last != 'e')) {
          isMinor = false;
          bracketsCount++;
          topText += '10^(';
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('owowowowowo')));
        }
        break;
      case "xⁿ":
        if (topText.runes.last - '0'.runes.last < 10 &&
            topText.runes.last - '0'.runes.last >= 0 ||
            topText.characters.last == 'i' ||
            topText.characters.last == '!' ||
            topText.characters.last == ')' ||
            topText.characters.last == 'e') {
          isMinor = false;
          bracketsCount++;
          topText += "^(";
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Введите сначала число!!')));
        }
        break;
      case "eⁿ":
        if (topText.isEmpty ||
            ((topText.runes.last - '0'.runes.last > 10 ||
                topText.runes.last - '0'.runes.last < 0) &&
                topText.characters.last != 'i' &&
                topText.characters.last != '!' &&
                topText.characters.last != ')' &&
                topText.characters.last != 'e')) {
          isMinor = false;
          bracketsCount++;
          topText += "e^(";
        }
        else
          {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('owowowowowow')));
          }
        break;
      case "ln":
        if (topText.isEmpty ||
            ((topText.runes.last - '0'.runes.last > 10 ||
                topText.runes.last - '0'.runes.last < 0) &&
                topText.characters.last != 'i' &&
                topText.characters.last != '!' &&
                topText.characters.last != ')' &&
                topText.characters.last != 'e')) {
          isMinor = false;
          bracketsCount++;
          topText += 'ln(';
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('oeoeoeoeoeo')));
        }
        break;

      case "√":
        if (topText.isEmpty ||
            ((topText.runes.last - '0'.runes.last > 10 ||
                topText.runes.last - '0'.runes.last < 0) &&
                topText.characters.last != 'i' &&
                topText.characters.last != '!' &&
                topText.characters.last != ')' &&
                topText.characters.last != 'e')) {
          isMinor = false;
          topText += 'sqrt(';
          bracketsCount++;
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('owowowowow')));
        }
        break;
      case "x²":
        if (topText.isEmpty ||
            ((topText.runes.last - '0'.runes.last > 10 ||
                topText.runes.last - '0'.runes.last < 0) &&
                topText.characters.last != 'i' &&
                topText.characters.last != '!' &&
                topText.characters.last != ')' &&
                topText.characters.last != 'e')) {
          isMinor = false;
          bracketsCount++;
          topText += "sqr(";
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('owowowowowow')));
        }
        break;
      case "lg":
        if (topText.isEmpty ||
            ((topText.runes.last - '0'.runes.last > 10 ||
                topText.runes.last - '0'.runes.last < 0) &&
                topText.characters.last != 'i' &&
                topText.characters.last != '!' &&
                topText.characters.last != ')' &&
                topText.characters.last != 'e')) {
          isMinor = false;
          bracketsCount++;
          topText = 'lg(';
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('owowowowowowow')));
        }
        break;
      case "x^3":
        if (topText.isEmpty ||
            ((topText.runes.last - '0'.runes.last > 10 ||
                topText.runes.last - '0'.runes.last < 0) &&
                topText.characters.last != 'i' &&
                topText.characters.last != '!' &&
                topText.characters.last != ')' &&
                topText.characters.last != 'e')) {
          isMinor = false;
          bracketsCount++;
          topText += "sq3(";
        }
        else{
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('OWOWOWOWOWO')));
        }
        break;
      case ".":
        if (!isMinor &&
            topText.runes.last - '0'.runes.last < 10 &&
            topText.runes.last - '0'.runes.last >= 0) {
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
        if (topText.endsWith('sqrt(')) {
          topText = topText.substring(0, topText.length - 5);
        } else if (topText.endsWith('sin(') ||
            topText.endsWith('cos(') ||
            topText.endsWith('tan(') ||
            topText.endsWith('ctg(') ||
            topText.endsWith('10^(') ||
            topText.endsWith('sq3(')) {
          topText = topText.substring(0, topText.length - 4);
        } else if (topText.endsWith('e^(') ||
            topText.endsWith('ln(') ||
            topText.endsWith('lg(')) {
          topText = topText.substring(0, topText.length - 3);
        } else if (topText.endsWith('pi') || topText.endsWith('^(')||topText.endsWith('/(')) {
          topText = topText.substring(0, topText.length - 2);
        } else {
          topText = topText.substring(0, topText.length - 1);
        }
        break;
      case "÷":
        if (topText.runes.last - '0'.runes.last < 10 &&
            topText.runes.last - '0'.runes.last >= 0 ||
            topText.characters.last == 'i' ||
            topText.characters.last == '!' ||
            topText.characters.last == ')' ||
            topText.characters.last == 'e') {
          isMinor = false;
          bracketsCount++;
          topText += '/(';
        }
        else
          {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Введите сначала число!!')));
          }
        break;
      case "-":
        if (topText.isEmpty ||
            topText.runes.last - '0'.runes.last < 10 &&
                topText.runes.last - '0'.runes.last >= 0 ||
            topText.characters.last == 'i' ||
            topText.characters.last == '!' ||
            topText.characters.last == ')' ||
            topText.characters.last == 'e'||topText.characters.last == '(' ) {
          isMinor = false;
          topText += '-';
        }
        break;
      case "()":
        if (topText.isNotEmpty &&
            (topText.runes.last - '0'.runes.last < 10 &&
                topText.runes.last - '0'.runes.last >= 0 ||
                topText.characters.last == 'i' ||
                topText.characters.last == '!' ||
                topText.characters.last == ')' ||
                topText.characters.last == 'e') &&
            bracketsCount > 0) {
          isMinor = false;
          bracketsCount--;
          topText += ')';
        } else if (topText.isEmpty ||
            ((topText.runes.last - '0'.runes.last > 10 ||
                topText.runes.last - '0'.runes.last < 0) &&
                topText.characters.last != 'i' &&
                topText.characters.last != '!' &&
                topText.characters.last != ')' &&
                topText.characters.last != 'e')) {
          isMinor = false;
          bracketsCount++;
          topText += '(';
        }
        break;

      case "AC":
        beforeResult = 0;
        result = [];

        isMinor = false;
        topText = "";
        botText = "";
        bracketsCount = 0;
        break;

      case "×":
        if (topText.runes.last - '0'.runes.last < 10 &&
            topText.runes.last - '0'.runes.last >= 0 ||
            topText.characters.last == 'i' ||
            topText.characters.last == '!' ||
            topText.characters.last == ')' ||
            topText.characters.last == 'e') {
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
            topText.characters.last == 'i' ||
            topText.characters.last == '!' ||
            topText.characters.last == ')' ||
            topText.characters.last == 'e') {
          isMinor = false;
          topText += '+';
        }
        else
          {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Введите сначала число!!')));
          }
        break;
      case "=":
        isMinor = false;
        topText = result.join("");
        break;
      default:

        if (topText.isEmpty ||
            topText.characters.last != 'i' &&
                topText.characters.last != '!' &&
                topText.characters.last != ')' &&
                topText.characters.last != 'e') {
          topText += textButton;
        }
          else if (topText.characters.last == '/')
            {
              bool flag = true;
            }



    }
    setState(() {});
    precalculating();
    return;
  }

  Widget calcButton(String text, Color buttonColor, Color textColor) {
    return
      FloatingActionButton(
        shape: CircleBorder(),
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

  Widget _port()
  {
    return Scaffold(
      //drawer:AppDrawer(),
      appBar: AppBar(

        title:
        //if (isPremium)
        Text('Vorobei Alena'),

        //}
        //else {
        //Text('Calculator Demo')
        //}
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        elevation: 10.0,

      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerRight,
              height: MediaQuery.of(context).size.height * 0.3,
              margin: EdgeInsets.fromLTRB(10, 20, 20, 0),
              child: SingleChildScrollView(child: Text('$topText',
                  //maxLines: 1,
                  style: TextStyle(
                    fontSize: 38,
                    color: Colors.white70,
                  )))

            /*Text('$topText',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 38,
                    color: Colors.white70,
                  ))
                  */
          ),

          Expanded(
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Table(
                  children: [
                    TableRow(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child: calcButton("AC", Colors.grey, Colors.black),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child: calcButton("⌫", Colors.grey, Colors.black),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child: calcButton("()", Colors.orange, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child: calcButton("÷", Colors.orange, Colors.white),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("7", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("8", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("9", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child: calcButton("×", Colors.orange, Colors.white),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("4", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("5", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("6", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child: calcButton("-", Colors.orange, Colors.white),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("1", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("2", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("3", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child: calcButton("+", Colors.orange, Colors.white),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton("0", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child: calcButton(
                            "00", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(10),
                        child:
                        calcButton(".", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
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

  Widget _landsapce() {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const AppDrawer(),
      body: Column(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerRight,
              height: MediaQuery.of(context).size.height * 0.3,
              margin: EdgeInsets.fromLTRB(10, 20, 20, 0),
              child: SingleChildScrollView(child: Text('$topText',
                  //maxLines: 1,
                  style: TextStyle(
                    fontSize: 38,
                    color: Colors.white70,
                  )))

            /*Text('$topText',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 38,
                    color: Colors.white70,
                  ))
                  */
          ),
          Expanded(
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Table(
                  children: [
                    TableRow(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton(
                            "$degRad", Colors.grey.shade900, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton(
                            "sin", Colors.grey.shade900, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton(
                            "10^n", Colors.grey.shade900, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child:
                        calcButton("√", Colors.grey.shade900, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child:
                        calcButton("7", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child:
                        calcButton("8", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child:
                        calcButton("9", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton("⌫", Colors.grey, Colors.black),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton("AC", Colors.grey, Colors.black),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child:
                        calcButton("π", Colors.grey.shade900, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton(
                            "cos", Colors.grey.shade900, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton(
                            "xⁿ", Colors.grey.shade900, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton(
                            "x²", Colors.grey.shade900, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child:
                        calcButton("4", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child:
                        calcButton("5", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child:
                        calcButton("6", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton("÷", Colors.orange, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton("×", Colors.orange, Colors.white),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child:
                        calcButton("e", Colors.grey.shade900, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton(
                            "tan", Colors.grey.shade900, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton(
                            "eⁿ", Colors.grey.shade900, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton(
                            "lg", Colors.grey.shade900, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child:
                        calcButton("1", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child:
                        calcButton("2", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child:
                        calcButton("3", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton("-", Colors.orange, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton("+", Colors.orange, Colors.white),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton(
                            "n!", Colors.grey.shade900, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton(
                            "ctg", Colors.grey.shade900, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton(
                            "ln", Colors.grey.shade900, Colors.white),
                      ),
                     Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton(
                            "×", Colors.grey.shade900, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child:
                        calcButton("0", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton(
                            "00", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child:
                        calcButton(".", Colors.grey.shade800, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
                        child: calcButton("()", Colors.orange, Colors.white),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.125,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.0125),
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

  @override
  Widget build(BuildContext context) {
    return (
        OrientationBuilder(
          builder: (context,
              orientation) {
            if (MediaQuery
                .of(context)
                .orientation == Orientation.portrait) {
              return _port();
            } else {
              return _landsapce();
            }
          },
        )
    );
  }
}
