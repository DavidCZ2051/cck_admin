// packages
import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/functions.dart' as functions;
import 'package:cck_admin/widgets.dart' as widgets;

class Injuries extends StatefulWidget {
  const Injuries({super.key});

  @override
  State<Injuries> createState() => _InjuriesState();
}

class _InjuriesState extends State<Injuries> {
  Map<String, dynamic> newInjury = {};
  Map<String, dynamic> editInjury = {};
  globals.Injury? selectedInjury;
  Map<String, bool> loading = {
    "delete": false,
    "create": false,
    "edit": false,
  };

  setstate() {
    setState(() {});
  }

  handleInjuryDelete({
    required String token,
    required int injuryId,
  }) async {
    setState(() {
      loading["delete"] = true;
    });
    setstate();
    print("Deleting injury with id: $injuryId");
    var object = await functions.deleteInjury(
      token: token,
      injuryId: selectedInjury!.id,
    );
    setState(() {
      loading["delete"] = false;
    });
    setstate();
    selectedInjury = null;

    if (object.functionCode == globals.FunctionCode.success) {
      setState(() {
        globals.selectedStation!.injuries.removeWhere(
          (injury) => injury.id == injuryId,
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

  handleInjuryCreate({
    required String token,
    required Map<String, dynamic> injury,
  }) async {
    setState(() {
      loading["create"] = true;
    });

    print("Creating injury with data: $injury");
    var object = await functions.createInjury(
      token: token,
      injury: injury,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.selectedStation!.injuries = [];
      object = await functions.getInjuries(
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

  handleInjuryEdit({
    required String token,
    required Map<String, dynamic> injury,
  }) async {
    setState(() {
      loading["edit"] = true;
    });

    print("Editing injury with data: $injury");
    var object = await functions.editInjury(
      token: token,
      injury: injury,
      injuryId: selectedInjury!.id,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.selectedStation!.injuries = [];
      object = await functions.getInjuries(
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
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                    child: Text(
                                        "${globals.selectedStation!.title} - ID: ${globals.selectedStation!.id}"),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: () {
                                      globals.selectedStation!.injuries = [];
                                      Navigator.pushReplacementNamed(
                                          context, "/stations");
                                    },
                                    child: const Text("Zpět"),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                child: Text(
                                  "Číslo: ${globals.selectedStation!.number}",
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                child: Text(
                                  "Typ: ${globals.stationTypes[globals.selectedStation!.type]}",
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        for (globals.Injury injury
                            in globals.selectedStation!.injuries)
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: 80,
                              minWidth: 330,
                            ),
                            child: Card(
                              color: selectedInjury == injury
                                  ? Colors.red
                                  : Colors.white,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (selectedInjury == injury) {
                                      selectedInjury = null;
                                    } else {
                                      selectedInjury = injury;
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
                                              "${injury.situation} - ID: ${injury.id}"),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                      child: Text("Číslo: ${injury.letter}"),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                      child: Text(
                                        "Typ: ${globals.stationTypes[injury.diagnosis]}",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                                        title: const Text("Přidání zranění"),
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
                                                    initialValue: newInjury[
                                                                    "number"]
                                                                .toString() ==
                                                            "null"
                                                        ? ""
                                                        : newInjury["number"]
                                                            .toString(),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "Číslo",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newInjury["number"] =
                                                            int.tryParse(value);
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    initialValue:
                                                        newInjury["title"],
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "Název",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newInjury["title"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  DropdownButton(
                                                    hint: const Text(
                                                        "Typ zranění"),
                                                    value: newInjury["type"],
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
                                                        newInjury["type"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  DropdownButton(
                                                    hint: const Text(
                                                        "Druh zranění"),
                                                    value: newInjury["tier"],
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
                                                        newInjury["tier"] =
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
                                                    newInjury = {};
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
                                                : (newInjury["title"] != null &&
                                                        newInjury["tier"] !=
                                                            null &&
                                                        newInjury["type"] !=
                                                            null &&
                                                        newInjury["number"] !=
                                                            null)
                                                    ? () async {
                                                        await handleInjuryCreate(
                                                          token: globals
                                                              .user.token!,
                                                          injury: newInjury,
                                                        );
                                                      }
                                                    : null,
                                            child: const Text("Přidat zranění"),
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
                            onPressed: selectedInjury == null
                                ? null
                                : () {
                                    editInjury = selectedInjury!.map;
                                    editInjury["tier"] = globals
                                        .stationTiers[editInjury["tier"]];
                                    editInjury["type"] = globals
                                        .stationTypes[editInjury["type"]];
                                    print(editInjury);
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title:
                                                  const Text("Úprava zranění"),
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
                                                          initialValue: editInjury[
                                                                          "number"]
                                                                      .toString() ==
                                                                  "null"
                                                              ? ""
                                                              : editInjury[
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
                                                              editInjury[
                                                                      "number"] =
                                                                  int.tryParse(
                                                                      value);
                                                            });
                                                          },
                                                        ),
                                                        TextFormField(
                                                          initialValue:
                                                              editInjury[
                                                                  "title"],
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: "Název",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editInjury[
                                                                      "title"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        DropdownButton(
                                                          hint: const Text(
                                                              "Soutěž"),
                                                          value: editInjury[
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
                                                              editInjury[
                                                                      "competitionId"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        DropdownButton(
                                                          hint: const Text(
                                                              "Typ zranění"),
                                                          value: editInjury[
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
                                                              editInjury[
                                                                      "type"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        DropdownButton(
                                                          hint: const Text(
                                                              "Druh zranění"),
                                                          value: editInjury[
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
                                                              editInjury[
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
                                                              editInjury = {};
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
                                                      : (editInjury["title"] !=
                                                                  null &&
                                                              editInjury[
                                                                      "tier"] !=
                                                                  null &&
                                                              editInjury[
                                                                      "type"] !=
                                                                  null &&
                                                              editInjury[
                                                                      "number"] !=
                                                                  null)
                                                          ? () async {
                                                              await handleInjuryEdit(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                injury:
                                                                    editInjury,
                                                              );
                                                            }
                                                          : null,
                                                  child: const Text(
                                                      "Upravit zranění"),
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
                            onPressed: selectedInjury == null
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
                                                  const Text("Smazání zranění"),
                                              content: loading["delete"] == true
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const [
                                                        CircularProgressIndicator(),
                                                      ],
                                                    )
                                                  : const Text(
                                                      "Opravdu chcete smazat zranění?"),
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
                                                              await handleInjuryDelete(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                injuryId:
                                                                    selectedInjury!
                                                                        .id,
                                                              );
                                                            },
                                                  child: const Text(
                                                      "Smazat zranění"),
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
                    if (selectedInjury != null)
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(
                                  "Diagnóza: ${selectedInjury!.diagnosis}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text("ID: ${selectedInjury!.id}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text("Informace: ${selectedInjury!.info}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text("Písmeno: ${selectedInjury!.letter}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(
                                  "Maximální počet bodů: ${selectedInjury!.maximalPoints}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(
                                  "Nezbytné vybavení: ${selectedInjury!.necessaryEquipment}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(
                                  "ID rozhodčího: ${selectedInjury!.refereeId}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                              child:
                                  Text("Situace: ${selectedInjury!.situation}"),
                            ),
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
