//packages
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
//routes
import 'package:cck_admin/routes/lobby.dart';
import 'package:cck_admin/routes/login.dart';
import 'package:cck_admin/routes/settings.dart';
import 'package:cck_admin/routes/competitions.dart';
import 'package:cck_admin/routes/loading.dart';
import 'package:cck_admin/routes/competition.dart';
import 'package:cck_admin/routes/teams.dart';
import 'package:cck_admin/routes/stations.dart';
import 'package:cck_admin/routes/injuries.dart';
import 'package:cck_admin/routes/team.dart';
import 'package:cck_admin/routes/injury.dart';
import 'package:cck_admin/routes/figurants.dart';
import 'package:cck_admin/routes/tasks.dart';
import 'package:cck_admin/routes/treatments.dart';
// files
import 'package:cck_admin/globals.dart' as globals;

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      routes: {
        "/login": (context) => const Login(),
        '/loading': (context) => const Loading(),
        "/lobby": (context) => const Lobby(),
        "/settings": (context) => const Settings(),
        "/competitions": (context) => const Competitions(),
        "/competition": (context) => const Competition(),
        "/teams": (context) => const Teams(),
        "/stations": (context) => const Stations(),
        "/injuries": (context) => const Injuries(),
        "/team": (context) => const Team(),
        "/injury": (context) => const Injury(),
        "/figurants": (context) => const Figurants(),
        "/tasks": (context) => const Tasks(),
        "/treatments": (context) => const Treatments(),
      },
      title: "ČČK Admin",
      color: Colors.red,
    ),
  );

  doWhenWindowReady(() {
    appWindow.minSize = const Size(1030, 650);
    appWindow.size = const Size(1030, 650);
    appWindow.alignment = Alignment.center;
    appWindow.title = "ČČK Admin";
    appWindow.show();
  });
}
