// packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
// files
import 'package:cck_admin/globals.dart' as globals;

String formatDateTime({required DateTime dateTime}) {
  return "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year.toString()}";
}

Future<globals.FunctionObject> login({
  required String email,
  required String password,
}) async {
  try {
    Response response = await get(
      Uri.parse("${globals.url}/api/login"),
      headers: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      globals.user.token = data['hash'];
      globals.user.userID = data['userId'];
      return globals.FunctionObject(
        functionCode: globals.FunctionCode.success,
        statusCode: response.statusCode,
      );
    } else {
      return globals.FunctionObject(
        functionCode: globals.FunctionCode.error,
        statusCode: response.statusCode,
      );
    }
  } on SocketException catch (_) {
    return globals.FunctionObject(
      functionCode: globals.FunctionCode.connectionError,
    );
  }
}

Future<globals.FunctionObject> getCompetitions({required String token}) async {
  Response response = await get(
    Uri.parse("${globals.url}/api/competitions"),
    headers: {
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);
    for (Map competition in data) {
      globals.competitions.add(globals.Competition(
        id: competition['id'],
        startDate: DateTime.parse(competition['startDate']),
        endDate: DateTime.parse(competition['endDate']),
        type: globals.competitionTypes[competition['type']],
        description: competition['description'],
      ));
    }

    return globals.FunctionObject(
      functionCode: globals.FunctionCode.success,
      statusCode: response.statusCode,
    );
  } else {
    return globals.FunctionObject(
      functionCode: globals.FunctionCode.error,
      statusCode: response.statusCode,
    );
  }
}

Future<globals.FunctionObject> getTeams({required String token}) async {
  Response response = await get(
    Uri.parse("${globals.url}/api/teams"),
    headers: {
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);
    for (Map team in data) {
      for (globals.Competition competition in globals.competitions) {
        if (competition.id == team['competitionId']) {
          competition.teams.add(globals.Team(
            id: team['id'],
            competitionId: team['competitionId'],
            number: team['number'],
            organization: team['organization'],
            points: team['points'],
          ));
        }
      }
    }

    return globals.FunctionObject(
      functionCode: globals.FunctionCode.success,
      statusCode: response.statusCode,
    );
  } else {
    return globals.FunctionObject(
      functionCode: globals.FunctionCode.error,
      statusCode: response.statusCode,
    );
  }
}

Future<globals.FunctionObject> deleteCompetition({
  required String token,
  required int competitionId,
}) async {
  Response response = await delete(
    Uri.parse("${globals.url}/api/competitions/$competitionId"),
    headers: {
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    return globals.FunctionObject(
      functionCode: globals.FunctionCode.success,
      statusCode: response.statusCode,
    );
  } else {
    return globals.FunctionObject(
      functionCode: globals.FunctionCode.error,
      statusCode: response.statusCode,
    );
  }
}

Future<globals.FunctionObject> createCompetition({
  required String token,
  required Map<String, dynamic> competition,
}) async {
  Response response = await post(
    Uri.parse("${globals.url}/api/competitions"),
    headers: {
      'token': token,
    },
    body: {
      'startDate': competition['startDate'],
      'endDate': competition['endDate'],
      'type': competition['type'].toString(),
      if (competition['description'] != null)
        'description': competition['description'],
    },
  );

  if (response.statusCode == 201) {
    return globals.FunctionObject(
      functionCode: globals.FunctionCode.success,
      statusCode: response.statusCode,
    );
  } else {
    return globals.FunctionObject(
      functionCode: globals.FunctionCode.error,
      statusCode: response.statusCode,
    );
  }
}

Future<globals.FunctionObject> getStations({required String token}) async {
  Response response = await get(
    Uri.parse("${globals.url}/api/stations"),
    headers: {
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    List stations = jsonDecode(response.body);
    for (Map station in stations) {
      for (globals.Competition competition in globals.competitions) {
        if (competition.id == station['competitionId']) {
          competition.stations.add(globals.Station(
            id: station['id'],
            competitionId: station['competitionId'],
            title: station['title'],
            number: station['number'],
            type: station['type'],
            tier: station['tier'],
            created: station['created'],
          ));
        }
      }
    }

    return globals.FunctionObject(
      functionCode: globals.FunctionCode.success,
      statusCode: response.statusCode,
    );
  } else {
    return globals.FunctionObject(
      functionCode: globals.FunctionCode.error,
      statusCode: response.statusCode,
    );
  }
}
