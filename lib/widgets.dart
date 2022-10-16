// packages
import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;

class MyNavigationRail extends StatefulWidget {
  const MyNavigationRail({super.key});

  @override
  State<MyNavigationRail> createState() => _MyNavigationRailState();
}

class _MyNavigationRailState extends State<MyNavigationRail> {
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: globals.navigationDrawer.expanded,
      indicatorColor: Colors.red,
      onDestinationSelected: (value) {
        setState(() {
          if (globals.navigationDrawer.index != value) {
            globals.navigationDrawer.index = value;

            Navigator.pushReplacementNamed(
                context, globals.navigationDrawer.navigationMap[value]);
          }
        });
      },
      destinations: <NavigationRailDestination>[
        NavigationRailDestination(
          icon: const Icon(Icons.home),
          label: const Text("Lobby"),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.settings),
          label: const Text("Nastavení"),
        ),
      ],
      selectedIndex: globals.navigationDrawer.index,
    );
  }
}
