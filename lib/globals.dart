// packages
import 'package:flutter/material.dart';

const String url = "https://localhost:7041";
const String appVersion = "1.0.0-DEV";
const bool debug = false; //debug variable

User user = User();
NavigationDrawer navigationDrawer = NavigationDrawer();
List<Competition> competitions = <Competition>[];

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
  int? tokenId;
  int? userID;
  User({this.firstName, this.lastName, this.token, this.tokenId, this.userID});
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

enum FunctionCode {
  success,
  error;
}

class FunctionObject {
  int statusCode; //status code of the response
  FunctionCode
      functionCode; //function code of the function. see enum FunctionCode
  FunctionObject({required this.statusCode, required this.functionCode});
}
