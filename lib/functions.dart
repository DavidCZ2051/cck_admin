// packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
// files
import 'package:cck_admin/globals.dart' as globals;

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