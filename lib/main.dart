//packages
import 'package:flutter/material.dart';
//routes
import 'package:cck_admin/routes/lobby.dart';
import 'package:cck_admin/routes/login.dart';
import 'package:cck_admin/routes/settings.dart';
import 'package:cck_admin/routes/competitions.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      routes: {
        "/login": (context) => const Login(),
        "/lobby": (context) => const Lobby(),
        "/settings": (context) => const Settings(),
        "/competitions": (context) => const Competitions(),
      },
      title: "ČČK Admin",
      color: Colors.red,
    ),
  );
}
