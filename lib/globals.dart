// packages
import 'package:flutter/material.dart';

const String url = "https://localhost:7041";
const String appVersion = "1.0.4-BETA";
const bool debug = false; //debug variable

User user = User();
NavigationDrawer navigationDrawer = NavigationDrawer();
List<Competition> competitions = [];
Competition? selectedCompetition;
Station? selectedStation;
Team? selectedTeam;
Injury? selectedInjury;
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
  1: 'Unknown',
  2: 'První stupeň',
  3: 'Druhý stupeň',
};

int getStationTierId({required String tier}) {
  return stationTiers.keys
      .firstWhere((k) => stationTiers[k] == tier, orElse: () => 0);
}

Map teamMemberTypes = {
  1: 'Velitel',
  2: 'Doprovod',
  3: 'Člen',
};

int getTeamMemberTypeId({required String type}) {
  return teamMemberTypes.keys
      .firstWhere((k) => teamMemberTypes[k] == type, orElse: () => 0);
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
  List<TeamMember> members = []; // členové týmu
  Team({
    required this.id,
    required this.competitionId,
    required this.number,
    required this.organization,
    this.points,
  });

  Map<String, dynamic> get map {
    return {
      "id": id,
      "competitionId": competitionId,
      "number": number,
      "organization": organization,
      "points": points,
    };
  }
}

class Station {
  int id;
  int competitionId;
  String title;
  int number;
  int type;
  int tier;
  DateTime created;
  List<Injury> injuries = [];
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

  Map<String, dynamic> get map {
    return {
      "id": id,
      "competitionId": competitionId,
      "title": title,
      "number": number,
      "type": type,
      "tier": tier,
      "created": created,
    };
  }
}

class TeamMember {
  int id;
  int teamId;
  String firstName;
  String lastName;
  int type; // 1 - velitel, 2 - doprovod, 3 - člen
  String? phoneNumber;
  String? birthDate;
  String? signature;
  TeamMember({
    required this.id,
    required this.teamId,
    required this.firstName,
    required this.lastName,
    required this.type,
    this.phoneNumber,
    this.birthDate,
    this.signature,
  });

  Map<String, dynamic> get map {
    return {
      "id": id,
      "teamId": teamId,
      "firstName": firstName,
      "lastName": lastName,
      "type": type,
      "phoneNumber": phoneNumber,
      "birthDate": birthDate,
    };
  }

  String get qrJson {
    return '{"id":$id,"signature":"$signature"}';
  }
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

class Injury {
  int id;
  int stationId;
  int refereeId;
  String letter;
  String situation;
  String diagnosis;
  int maximalPoints;
  String necessaryEquipment;
  String? info;
  List<Figurant> figurants = [];
  List<TreatmentProcedure> treatmentProcedures = [];
  List<Task> tasks = [];
  Injury({
    required this.id,
    required this.stationId,
    required this.refereeId,
    required this.letter,
    required this.situation,
    required this.diagnosis,
    required this.maximalPoints,
    required this.necessaryEquipment,
    required this.info,
  });

  Map<String, dynamic> get map {
    return {
      "id": id,
      "stationId": stationId,
      "refereeId": refereeId,
      "letter": letter,
      "situation": situation,
      "diagnosis": diagnosis,
      "maximalPoints": maximalPoints,
      "necessaryEquipment": necessaryEquipment,
      "info": info,
    };
  }
}

class Figurant {
  int id;
  int injuryId;
  String instructions;
  String makeup;
  Figurant({
    required this.id,
    required this.injuryId,
    required this.instructions,
    required this.makeup,
  });

  Map<String, dynamic> get map {
    return {
      "id": id,
      "injuryId": injuryId,
      "instructions": instructions,
      "makeup": makeup,
    };
  }
}

class TreatmentProcedure {
  int id;
  int injuryId;
  String activity;
  int order;
  TreatmentProcedure({
    required this.id,
    required this.injuryId,
    required this.activity,
    required this.order,
  });

  Map<String, dynamic> get map {
    return {
      "id": id,
      "injuryId": injuryId,
      "activity": activity,
      "order": order,
    };
  }
}

class Task {
  int id;
  int injuryId;
  String title;
  int maximalMinusPoints;
  Task({
    required this.id,
    required this.injuryId,
    required this.title,
    required this.maximalMinusPoints,
  });

  Map<String, dynamic> get map {
    return {
      "id": id,
      "injuryId": injuryId,
      "title": title,
      "maximalMinusPoints": maximalMinusPoints,
    };
  }
}
