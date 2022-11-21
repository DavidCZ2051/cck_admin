// packages
import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/widgets.dart' as widgets;

class Competitions extends StatefulWidget {
  const Competitions({super.key});

  @override
  State<Competitions> createState() => _CompetitionsState();
}

class _CompetitionsState extends State<Competitions> {
  int? selectedCompetetion;

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
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Row(
                      children: [
                        ElevatedButton(
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
                                          overlayColor:
                                              MaterialStateProperty.all(
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
                                });
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.add),
                              SizedBox(width: 5),
                              Text("Přidat"),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                          ),
                          onPressed: selectedCompetetion == null
                              ? null
                              : () {
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
                          child: Row(
                            children: const [
                              Icon(Icons.edit),
                              SizedBox(width: 5),
                              Text("Upravit"),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                          ),
                          onPressed: selectedCompetetion == null ? null : () {},
                          child: Row(
                            children: const [
                              Icon(Icons.delete_forever),
                              SizedBox(width: 5),
                              Text("Smazat"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Content"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
