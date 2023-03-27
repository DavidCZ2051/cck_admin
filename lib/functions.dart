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

// Competitions

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

Future<globals.FunctionObject> editCompetition({
  required String token,
  required int competitionId,
  required Map<String, dynamic> competition,
}) async {
  Response response = await put(
    Uri.parse("${globals.url}/api/competitions/$competitionId"),
    headers: {
      'token': token,
    },
    body: {
      'startDate': competition['startDate'],
      'endDate': competition['endDate'],
      'type': competition['type'].toString(),
      'description': competition['description'],
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

// Teams

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
            tier: team['tier'],
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

Future<globals.FunctionObject> createTeam({
  required String token,
  required Map<String, dynamic> team,
}) async {
  Response response = await post(
    Uri.parse("${globals.url}/api/teams"),
    headers: {
      'token': token,
    },
    body: {
      'competitionId': team['competitionId'].toString(),
      'number': team['number'].toString(),
      'organization': team['organization'],
      'tier': team['tier'].toString(),
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

Future<globals.FunctionObject> deleteTeam(
    {required String token, required int teamId}) async {
  Response response = await delete(
    Uri.parse("${globals.url}/api/teams/$teamId"),
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

Future<globals.FunctionObject> editTeam({
  required String token,
  required Map<String, dynamic> team,
}) async {
  print(team);

  Response response = await put(
    Uri.parse("${globals.url}/api/teams/${team['id']}"),
    headers: {
      'token': token,
    },
    body: {
      'number': team['number'].toString(),
      'competitionId': team['competitionId'].toString(),
      'organization': team['organization'],
      'tier': team['tier'].toString(),
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

// Team Members

Future<globals.FunctionObject> getTeamMembers({required String token}) async {
  Response response = await get(
    Uri.parse("${globals.url}/api/teams/members"),
    headers: {
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);
    for (Map member in data) {
      for (globals.Competition competition in globals.competitions) {
        for (globals.Team team in competition.teams) {
          if (team.id == member['teamId']) {
            team.members.add(globals.TeamMember(
              id: member['id'],
              teamId: member['teamId'],
              firstName: member['firstName'],
              lastName: member['lastName'],
              type: member['type'],
              phoneNumber: member['phoneNumber'],
              birthDate: member['birthdate'],
            ));
          }
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

Future<globals.FunctionObject> deleteTeamMember(
    {required String token, required int teamMemberId}) async {
  Response response = await delete(
    Uri.parse("${globals.url}/api/teams/members/$teamMemberId"),
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

Future<globals.FunctionObject> createTeamMember({
  required String token,
  required Map<String, dynamic> teamMember,
}) async {
  Response response = await post(
    Uri.parse("${globals.url}/api/teams/members"),
    headers: {
      'token': token,
    },
    body: {
      "teamId": teamMember['teamId'].toString(),
      "firstName": teamMember['firstName'],
      "lastName": teamMember['lastName'],
      "type": teamMember['type'].toString(),
      if (teamMember['phoneNumber'] != null)
        "phoneNumber": teamMember['phoneNumber'],
      if (teamMember['birthDate'] != null) "birthDate": teamMember['birthDate'],
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

Future<globals.FunctionObject> editTeamMember({
  required String token,
  required Map<String, dynamic> teamMember,
}) async {
  print(teamMember);

  Response response = await put(
    Uri.parse("${globals.url}/api/teams/members/${teamMember['id']}"),
    headers: {
      'token': token,
    },
    body: {
      "teamId": teamMember['teamId'].toString(),
      "firstName": teamMember['firstName'],
      "lastName": teamMember['lastName'],
      "type": teamMember['type'].toString(),
      if (teamMember['phoneNumber'] != null)
        "phoneNumber": teamMember['phoneNumber'],
      if (teamMember['birthDate'] != null) "birthDate": teamMember['birthDate'],
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

// Stations

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
            created: DateTime.parse(station['created']),
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

Future<globals.FunctionObject> editStation({
  required String token,
  required int stationId,
  required Map<String, dynamic> station,
}) async {
  print(station);

  Response response = await put(
    Uri.parse("${globals.url}/api/stations/$stationId"),
    headers: {
      'token': token,
    },
    body: {
      'competitionId': station['competitionId'].toString(),
      'title': station['title'],
      'number': station['number'].toString(),
      'type': station['type'].toString(),
      'tier': station['tier'].toString(),
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

Future<globals.FunctionObject> deleteStation({
  required String token,
  required int stationId,
}) async {
  Response response = await delete(
    Uri.parse("${globals.url}/api/stations/$stationId"),
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

Future<globals.FunctionObject> createStation({
  required String token,
  required Map<String, dynamic> station,
  required int competitionId,
}) async {
  Response response = await post(
    Uri.parse("${globals.url}/api/stations"),
    headers: {
      'token': token,
    },
    body: {
      'competitionId': competitionId.toString(),
      'title': station['title'],
      'number': station['number'].toString(),
      'type': station['type'].toString(),
      'tier': station['tier'].toString(),
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

// Injuries

Future<globals.FunctionObject> getInjuries({
  required String token,
}) async {
  Response response = await get(
    Uri.parse("${globals.url}/api/injuries"),
    headers: {
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    List injuries = jsonDecode(response.body);
    for (Map injury in injuries) {
      for (globals.Competition competition in globals.competitions) {
        for (globals.Station station in competition.stations) {
          if (station.id == injury['stationId']) {
            station.injuries.add(globals.Injury(
              id: injury['id'],
              stationId: injury['stationId'],
              refereeId: injury['refereeId'],
              letter: injury['letter'],
              situation: injury['situation'],
              diagnosis: injury['diagnose'],
              maximalPoints: injury['maximalPoints'],
              necessaryEquipment: injury['neccesseryEquipment'],
              info: injury['info'],
            ));
          }
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

Future<globals.FunctionObject> createInjury({
  required String token,
  required Map<String, dynamic> injury,
}) async {
  Response response = await post(
    Uri.parse("${globals.url}/api/injuries"),
    headers: {
      'token': token,
    },
    body: {
      'stationId': injury['stationId'].toString(),
      'refereeId': injury['refereeId'].toString(),
      'letter': injury['letter'],
      'situation': injury['situation'],
      'diagnose': injury['diagnosis'],
      'maximalPoints': injury['maximalPoints'].toString(),
      'neccesseryEquipment': injury['necessaryEquipment'],
      'info': injury['info'] ?? '',
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

Future<globals.FunctionObject> editInjury({
  required String token,
  required int injuryId,
  required Map<String, dynamic> injury,
}) async {
  Response response = await put(
    Uri.parse("${globals.url}/api/injuries/$injuryId"),
    headers: {
      'token': token,
    },
    body: {
      'stationId': injury['stationId'].toString(),
      'refereeId': injury['refereeId'].toString(),
      'letter': injury['letter'],
      'situation': injury['situation'],
      'diagnose': injury['diagnosis'],
      'maximalPoints': injury['maximalPoints'].toString(),
      'neccesseryEquipment': injury['necessaryEquipment'],
      'info': injury['info'],
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

Future<globals.FunctionObject> deleteInjury({
  required String token,
  required int injuryId,
}) async {
  Response response = await delete(
    Uri.parse("${globals.url}/api/injuries/$injuryId"),
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

// Figurants

Future<globals.FunctionObject> editFigurant({
  required String token,
  required Map<String, dynamic> figurant,
}) async {
  Response response = await put(
    Uri.parse("${globals.url}/api/figurants/${figurant['id']}"),
    headers: {
      'token': token,
    },
    body: {
      'injurieId': figurant['injuryId'].toString(),
      'instructions': figurant['instructions'],
      'makeUp': figurant['makeup'],
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

Future<globals.FunctionObject> getFigurants({
  required String token,
}) async {
  Response response = await get(
    Uri.parse("${globals.url}/api/figurants"),
    headers: {
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    List figurants = jsonDecode(response.body);
    for (Map figurant in figurants) {
      for (globals.Competition competition in globals.competitions) {
        for (globals.Station station in competition.stations) {
          for (globals.Injury injury in station.injuries) {
            if (injury.id == figurant["injurieId"]) {
              injury.figurants.add(globals.Figurant(
                id: figurant["id"],
                injuryId: figurant["injurieId"],
                instructions: figurant["instructions"],
                makeup: figurant["makeUp"],
              ));
            }
          }
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

Future<globals.FunctionObject> deleteFigurant({
  required String token,
  required int figurantId,
}) async {
  Response response = await delete(
    Uri.parse("${globals.url}/api/figurants/$figurantId"),
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

Future<globals.FunctionObject> createFigurant({
  required String token,
  required Map<String, dynamic> figurant,
}) async {
  Response response = await post(
    Uri.parse("${globals.url}/api/figurants"),
    headers: {
      'token': token,
    },
    body: {
      "injurieId": figurant["injuryId"].toString(),
      "instructions": figurant["instructions"],
      "makeUp": figurant["makeup"],
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

// Injury Tasks

Future<globals.FunctionObject> deleteInjuryTask({
  required String token,
  required int injuryTaskId,
}) async {
  Response response = await delete(
    Uri.parse("${globals.url}/api/injurietasks/$injuryTaskId"),
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

Future<globals.FunctionObject> getInjuryTasks({
  required String token,
}) async {
  Response response = await get(
    Uri.parse("${globals.url}/api/injurietasks"),
    headers: {
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    List injuryTasks = jsonDecode(response.body);
    for (Map injuryTask in injuryTasks) {
      for (globals.Competition competition in globals.competitions) {
        for (globals.Station station in competition.stations) {
          for (globals.Injury injury in station.injuries) {
            if (injury.id == injuryTask["injurieId"]) {
              injury.tasks.add(globals.Task(
                id: injuryTask["id"],
                injuryId: injuryTask["injurieId"],
                maximalMinusPoints: injuryTask["maximalMinusPoints"],
                title: injuryTask["title"],
              ));
            }
          }
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

Future<globals.FunctionObject> createInjuryTask({
  required String token,
  required Map<String, dynamic> task,
}) async {
  Response response = await post(
    Uri.parse("${globals.url}/api/injurietasks"),
    headers: {
      'token': token,
    },
    body: {
      "injurieId": task["injuryId"].toString(),
      "title": task["title"],
      "maximalMinusPoints": task["maximalMinusPoints"].toString(),
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

Future<globals.FunctionObject> editInjuryTask({
  required String token,
  required Map<String, dynamic> injuryTask,
}) async {
  Response response = await put(
    Uri.parse("${globals.url}/api/injurietasks/${injuryTask['id']}"),
    headers: {
      'token': token,
    },
    body: {
      "injurieId": injuryTask["injuryId"].toString(),
      "title": injuryTask["title"],
      "maximalMinusPoints": injuryTask["maximalMinusPoints"].toString(),
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

// Treatment Procedures

Future<globals.FunctionObject> deleteTreatmentProcedure({
  required String token,
  required int treatmentProdecureId,
}) async {
  Response response = await delete(
    Uri.parse("${globals.url}/api/treathment/$treatmentProdecureId"),
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

Future<globals.FunctionObject> createTreatmentProcedure({
  required String token,
  required Map<String, dynamic> treatmentProcedure,
}) async {
  Response response = await post(
    Uri.parse("${globals.url}/api/treathment"),
    headers: {
      'token': token,
    },
    body: {
      "injurieId": treatmentProcedure["injuryId"].toString(),
      "order": treatmentProcedure["order"].toString(),
      "activity": treatmentProcedure["activity"],
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

Future<globals.FunctionObject> getTreatmentProcedures({
  required String token,
}) async {
  Response response = await get(
    Uri.parse("${globals.url}/api/treathment"),
    headers: {
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    List treatmentProcedures = jsonDecode(response.body);
    for (Map treatmentProcedure in treatmentProcedures) {
      for (globals.Competition competition in globals.competitions) {
        for (globals.Station station in competition.stations) {
          for (globals.Injury injury in station.injuries) {
            if (injury.id == treatmentProcedure["injurieId"]) {
              injury.treatmentProcedures.add(globals.TreatmentProcedure(
                id: treatmentProcedure["id"],
                activity: treatmentProcedure["activity"],
                injuryId: treatmentProcedure["injurieId"],
                order: treatmentProcedure["order"],
              ));
            }
          }
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

Future<globals.FunctionObject> editTreatmentProcedure({
  required String token,
  required Map<String, dynamic> treatmentProcedure,
}) async {
  Response response = await put(
    Uri.parse("${globals.url}/api/treathment/${treatmentProcedure["id"]}"),
    headers: {
      'token': token,
    },
    body: {
      "injurieId": treatmentProcedure["injuryId"].toString(),
      "order": treatmentProcedure["order"].toString(),
      "activity": treatmentProcedure["activity"],
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

// QR Codes

Future<globals.FunctionObject> getQrCodes({required String token}) async {
  for (globals.Competition competition in globals.competitions) {
    for (globals.Team team in competition.teams) {
      for (globals.TeamMember teamMember in team.members) {
        if (teamMember.type == 1) {
          final response = await get(
            Uri.parse("${globals.url}/api/qrcode/leader/${teamMember.id}"),
            headers: {
              'token': token,
            },
          );
          if (response.statusCode == 200) {
            teamMember.signature = jsonDecode(response.body)["signature"];
          } else {
            return globals.FunctionObject(
              functionCode: globals.FunctionCode.error,
              statusCode: response.statusCode,
            );
          }
        }
      }
    }
  }
  return globals.FunctionObject(
    functionCode: globals.FunctionCode.success,
    statusCode: 200,
  );
}

// Referees

Future<globals.FunctionObject> getReferees({required String token}) async {
  final response = await get(
    Uri.parse("${globals.url}/api/users/referee"),
    headers: {
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    List referees = jsonDecode(response.body);
    for (Map referee in referees) {
      globals.referees.add(globals.User(
        userID: referee["id"],
        firstName: referee["firstName"],
        lastName: referee["lastName"],
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
