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

  handleTreatmentCreate({
    required String token,
    required Map<String, dynamic> treatment,
  }) async {
    setState(() {
      loading["create"] = true;
    });

    treatment["injuryId"] = globals.selectedInjury!.id;

    print("Creating treatment with data: $treatment");
    var object = await functions.createTreatmentProcedure(
      token: token,
      treatmentProcedure: treatment,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.selectedInjury!.treatmentProcedures = [];
      object = await functions.getTreatmentProcedures(
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

  handleTreatmentEdit({
    required String token,
    required Map<String, dynamic> treatment,
  }) async {
    setState(() {
      loading["edit"] = true;
    });

    print("Editing treatment with data: $treatment");
    var object = await functions.editTreatmentProcedure(
      token: token,
      treatmentProcedure: treatment,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.selectedInjury!.treatmentProcedures = [];
      object = await functions.getTreatmentProcedures(
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
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                    maxLines: 4,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    "${globals.selectedInjury!.situation} - ID: ${globals.selectedInjury!.id}"),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 0, 8),
                                    child: Text(
                                      "Písmeno: ${globals.selectedInjury!.letter}",
                                    ),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
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
                          leading: Icon(
                            Icons.healing,
                            color: Colors.red,
                          ),
                          title: Text(
                            "Léčebné postupy",
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
                                        title: const Text(
                                            "Přidání léčebného postupu"),
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
                                                    initialValue: newTreatment[
                                                                    "order"]
                                                                .toString() ==
                                                            "null"
                                                        ? ""
                                                        : newTreatment["order"]
                                                            .toString(),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      labelStyle: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                      labelText:
                                                          "Pořadí (číslo)",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newTreatment["order"] =
                                                            int.tryParse(value);
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    minLines: 1,
                                                    maxLines: 5,
                                                    cursorColor: Colors.red,
                                                    initialValue: newTreatment[
                                                        "activity"],
                                                    decoration:
                                                        const InputDecoration(
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      labelStyle: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                      labelText: "Činnost",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newTreatment[
                                                            "activity"] = value;
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
                                                : (newTreatment["order"] !=
                                                            null &&
                                                        newTreatment[
                                                                "activity"] !=
                                                            null)
                                                    ? () async {
                                                        await handleTreatmentCreate(
                                                          token: globals
                                                              .user.token!,
                                                          treatment:
                                                              newTreatment,
                                                        );
                                                      }
                                                    : null,
                                            child: const Text(
                                                "Přidat léčebný postup"),
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
                                                  "Úprava léčebného postupu"),
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
                                                          initialValue: editTreatment[
                                                                          "order"]
                                                                      .toString() ==
                                                                  "null"
                                                              ? ""
                                                              : editTreatment[
                                                                      "order"]
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
                                                                "Pořadí (číslo)",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editTreatment[
                                                                      "order"] =
                                                                  int.tryParse(
                                                                      value);
                                                            });
                                                          },
                                                        ),
                                                        TextFormField(
                                                          minLines: 1,
                                                          maxLines: 5,
                                                          cursorColor:
                                                              Colors.red,
                                                          initialValue:
                                                              editTreatment[
                                                                  "activity"],
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
                                                                "Činnost",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editTreatment[
                                                                      "activity"] =
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
                                                                      "order"] !=
                                                                  null &&
                                                              editTreatment[
                                                                      "activity"] !=
                                                                  null)
                                                          ? () async {
                                                              await handleTreatmentEdit(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                treatment:
                                                                    editTreatment,
                                                              );
                                                            }
                                                          : null,
                                                  child: const Text(
                                                      "Upravit léčebného postupu"),
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
                                                  "Smazání léčebného postupu"),
                                              content: loading["delete"] == true
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const [
                                                        CircularProgressIndicator(),
                                                      ],
                                                    )
                                                  : const Text(
                                                      "Opravdu chcete smazat léčebný postup?"),
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
                                                              await handleTreatmentDelete(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                treatmentId:
                                                                    selectedTreatment!
                                                                        .id,
                                                              );
                                                            },
                                                  child: const Text(
                                                      "Smazat léčebný postup"),
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
                                  in globals
                                      .selectedInjury!.treatmentProcedures)
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 80,
                                    minWidth: 330,
                                  ),
                                  child: Card(
                                    color: selectedTreatment == treatment
                                        ? Colors.red
                                        : Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (selectedTreatment == treatment) {
                                            selectedTreatment = null;
                                          } else {
                                            selectedTreatment = treatment;
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
                                            child: Text("ID: ${treatment.id}"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 0, 0),
                                            child: Text(
                                                "Činnost: ${treatment.activity}"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 0, 8),
                                            child: Text(
                                              "Pořadí: ${treatment.order}",
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
