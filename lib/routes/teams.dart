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
  globals.Team? selectedTeam;
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
    print("Deleting competition with id: $teamId");
    var object = await functions.deleteTeam(
      token: token,
      teamId: selectedTeam!.id,
    );
    setState(() {
      loading["delete"] = false;
    });
    setstate();

    if (object.functionCode == globals.FunctionCode.success) {
      setState(() {
        globals.competitions.removeWhere(
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
    required Map<String, dynamic> competition,
  }) async {
    setState(() {
      loading["create"] = true;
    });
    competition["startDate"] = functions.formatDateTime(
      dateTime: competition["startDate"],
    );
    competition["endDate"] = functions.formatDateTime(
      dateTime: competition["endDate"],
    );
    competition["type"] = globals.getCompetitionTypeId(
      type: competition["type"],
    );
    print("Creating competition with data: $competition");
    var object = await functions.createCompetition(
      token: token,
      competition: competition,
    );
    setState(() {
      loading["create"] = false;
    });

    if (object.functionCode == globals.FunctionCode.success) {
      setState(() {});
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
                          leading: const Icon(Icons.people),
                          title: const Text("Týmy"),
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
                                                children: [],
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
                                            onPressed: () {},
                                            /* loading["create"] == true
                                                ? null
                                                : (true) // here should be some validation
                                                    ? null
                                                    : () async {
                                                        await handleTeamCreate(
                                                          token: globals
                                                              .user.token!,
                                                          team: newTeam,
                                                        );
                                                      }, */
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
                            onPressed: selectedTeam == null
                                ? null
                                : () {
                                    print(globals.competitions);
                                    showGeneralDialog(
                                        context: context,
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return AlertDialog(
                                            title: const Text("Úprava soutěže"),
                                            content: Column(
                                              children: [
                                                Row(
                                                  children: const [
                                                    Text("Typ: "),
                                                    Text("Předkolo"),
                                                  ],
                                                )
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                style: ButtonStyle(
                                                  overlayColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red[50]),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "Zrušit úpravu",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                    "Aplikovat změny"),
                                              ),
                                            ],
                                          );
                                        });
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
                            onPressed: selectedTeam == null
                                ? null
                                : () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title:
                                                  const Text("Smazání soutěže"),
                                              content: loading["delete"] == true
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const [
                                                        CircularProgressIndicator(),
                                                      ],
                                                    )
                                                  : const Text(
                                                      "Opravdu chcete smazat soutěž?"),
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
                                                                teamId:
                                                                    selectedTeam!
                                                                        .id,
                                                              );
                                                            },
                                                  child: const Text(
                                                      "Smazat soutěž"),
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
                            color: selectedTeam == team
                                ? Colors.red
                                : Colors.white,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (selectedTeam == team) {
                                    selectedTeam = null;
                                  } else {
                                    selectedTeam = team;
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
                                            8, 8, 0, 0),
                                        child: Text(
                                            "${team.number} - ID: ${team.id}"),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 4, 0, 8),
                                    child: Text(team.organization),
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
