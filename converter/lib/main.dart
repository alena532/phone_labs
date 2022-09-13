import 'package:flutter/material.dart';
import 'package:phone_app/screens/LengthConversion.dart';
import 'package:phone_app/screens/Start.dart';
import 'package:flutter/services.dart';
import 'package:phone_app/screens/TemperatureConversion.dart';
import 'package:phone_app/screens/WeightConversion.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_){
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData(
        primaryColor: Colors.lime,
      ),
      initialRoute: '/',
      routes:{
        '/':(context)=>StartScreen(),
        '/length':(context)=>LengthConversionScreen(),
        '/temperature':(context)=>TemperatureConversionScreen(),
        '/weight':(context)=>WeightConversionScreen()

      }


    );
  }

}

