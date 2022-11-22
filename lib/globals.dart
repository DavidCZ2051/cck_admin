// packages
import 'package:flutter/material.dart';

const String url = "https://localhost:7041";
const String appVersion = "1.0.0-DEV";
const bool debug = false; //debug variable

User user = User();
NavigationDrawer navigationDrawer = NavigationDrawer();
List<Competition> competitions = [];
Competition? selectedCompetition;

Map competitionTypes = {
  1: 'Okresní',
  2: 'Krajské',
  3: 'Republikové',
  4: 'Mezinárodní',
  5: 'Testovací',
};

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
  List<Team> teams = [];
  Competition({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.description,
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

class Team {
  int id;
  int competitionId;
  int number;
  String organization;
  int? points;
  Team({
    required this.id,
    required this.competitionId,
    required this.number,
    required this.organization,
    this.points,
  });
}

enum FunctionCode {
  success,
  error,
  connectionError;
}

class FunctionObject {
  final int? statusCode; //status code of the response
  FunctionCode
      functionCode; //function code of the function. see enum FunctionCode
  FunctionObject({this.statusCode, required this.functionCode});
}
