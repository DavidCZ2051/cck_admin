// packages
import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/functions.dart' as functions;
import 'package:cck_admin/widgets.dart' as widgets;

class Treatments extends StatefulWidget {
  const Treatments({super.key});

  @override
  State<Treatments> createState() => _TreatmentsState();
}

class _TreatmentsState extends State<Treatments> {
  Map<String, dynamic> newTreatment = {};
  Map<String, dynamic> editTreatment = {};
  globals.TreatmentProcedure? selectedTreatment;
  Map<String, bool> loading = {
    "delete": false,
    "create": false,
    "edit": false,
  };

  setstate() {
    setState(() {});
  }

  handleTreatmentDelete({
    required String token,
    required int treatmentId,
  }) async {
    setState(() {
      loading["delete"] = true;
    });
    setstate();
    print("Deleting treatment with id: $treatmentId");
    var object = await functions.deleteTreatmentProcedure(
      token: token,
      treatmentProdecureId: treatmentId,
    );
    setState(() {
      loading["delete"] = false;
    });
    setstate();
    if (object.functionCode == globals.FunctionCode.success) {
      setState(() {
        globals.selectedInjury!.treatmentProcedures.removeWhere(
          (procedure) => procedure.id == treatmentId,
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
    selectedTreatment = null;
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
    var object = await functions.editTreatmentProcedure(
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
                        ListTile(
                          leading: const Icon(Icons.assignment),
                          title: const Text("Úlohy"),
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/tasks");
                          },
                        ),
                        const ListTile(
                          leading: Icon(Icons.healing),
                          title: Text("Léčebné procedury"),
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
                                                    initialValue: newTreatment[
                                                                    "number"]
                                                                .toString() ==
                                                            "null"
                                                        ? ""
                                                        : newTreatment["number"]
                                                            .toString(),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "Číslo",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newTreatment["number"] =
                                                            int.tryParse(value);
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    initialValue:
                                                        newTreatment["title"],
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "Název",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newTreatment["title"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  //station type
                                                  DropdownButton(
                                                    hint: const Text(
                                                        "Typ stanoviště"),
                                                    value: newTreatment["type"],
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
                                                        newTreatment["type"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  //station tier
                                                  DropdownButton(
                                                    hint: const Text(
                                                        "Druh stanoviště"),
                                                    value: newTreatment["tier"],
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
                                                        newTreatment["tier"] =
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
                                                    newTreatment = {};
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
                                                : (newTreatment["title"] !=
                                                            null &&
                                                        newTreatment["tier"] !=
                                                            null &&
                                                        newTreatment["type"] !=
                                                            null &&
                                                        newTreatment[
                                                                "number"] !=
                                                            null)
                                                    ? () async {
                                                        await handleStationCreate(
                                                          token: globals
                                                              .user.token!,
                                                          station: newTreatment,
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
                            onPressed: selectedTreatment == null
                                ? null
                                : () {
                                    editTreatment = selectedTreatment!.map;
                                    print(editTreatment);
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Úprava léčebné procedury"),
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
                                                          initialValue: editTreatment[
                                                                          "number"]
                                                                      .toString() ==
                                                                  "null"
                                                              ? ""
                                                              : editTreatment[
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
                                                              editTreatment[
                                                                      "number"] =
                                                                  int.tryParse(
                                                                      value);
                                                            });
                                                          },
                                                        ),
                                                        TextFormField(
                                                          initialValue:
                                                              editTreatment[
                                                                  "title"],
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: "Název",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editTreatment[
                                                                      "title"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        //station competition
                                                        DropdownButton(
                                                          hint: const Text(
                                                              "Soutěž"),
                                                          value: editTreatment[
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
                                                              editTreatment[
                                                                      "competitionId"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        //station type
                                                        DropdownButton(
                                                          hint: const Text(
                                                              "Typ stanoviště"),
                                                          value: editTreatment[
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
                                                              editTreatment[
                                                                      "type"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        //station tier
                                                        DropdownButton(
                                                          hint: const Text(
                                                              "Druh stanoviště"),
                                                          value: editTreatment[
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
                                                              editTreatment[
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
                                                  onPressed: loading["edit"] ==
                                                          true
                                                      ? null
                                                      : () {
                                                          editTreatment = {};
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
                                                      : (editTreatment[
                                                                      "title"] !=
                                                                  null &&
                                                              editTreatment[
                                                                      "tier"] !=
                                                                  null &&
                                                              editTreatment[
                                                                      "type"] !=
                                                                  null &&
                                                              editTreatment[
                                                                      "number"] !=
                                                                  null)
                                                          ? () async {
                                                              await handleFigurantEdit(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                figurant:
                                                                    editTreatment,
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
                            onPressed: selectedTreatment == null
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
                                                                    selectedTreatment!
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
                    if (globals.selectedInjury!.treatmentProcedures.isEmpty)
                      const Center(
                        child: Text(
                          "Zatím nejsou přidány žádné léčebné procedury.",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    if (globals.selectedInjury!.treatmentProcedures.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              for (globals.TreatmentProcedure treatment
                                  in globals.selectedInjury!.figurants)
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 80,
                                    minWidth: 330,
                                  ),
                                  child: Card(
                                    color: selectedTreatment == figurant
                                        ? Colors.red
                                        : Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (selectedTreatment == figurant) {
                                            selectedTreatment = null;
                                          } else {
                                            selectedTreatment = figurant;
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
