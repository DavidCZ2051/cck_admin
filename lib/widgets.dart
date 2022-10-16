// packages
import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;

class MyNavigationRail extends StatefulWidget {
  const MyNavigationRail({super.key, required this.isDrawerOpen});

  final bool isDrawerOpen;

  @override
  State<MyNavigationRail> createState() => _MyNavigationRailState();
}

class _MyNavigationRailState extends State<MyNavigationRail> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: widget.isDrawerOpen,
      indicatorColor: Colors.red,
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
      selectedIndex: selectedIndex,
    );
  }
}
