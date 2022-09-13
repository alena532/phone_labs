import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/BurgerMenu.dart';
import '../widgets/WeightActions.dart';

class WeightConversionScreen extends StatefulWidget {
  static const routeName = '/length-conversion';

  @override
  State<WeightConversionScreen> createState() => _WeightConversionScreenState();
}

class _WeightConversionScreenState extends State<WeightConversionScreen> {
  Future setPortrait() async => await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Future setLandscape() async => await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  Widget _landscapeLengthMode(){
    return Center(
        child:ListView(
            children:[Card(
              shape: RoundedRectangleBorder( //<-- SEE HERE
                side: BorderSide(
                  color: Colors.lime,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                padding: EdgeInsets.only(top:40),
                width: MediaQuery.of(context).size.width,
                height: 350,
                child:Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WeightActions(),
                        ],
                      ),
                    ]
                ),
              ),
            ),
            ]
        )

    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        drawer:AppDrawer(),
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.lime,
          elevation: 50.0,
          title: Text(
            'Convert Length',
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
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body:Center(
            child:ListView(
                children:[
                  Card(
                    shape: RoundedRectangleBorder( //<-- SEE HERE
                      side: BorderSide(
                        color: Colors.lime,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top:40),
                      width: MediaQuery.of(context).size.width,
                      height: 500,
                      child:Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                WeightActions(),
                              ],
                            ),
                          ]
                      ),
                    ),
                  ),
                ]
            )

        )
    );


  }
}