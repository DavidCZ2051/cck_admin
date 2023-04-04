// packages
import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/widgets.dart' as widgets;

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            setState(() {
              globals.navigationDrawer.expanded =
                  !globals.navigationDrawer.expanded;
            });
          },
        ),
        backgroundColor: Colors.red,
        title: const Text("Nastavení"),
      ),
      body: Row(
        children: const <Widget>[
          widgets.MyNavigationRail(),
          VerticalDivider(thickness: 1.5, width: 1),
          Expanded(
            child: Center(
              child: Text("Nastavení"),
            ),
          ),
        ],
      ),
    );
  }
}
