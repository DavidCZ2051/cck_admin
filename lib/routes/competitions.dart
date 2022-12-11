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
  globals.Competition? selectedCompetition;
  Map<String, dynamic> newCompetition = {};
  Map<String, bool> loading = {
    "delete": false,
    "create": false,
    "edit": false,
  };

  setstate() {
    setState(() {});
  }

  handleCompetitionDelete({
    required String token,
    required int competitionId,
  }) async {
    setState(() {
      loading["delete"] = true;
    });
    setstate();
    print("Deleting competition with id: $competitionId");
    var object = await functions.deleteCompetition(
      token: token,
      competitionId: competitionId,
    );
    setState(() {
      loading["delete"] = false;
    });
    setstate();

    if (object.functionCode == globals.FunctionCode.success) {
      setState(() {
        globals.competitions.removeWhere(
          (competition) => competition.id == competitionId,
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

  handleCompetitionCreate({
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
                            color: selectedCompetition == competition
                                ? Colors.red
                                : Colors.white,
                            child: InkWell(
                              onTap: () {
                                if (selectedCompetition == competition) {
                                  setState(() {
                                    selectedCompetition = null;
                                  });
                                } else {
                                  setState(() {
                                    selectedCompetition = competition;
                                  });
                                }
                                print(selectedCompetition == null
                                    ? "No competition selected"
                                    : "Selected competition with id: ${selectedCompetition!.id}");
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(competition.type),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          selectedCompetition = competition;
                                          globals.selectedCompetition =
                                              selectedCompetition;
                                          globals.loadMode = "competition";
                                          Navigator.pushReplacementNamed(
                                              context, "/loading");
                                        },
                                        child: const Text("Otevřít"),
                                      ),
                                    ],
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
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text("Přidání soutěže"),
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      // competition type
                                                      children: [
                                                        const Text(
                                                          "Typ soutěže: ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        DropdownButton(
                                                          value: newCompetition[
                                                              "type"],
                                                          items: [
                                                            for (String type
                                                                in globals
                                                                    .competitionTypes
                                                                    .values)
                                                              DropdownMenuItem(
                                                                value: type,
                                                                child:
                                                                    Text(type),
                                                              ),
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              newCompetition[
                                                                      "type"] =
                                                                  value;
                                                            });
                                                            setstate();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextField(
                                                      // competition description
                                                      onChanged: (value) {
                                                        setState(() {
                                                          newCompetition[
                                                                  "description"] =
                                                              value;
                                                        });
                                                        setstate();
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            "Popis soutěže",
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      // competition start date
                                                      children: [
                                                        const Text(
                                                          "Datum začátku: ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            DateTime? date =
                                                                await showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              firstDate:
                                                                  DateTime
                                                                      .now(),
                                                              lastDate:
                                                                  DateTime(
                                                                      2100),
                                                            );
                                                            if (date != null) {
                                                              setState(() {
                                                                newCompetition[
                                                                        "startDate"] =
                                                                    date;
                                                              });
                                                              setstate();
                                                              print(
                                                                  "Selected date: ${newCompetition["startDate"]}");
                                                            }
                                                          },
                                                          child: Text(
                                                            newCompetition[
                                                                        "startDate"] ==
                                                                    null
                                                                ? "Vyberte datum"
                                                                : functions.formatDateTime(
                                                                    dateTime:
                                                                        newCompetition[
                                                                            "startDate"]),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      // competition end date
                                                      children: [
                                                        const Text(
                                                          "Datum konce: ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            DateTime? date =
                                                                await showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              firstDate:
                                                                  DateTime
                                                                      .now(),
                                                              lastDate:
                                                                  DateTime(
                                                                      2100),
                                                            );
                                                            if (date != null) {
                                                              setState(() {
                                                                newCompetition[
                                                                        "endDate"] =
                                                                    date;
                                                              });
                                                              setstate();
                                                              print(
                                                                  "Selected date: ${newCompetition["endDate"]}");
                                                            }
                                                          },
                                                          child: Text(
                                                            newCompetition[
                                                                        "endDate"] ==
                                                                    null
                                                                ? "Vyberte datum"
                                                                : functions.formatDateTime(
                                                                    dateTime:
                                                                        newCompetition[
                                                                            "endDate"]),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                                                : (newCompetition["type"] ==
                                                            null ||
                                                        newCompetition[
                                                                "startDate"] ==
                                                            null ||
                                                        newCompetition[
                                                                "endDate"] ==
                                                            null)
                                                    ? null
                                                    : () async {
                                                        await handleCompetitionCreate(
                                                          token: globals
                                                              .user.token!,
                                                          competition:
                                                              newCompetition,
                                                        );
                                                      },
                                            child: const Text("Přidat soutěž"),
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
                            onPressed: selectedCompetition == null
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
                            onPressed: selectedCompetition == null
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
                                                              await handleCompetitionDelete(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                competitionId:
                                                                    selectedCompetition!
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
