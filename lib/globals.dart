// packages
import 'package:flutter/material.dart';

const String url = "localhost:7041";
const String appVersion = "1.0.0-DEV";
const bool debug = false; //debug variable

User user = User();
NavigationDrawer navigationDrawer = NavigationDrawer();
List<Competition> competitions = <Competition>[
  Competition(
    id: 2,
    startDate: DateTime(2023),
    endDate: DateTime(2023),
    type: "d",
    description: "d",
    teams: [],
  ),
  Competition(
    id: 3,
    startDate: DateTime(2022),
    endDate: DateTime(2022),
    type: "ds",
    description: "sd",
    teams: [],
  ),
  Competition(
    id: 4,
    startDate: DateTime(2021),
    endDate: DateTime(2022, 12, 31),
    type: "ddew",
    description: "wedd",
    teams: [],
  )
];

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
  int? userID;
  User({this.firstName, this.lastName, this.token});
}

class Competition {
  int id;
  DateTime startDate;
  DateTime endDate;
  String type;
  String description;
  List<Team> teams;
  Competition({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.description,
    required this.teams,
  });

  String get startDateString {
    return "${startDate.day}.${startDate.month}.${startDate.year}";
  }

  String get endDateString {
    return "${endDate.day}.${endDate.month}.${endDate.year}";
  }

  String get state {
    if (endDate.isBefore(DateTime.now())) {
      return "Ukončena";
    }
    if (startDate.isAfter(DateTime.now())) {
      return "Plánovaná";
    }
    if (startDate.isBefore(DateTime.now()) && endDate.isAfter(DateTime.now())) {
      return "Probíhá";
    }
    return "Error";
  }
}

class Team {}

class FunctionObject {
  int statusCode; //status code of the response
  int functionCode; //function code of the function. 0 = success, 1 = error
  FunctionObject({required this.statusCode, required this.functionCode});
}
