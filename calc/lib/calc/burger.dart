
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ScientificCalculator.dart';
import 'SimpleCalculator.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text(
              'What you want?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.linear_scale),
            title: const Text('Demo'),
            onTap: () {
              Navigator.restorablePushNamed(
                  context, DemoCalculator.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Premium'),
            onTap: () {
              Navigator.restorablePushNamed(
                  context, ScientificCalculator.routeName);
            },
          ),
        ],
      ),
    );
  }
}