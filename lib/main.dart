//packages
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:window_size/window_size.dart';
//routes
import 'package:cck_admin/routes/lobby.dart';
import 'package:cck_admin/routes/login.dart';
import 'package:cck_admin/routes/settings.dart';
import 'package:cck_admin/routes/competitions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('ČČK Admin');
    setWindowVisibility(visible: true);
    setWindowMaxSize(const Size(1920, 1080));
    setWindowMinSize(const Size(500, 700));
  }
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
