
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/LengthConversion.dart';


class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:Column(
        children: [
          AppBar(
            centerTitle: false,
            backgroundColor: Colors.lime,
            toolbarHeight: 40,
            //elevation: 50.0,
             leading: IconButton(
               icon: const Icon(Icons.menu),
               tooltip: 'Menu Icon',
               onPressed: (){
                 Navigator.pop(context);
             }
              // color: Colors.black,
             ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.linear_scale),
            title: Text('Length'),
            onTap: () {
              Navigator.restorablePushNamed(
                  context, '/length');
            },
          ),
          ListTile(
            leading: Icon(Icons.thermostat_outlined),
            title: Text('Temperature'),
            onTap: () {
              Navigator.restorablePushNamed(
                  context, '/temperature');
            },
          ),
          ListTile(
            leading: Icon(Icons.scale),
            title: Text('Weight'),
            onTap: () {
              Navigator.restorablePushNamed(
                  context, '/weight');
            },
          ),


        ],
      )


    );
  }
}