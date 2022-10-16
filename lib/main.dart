//packages
import 'package:flutter/material.dart';
//routes
import 'package:cck_admin/routes/lobby.dart';
import 'package:cck_admin/routes/login.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      routes: {
        "/login": (context) => const Login(),
        "/lobby": (context) => const Lobby(),
      },
      title: "ČČK Admin",
      color: Colors.red,
    ),
  );
}
