// packages
import 'package:flutter/material.dart';

const String url = "localhost";
const String appVersion = "1.0.0-DEV";
const bool debug = true; //debug variable

User user = User();
NavigationDrawer navigationDrawer = NavigationDrawer();

class NavigationDrawer {
  bool expanded = false;
  int index = 0;

  Map navigationMap = {
    0: "/lobby",
    1: "/settings",
  };
}

class User {
  String? firstName;
  String? lastName;
  String? token;
  User({this.firstName, this.lastName, this.token});
}

class Competition {
  int id;
  DateTime startDate;
  DateTime endDate;
  String type;
  String description;
  Competition({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.description,
  });
}
