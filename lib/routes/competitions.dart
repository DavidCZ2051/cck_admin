// packages
import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/widgets.dart' as widgets;
import 'package:cck_admin/functions.dart' as functions;

class Competitions extends StatefulWidget {
  const Competitions({super.key});

  @override
  State<Competitions> createState() => _CompetitionsState();
}

class _CompetitionsState extends State<Competitions> {
  int? selectedCompetetion;

  handleTeamDelete({required String token, required int teamId}) async {
    print("Deleting team with id: $teamId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const widgets.WindowsStuff(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 250,
                      ),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Typ"),
                            ),
                            Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Od",
                                  ),
                                ),
                                SizedBox(width: 30),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Do",
                                  ),
                                ),
                                SizedBox(width: 30),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Stav"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    for (globals.Competition competition
                        in globals.competitions)
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 250,
                        ),
                        child: Card(
                          color: selectedCompetetion ==
                                  globals.competitions.indexOf(competition)
                              ? Colors.red
                              : Colors.white,
                          child: InkWell(
                            onTap: () {
                              if (selectedCompetetion ==
                                  globals.competitions.indexOf(competition)) {
                                setState(() {
                                  selectedCompetetion = null;
                                });
                              } else {
                                setState(() {
                                  selectedCompetetion = globals.competitions
                                      .indexWhere((element) =>
                                          element.id == competition.id);
                                });
                              }
                              print(selectedCompetetion);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(competition.type),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        competition.startDateString,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        competition.endDateString,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(competition.state),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
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
                            showGeneralDialog(
                              context: context,
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return AlertDialog(
                                  title: const Text("Přidání soutěže"),
                                  content: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 800,
                                      minHeight: 500,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(
                                            Colors.red[50]),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Zrušit",
                                        style: TextStyle(color: Colors.red),
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
                                      child: const Text("Přidat soutěž"),
                                    ),
                                  ],
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
                          onPressed: selectedCompetetion == null
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
                                              child:
                                                  const Text("Aplikovat změny"),
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
                          onPressed: selectedCompetetion == null
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
                                            content: const Text(
                                                "Opravdu chcete smazat soutěž?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
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
                                                      MaterialStateProperty.all(
                                                    Colors.red,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  await handleTeamDelete(
                                                    token: globals.user
                                                        .token!, // TODO: buttons
                                                    teamId:
                                                        globals // TODO: rework the selected competitions
                                                            .competitions[
                                                                selectedCompetetion! +
                                                                    1]
                                                            .id,
                                                  );
                                                },
                                                child:
                                                    const Text("Smazat soutěž"),
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
                  Card(
                    child: SizedBox(
                      width: 500,
                      height: 400,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Contents"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
