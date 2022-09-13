
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StartScreen extends StatefulWidget{
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  @override
  Widget build(BuildContext context) {

    Future setPortrait() async => await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Future setLandscape() async => await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'Converter',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            Padding(
              padding:EdgeInsets.only(right:20.0),
              child:GestureDetector(
                  onTap:(){
                    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
                    if (isPortrait) {
                      setLandscape();
                    } else {
                      setPortrait();
                      }
                  },
                  child:Icon(
                      Icons.rotate_right
                  )
              )
            )

          ],
      ),
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Padding(
                padding:EdgeInsets.only(bottom: 20),
                child: Text('Welcome to converter',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    )
                ),
              ),
              ElevatedButton(
                  child:Text("Get start",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )
                  ),
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, '/length');
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
        )
        ),

      );

  }
}