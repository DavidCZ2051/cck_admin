// packages
import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/functions.dart' as functions;
import 'package:cck_admin/widgets.dart' as widgets;

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  Map<String, dynamic> newTask = {};
  Map<String, dynamic> editTask = {};
  globals.Task? selectedTask;
  Map<String, bool> loading = {
    "delete": false,
    "create": false,
    "edit": false,
  };

  setstate() {
    setState(() {});
  }

  handleFigurantDelete({
    required String token,
    required int figurantId,
  }) async {
    setState(() {
      loading["delete"] = true;
    });
    setstate();
    print("Deleting figurant with id: $figurantId");
    var object = await functions.deleteFigurant(
      token: token,
      figurantId: figurantId,
    );
    setState(() {
      loading["delete"] = false;
    });
    setstate();
    if (object.functionCode == globals.FunctionCode.success) {
      setState(() {
        globals.selectedInjury!.figurants.removeWhere(
          (figurant) => figurant.id == figurantId,
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
    selectedTask = null;
  }

  handleStationCreate({
    required String token,
    required Map<String, dynamic> station,
  }) async {
    setState(() {
      loading["create"] = true;
    });
    station["type"] = globals.getStationTypeId(type: station["type"]);
    station["tier"] = globals.getStationTierId(tier: station["tier"]);

    print("Creating station with data: $station");
    var object = await functions.createStation(
      token: token,
      station: station,
      competitionId: globals.selectedCompetition!.id,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.selectedCompetition!.stations = [];
      object = await functions.getStations(
        token: token,
      );
      setState(() {
        loading["create"] = false;
      });
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
      showDialog(
          context: context,
          builder: (context) {
            return widgets.ErrorDialog(
              statusCode: object.statusCode!,
            );
          });
    }
  }

  handleFigurantEdit({
    required String token,
    required Map<String, dynamic> figurant,
  }) async {
    setState(() {
      loading["edit"] = true;
    });

    print("Editing figurant with data: $figurant");
    var object = await functions.editFigurant(
      token: token,
      figurant: figurant,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.selectedInjury!.figurants = [];
      object = await functions.getFigurants(
        token: token,
      );
      setState(() {
        loading["edit"] = false;
      });
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
                                        Text(globals.selectedInjury!.situation),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: () {
                                      globals.loadMode = "injuries";
                                      globals.selectedInjury = null;
                                      Navigator.pushReplacementNamed(
                                          context, "/loading");
                                    },
                                    child: const Text("Zpět"),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  globals.selectedInjury!.letter,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.home),
                          title: const Text("Přehled zranění"),
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/injury");
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text("Figuranti"),
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, "/figurants");
                          },
                        ),
                        const ListTile(
                          leading: Icon(Icons.assignment),
                          title: Text("Úlohy"),
                          selected: true,
                        ),
                        ListTile(
                          leading: const Icon(Icons.healing),
                          title: const Text("Léčebné procedury"),
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, "/treatments");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(),
                /* Column(
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
                                        title: const Text("Přidání stanoviště"),
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
                                                    initialValue: newFigurant[
                                                                    "number"]
                                                                .toString() ==
                                                            "null"
                                                        ? ""
                                                        : newFigurant["number"]
                                                            .toString(),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "Číslo",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newFigurant["number"] =
                                                            int.tryParse(value);
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    initialValue:
                                                        newFigurant["title"],
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "Název",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newFigurant["title"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  //station type
                                                  DropdownButton(
                                                    hint: const Text(
                                                        "Typ stanoviště"),
                                                    value: newFigurant["type"],
                                                    items: globals
                                                        .stationTypes.values
                                                        .map((e) =>
                                                            DropdownMenuItem(
                                                              value: e,
                                                              child: Text(e),
                                                            ))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newFigurant["type"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  //station tier
                                                  DropdownButton(
                                                    hint: const Text(
                                                        "Druh stanoviště"),
                                                    value: newFigurant["tier"],
                                                    items: globals
                                                        .stationTiers.values
                                                        .map((e) {
                                                      return DropdownMenuItem(
                                                        value: e,
                                                        child: Text(e),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newFigurant["tier"] =
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
                                                    newFigurant = {};
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
                                                : (newFigurant["title"] !=
                                                            null &&
                                                        newFigurant["tier"] !=
                                                            null &&
                                                        newFigurant["type"] !=
                                                            null &&
                                                        newFigurant["number"] !=
                                                            null)
                                                    ? () async {
                                                        await handleStationCreate(
                                                          token: globals
                                                              .user.token!,
                                                          station: newFigurant,
                                                        );
                                                      }
                                                    : null,
                                            child:
                                                const Text("Přidat stanoviště"),
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
                            onPressed: selectedFigurant == null
                                ? null
                                : () {
                                    editFigurant = selectedFigurant!.map;
                                    editFigurant["tier"] = globals
                                        .stationTiers[editFigurant["tier"]];
                                    editFigurant["type"] = globals
                                        .stationTypes[editFigurant["type"]];
                                    print(editFigurant);
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Úprava stanoviště"),
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
                                                          initialValue: editFigurant[
                                                                          "number"]
                                                                      .toString() ==
                                                                  "null"
                                                              ? ""
                                                              : editFigurant[
                                                                      "number"]
                                                                  .toString(),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: "Číslo",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editFigurant[
                                                                      "number"] =
                                                                  int.tryParse(
                                                                      value);
                                                            });
                                                          },
                                                        ),
                                                        TextFormField(
                                                          initialValue:
                                                              editFigurant[
                                                                  "title"],
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: "Název",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editFigurant[
                                                                      "title"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        //station competition
                                                        DropdownButton(
                                                          hint: const Text(
                                                              "Soutěž"),
                                                          value: editFigurant[
                                                              "competitionId"],
                                                          items: [
                                                            for (globals
                                                                    .Competition competition
                                                                in globals
                                                                    .competitions)
                                                              DropdownMenuItem(
                                                                value:
                                                                    competition
                                                                        .id,
                                                                child: Text(
                                                                    "${competition.type} (${competition.startDateString} - ${competition.endDateString})"),
                                                              ),
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editFigurant[
                                                                      "competitionId"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        //station type
                                                        DropdownButton(
                                                          hint: const Text(
                                                              "Typ stanoviště"),
                                                          value: editFigurant[
                                                              "type"],
                                                          items: [
                                                            for (String value
                                                                in globals
                                                                    .stationTypes
                                                                    .values)
                                                              DropdownMenuItem(
                                                                value: value,
                                                                child:
                                                                    Text(value),
                                                              ),
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editFigurant[
                                                                      "type"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        //station tier
                                                        DropdownButton(
                                                          hint: const Text(
                                                              "Druh stanoviště"),
                                                          value: editFigurant[
                                                              "tier"],
                                                          items: [
                                                            for (String value
                                                                in globals
                                                                    .stationTiers
                                                                    .values)
                                                              DropdownMenuItem(
                                                                value: value,
                                                                child:
                                                                    Text(value),
                                                              ),
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editFigurant[
                                                                      "tier"] =
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
                                                              editFigurant = {};
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
                                                      : (editFigurant[
                                                                      "title"] !=
                                                                  null &&
                                                              editFigurant[
                                                                      "tier"] !=
                                                                  null &&
                                                              editFigurant[
                                                                      "type"] !=
                                                                  null &&
                                                              editFigurant[
                                                                      "number"] !=
                                                                  null)
                                                          ? () async {
                                                              await handleFigurantEdit(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                figurant:
                                                                    editFigurant,
                                                              );
                                                            }
                                                          : null,
                                                  child: const Text(
                                                      "Upravit stanoviště"),
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
                            onPressed: selectedFigurant == null
                                ? null
                                : () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Smazání figuranta"),
                                              content: loading["delete"] == true
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const [
                                                        CircularProgressIndicator(),
                                                      ],
                                                    )
                                                  : const Text(
                                                      "Opravdu chcete smazat figuranta?"),
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
                                                              await handleFigurantDelete(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                figurantId:
                                                                    selectedFigurant!
                                                                        .id,
                                                              );
                                                            },
                                                  child: const Text(
                                                      "Smazat figuranta"),
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
                    if (globals.selectedInjury!.figurants.isEmpty)
                      const Center(
                        child: Text(
                          "Zatím nejsou přidány žádní figuranti.",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    if (globals.selectedCompetition!.stations.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              for (globals.Figurant figurant
                                  in globals.selectedInjury!.figurants)
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 80,
                                    minWidth: 330,
                                  ),
                                  child: Card(
                                    color: selectedFigurant == figurant
                                        ? Colors.red
                                        : Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (selectedFigurant == figurant) {
                                            selectedFigurant = null;
                                          } else {
                                            selectedFigurant = figurant;
                                          }
                                        });
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 0, 0),
                                            child: Text("ID: ${figurant.id}"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 0, 0),
                                            child: Text(
                                                "Makeup: ${figurant.makeup}"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 0, 8),
                                            child: Text(
                                              "Instrukce: ${figurant.instructions}",
                                            ),
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
                  ],
                ), */
              ],
            ),
          ),
        ],
      ),
    );
  }
}
