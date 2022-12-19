// packages
import 'package:flutter/material.dart';

const String url = "https://localhost:7041";
const String appVersion = "1.0.0-DEV";
const bool debug = false; //debug variable

User user = User();
NavigationDrawer navigationDrawer = NavigationDrawer();
List<Competition> competitions = [];
Competition? selectedCompetition;
String? loadMode;

Map competitionTypes = {
  1: 'Okresní',
  2: 'Krajská',
  3: 'Republiková',
  4: 'Mezinárodní',
  5: 'Testovací',
};

int getCompetitionTypeId({required String type}) {
  return competitionTypes.keys
      .firstWhere((k) => competitionTypes[k] == type, orElse: () => 0);
}

Map stationTypes = {
  1: 'Volný',
  2: 'Standart',
  3: 'Improvizace',
  4: 'Obvazovka',
  5: 'Transport',
};

int getStationTypeId({required String type}) {
  return stationTypes.keys
      .firstWhere((k) => stationTypes[k] == type, orElse: () => 0);
}

Map stationTiers = {
  1: 'Unkown',
  2: 'PrvniStupen',
  3: 'DruhyStupen',
};

int getStationTierId({required String tier}) {
  return stationTiers.keys
      .firstWhere((k) => stationTiers[k] == tier, orElse: () => 0);
}

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
  User({
    this.firstName,
    this.lastName,
    this.token,
    this.tokenId,
    this.userID,
  });
}

class Competition {
  int id;
  DateTime startDate;
  DateTime endDate;
  String type;
  String? description;
  List<Team> teams = [];
  List<Station> stations = [];
  Competition({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.type,
    this.description,
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
  int id; // id týmu
  int competitionId; // id soutěže, ke které tým patří
  int number; // číslo týmu
  String organization; // organizace, ke které tým patří
  int? points; // počet bodů týmu
  List<TeamMember> teamMembers = []; // členové týmu
  Team({
    required this.id,
    required this.competitionId,
    required this.number,
    required this.organization,
    this.points,
  });
}

class Station {
  int id;
  int competitionId;
  String title;
  int number;
  int type;
  int tier;
  DateTime created;
  Station({
    required this.id,
    required this.competitionId,
    required this.title,
    required this.number,
    required this.type,
    required this.tier,
    required this.created,
  });

  String get createdString {
    return "${created.day}.${created.month}.${created.year} ${created.hour}:${created.minute}";
  }
}

class TeamMember {
  int id;
  int teamId;
  String firstName;
  String lastName;
  int type;
  String? phoneNumber;
  String? birthDate;
  TeamMember({
    required this.id,
    required this.teamId,
    required this.firstName,
    required this.lastName,
    required this.type,
    this.phoneNumber,
    this.birthDate,
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
