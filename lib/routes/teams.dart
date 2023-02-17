// packages
import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/widgets.dart' as widgets;
import 'package:cck_admin/functions.dart' as functions;

class Teams extends StatefulWidget {
  const Teams({super.key});

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  Map<String, dynamic> newTeam = {};
  Map<String, dynamic> editTeam = {};
  Map<String, bool> loading = {
    "delete": false,
    "create": false,
    "edit": false,
  };

  setstate() {
    setState(() {});
  }

  handleTeamDelete({
    required String token,
    required int teamId,
  }) async {
    setState(() {
      loading["delete"] = true;
    });
    setstate();
    print("Deleting team with id: $teamId");
    var object = await functions.deleteTeam(
      token: token,
      teamId: teamId,
    );
    setState(() {
      loading["delete"] = false;
    });
    setstate();

    if (object.functionCode == globals.FunctionCode.success) {
      setState(() {
        globals.selectedCompetition!.teams.removeWhere(
          (team) => team.id == teamId,
        );
      });
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return widgets.ErrorDialog(
              statusCode: object.statusCode!,
            );
          });
    }
  }

  handleTeamCreate({
    required String token,
    required Map<String, dynamic> team,
  }) async {
    team["competitionId"] = globals.selectedCompetition!.id;

    setState(() {
      loading["create"] = true;
    });
    setstate();

    print("Creating team with data: $team");
    var object = await functions.createTeam(
      token: token,
      team: team,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.selectedCompetition!.teams = [];
      object = await functions.getTeams(
        token: token,
      );
      setState(() {
        loading["create"] = false;
      });
      setstate();
      if (object.functionCode == globals.FunctionCode.success) {
        Navigator.pop(context);
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return widgets.ErrorDialog(
                statusCode: object.statusCode!,
              );
            });
      }
    } else {
      setState(() {
        loading["create"] = false;
      });
      setstate();
      showDialog(
          context: context,
          builder: (context) {
            return widgets.ErrorDialog(
              statusCode: object.statusCode!,
            );
          });
    }
  }

  handleTeamEdit({
    required String token,
    required Map<String, dynamic> team,
  }) async {
    setState(() {
      loading["edit"] = true;
    });
    setstate();

    print("Editing team with data: $team");
    var object = await functions.editTeam(
      token: token,
      team: team,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.selectedCompetition!.teams = [];
      object = await functions.getTeams(
        token: token,
      );
      setState(() {
        loading["edit"] = false;
      });
      setstate();
      if (object.functionCode == globals.FunctionCode.success) {
        Navigator.pop(context);
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return widgets.ErrorDialog(
                statusCode: object.statusCode!,
              );
            });
      }
    } else {
      setState(() {
        loading["edit"] = false;
      });
      setstate();
      showDialog(
          context: context,
          builder: (context) {
            return widgets.ErrorDialog(
              statusCode: object.statusCode!,
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const widgets.WindowsStuff(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 250,
                      maxWidth: 330,
                    ),
                    child: Column(
                      children: [
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Text(globals.selectedCompetition!.type),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      globals.loadMode = "competitions";
                                      Navigator.pushReplacementNamed(
                                          context, "/loading");
                                    },
                                    child: const Text("Zpět"),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      globals
                                          .selectedCompetition!.startDateString,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      globals
                                          .selectedCompetition!.endDateString,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        globals.selectedCompetition!.state),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.home),
                          title: const Text("Přehled soutěže"),
                          onTap: () {
                            Navigator.pushNamed(context, "/competition");
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.room),
                          title: const Text("Stanoviště"),
                          onTap: () {
                            Navigator.pushNamed(context, "/stations");
                          },
                        ),
                        const ListTile(
                          leading: Icon(
                            Icons.people,
                            color: Colors.red,
                          ),
                          title: Text(
                            "Týmy",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          selected: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Row(
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            onPressed: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text("Přidání týmu"),
                                        content: loading["create"] == true
                                            ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  CircularProgressIndicator(),
                                                ],
                                              )
                                            : Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    cursorColor: Colors.red,
                                                    initialValue: newTeam[
                                                                    "number"]
                                                                .toString() ==
                                                            "null"
                                                        ? ""
                                                        : newTeam["number"]
                                                            .toString(),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelStyle: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      labelText:
                                                          "Číslo (číslo)",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newTeam["number"] =
                                                            int.tryParse(value);
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    cursorColor: Colors.red,
                                                    initialValue:
                                                        newTeam["organization"],
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "Organizace",
                                                      labelStyle: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newTeam["organization"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                        actions: [
                                          TextButton(
                                            style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red[50]),
                                            ),
                                            onPressed: loading["create"] == true
                                                ? null
                                                : () {
                                                    newTeam = {};
                                                    Navigator.pop(context);
                                                  },
                                            child: const Text(
                                              "Zrušit",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red),
                                            ),
                                            onPressed: loading["create"] == true
                                                ? null
                                                : (newTeam["number"] == null ||
                                                        newTeam["organization"] ==
                                                            null)
                                                    ? null
                                                    : () async {
                                                        await handleTeamCreate(
                                                          token: globals
                                                              .user.token!,
                                                          team: newTeam,
                                                        );

                                                        newTeam = {};
                                                      },
                                            child: const Text("Přidat tým"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            label: const Text("Přidat"),
                          ),
                          const SizedBox(width: 40),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.edit),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            onPressed: globals.selectedTeam == null
                                ? null
                                : () {
                                    editTeam = globals.selectedTeam!.map;
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title: const Text("Úprava týmu"),
                                              content: loading["edit"] == true
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const [
                                                        CircularProgressIndicator(),
                                                      ],
                                                    )
                                                  : Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextFormField(
                                                          cursorColor:
                                                              Colors.red,
                                                          initialValue: editTeam[
                                                                          "number"]
                                                                      .toString() ==
                                                                  "null"
                                                              ? ""
                                                              : editTeam[
                                                                      "number"]
                                                                  .toString(),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              const InputDecoration(
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            labelStyle:
                                                                TextStyle(
                                                              color: Colors.red,
                                                            ),
                                                            labelText:
                                                                "Číslo (číslo)",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editTeam[
                                                                      "number"] =
                                                                  int.tryParse(
                                                                      value);
                                                            });
                                                          },
                                                        ),
                                                        TextFormField(
                                                          cursorColor:
                                                              Colors.red,
                                                          initialValue: editTeam[
                                                              "organization"],
                                                          decoration:
                                                              const InputDecoration(
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            labelStyle:
                                                                TextStyle(
                                                              color: Colors.red,
                                                            ),
                                                            labelText:
                                                                "Organizace",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editTeam[
                                                                      "organization"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                              actions: [
                                                TextButton(
                                                  style: ButtonStyle(
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .all(
                                                                Colors.red[50]),
                                                  ),
                                                  onPressed:
                                                      loading["edit"] == true
                                                          ? null
                                                          : () {
                                                              editTeam = {};
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                  child: const Text(
                                                    "Zrušit",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.red),
                                                  ),
                                                  onPressed: loading["edit"] ==
                                                          true
                                                      ? null
                                                      : (editTeam["number"] ==
                                                                  null ||
                                                              editTeam[
                                                                      "organization"] ==
                                                                  null)
                                                          ? null
                                                          : () async {
                                                              await handleTeamEdit(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                team: editTeam,
                                                              );
                                                              editTeam = {};
                                                            },
                                                  child:
                                                      const Text("Upravit tým"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                            label: const Text("Upravit"),
                          ),
                          const SizedBox(width: 40),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.delete),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            onPressed: globals.selectedTeam == null
                                ? null
                                : () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title: const Text("Smazání týmu"),
                                              content: loading["delete"] == true
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const [
                                                        CircularProgressIndicator(),
                                                      ],
                                                    )
                                                  : const Text(
                                                      "Opravdu chcete smazat tým?"),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      loading["delete"] == true
                                                          ? null
                                                          : () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                  child: const Text(
                                                    "Zrušit",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      Colors.red,
                                                    ),
                                                  ),
                                                  onPressed:
                                                      loading["delete"] == true
                                                          ? null
                                                          : () async {
                                                              await handleTeamDelete(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                teamId: globals
                                                                    .selectedTeam!
                                                                    .id,
                                                              );
                                                            },
                                                  child:
                                                      const Text("Smazat tým"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                            label: const Text("Smazat"),
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    if (globals.selectedCompetition!.teams.isEmpty)
                      const Center(
                        child: Text(
                          "Zatím nejsou přidány žádné týmy",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    if (globals.selectedCompetition!.teams.isNotEmpty)
                      for (globals.Team team
                          in globals.selectedCompetition!.teams)
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 80,
                            minWidth: 330,
                          ),
                          child: Card(
                            color: globals.selectedTeam == team
                                ? Colors.red
                                : Colors.white,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (globals.selectedTeam == team) {
                                    globals.selectedTeam = null;
                                  } else {
                                    globals.selectedTeam = team;
                                  }
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 0, 2),
                                        child: Text(
                                            "${team.number} - ID: ${team.id}"),
                                      ),
                                      const SizedBox(width: 100),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Colors.red,
                                          ),
                                        ),
                                        onPressed: () {
                                          globals.selectedTeam = team;
                                          Navigator.pushReplacementNamed(
                                              context, "/team");
                                        },
                                        child: const Text("Zobrazit členy"),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 0, 2),
                                    child: Text(team.organization),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 0, 8),
                                    child: Text(
                                        "Počet členů: ${team.members.length.toString()}"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
