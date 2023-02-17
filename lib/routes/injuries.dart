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
      injuryId: globals.selectedInjury!.id,
    );
    setState(() {
      loading["delete"] = false;
    });
    setstate();
    globals.selectedInjury = null;

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

    injury["stationId"] = globals.selectedStation!.id;
    injury["refereeId"] = 2; //TODO: repair

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
      injuryId: globals.selectedInjury!.id,
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
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
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
                              color: globals.selectedInjury == injury
                                  ? Colors.red
                                  : Colors.white,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (globals.selectedInjury == injury) {
                                      globals.selectedInjury = null;
                                    } else {
                                      globals.selectedInjury = injury;
                                    }
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                      child: Text(
                                          maxLines: 4,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          "${injury.situation} - ID: ${injury.id}"),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                      child: Text("Písmeno: ${injury.letter}"),
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
                                                    minLines: 1,
                                                    maxLines: 5,
                                                    cursorColor: Colors.red,
                                                    initialValue:
                                                        newInjury["situation"],
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
                                                      labelText: "Situace",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newInjury["situation"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    minLines: 1,
                                                    maxLines: 5,
                                                    cursorColor: Colors.red,
                                                    initialValue:
                                                        newInjury["diagnosis"],
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
                                                      labelText: "Diagnóza",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newInjury["diagnosis"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  DropdownButton(
                                                    hint: const Text("Písmeno"),
                                                    value: newInjury["letter"],
                                                    items: const [
                                                      DropdownMenuItem(
                                                        value: "A",
                                                        child: Text("A"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: "B",
                                                        child: Text("B"),
                                                      ),
                                                    ],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newInjury["letter"] =
                                                            value.toString();
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    minLines: 1,
                                                    maxLines: 5,
                                                    cursorColor: Colors.red,
                                                    initialValue: newInjury[
                                                        "necessaryEquipment"],
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
                                                          "Nezbytné vybavení",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newInjury[
                                                                "necessaryEquipment"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    minLines: 1,
                                                    maxLines: 5,
                                                    cursorColor: Colors.red,
                                                    initialValue:
                                                        newInjury["info"],
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
                                                          "Informace (nepovinné)",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newInjury["info"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    cursorColor: Colors.red,
                                                    initialValue: newInjury[
                                                                    "maximalPoints"]
                                                                .toString() ==
                                                            "null"
                                                        ? ""
                                                        : newInjury[
                                                                "maximalPoints"]
                                                            .toString(),
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
                                                          "Maximální počet bodů (číslo)",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newInjury[
                                                                "maximalPoints"] =
                                                            int.tryParse(value);
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
                                                : (newInjury["letter"] !=
                                                            null &&
                                                        newInjury[
                                                                "situation"] !=
                                                            null &&
                                                        newInjury[
                                                                "diagnosis"] !=
                                                            null &&
                                                        newInjury[
                                                                "necessaryEquipment"] !=
                                                            null &&
                                                        newInjury[
                                                                "maximalPoints"] !=
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
                            onPressed: globals.selectedInjury == null
                                ? null
                                : () {
                                    editInjury = globals.selectedInjury!.map;
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
                                                          cursorColor:
                                                              Colors.red,
                                                          minLines: 1,
                                                          maxLines: 5,
                                                          initialValue:
                                                              editInjury[
                                                                  "situation"],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelStyle:
                                                                TextStyle(
                                                              color: Colors.red,
                                                            ),
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            labelText:
                                                                "Situace",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editInjury[
                                                                      "situation"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        TextFormField(
                                                          cursorColor:
                                                              Colors.red,
                                                          minLines: 1,
                                                          maxLines: 5,
                                                          initialValue:
                                                              editInjury[
                                                                  "diagnosis"],
                                                          decoration:
                                                              const InputDecoration(
                                                            labelStyle:
                                                                TextStyle(
                                                              color: Colors.red,
                                                            ),
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            labelText:
                                                                "Diagnóza",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editInjury[
                                                                      "diagnosis"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        DropdownButton(
                                                          hint: const Text(
                                                              "Písmeno"),
                                                          value: editInjury[
                                                              "letter"],
                                                          items: const [
                                                            DropdownMenuItem(
                                                              value: "A",
                                                              child: Text("A"),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: "B",
                                                              child: Text("B"),
                                                            ),
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editInjury[
                                                                      "letter"] =
                                                                  value
                                                                      .toString();
                                                            });
                                                          },
                                                        ),
                                                        TextFormField(
                                                          cursorColor:
                                                              Colors.red,
                                                          minLines: 1,
                                                          maxLines: 5,
                                                          initialValue: editInjury[
                                                              "necessaryEquipment"],
                                                          decoration:
                                                              const InputDecoration(
                                                            labelStyle:
                                                                TextStyle(
                                                              color: Colors.red,
                                                            ),
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            labelText:
                                                                "Nezbytné vybavení",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editInjury[
                                                                      "necessaryEquipment"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        TextFormField(
                                                          cursorColor:
                                                              Colors.red,
                                                          minLines: 1,
                                                          maxLines: 5,
                                                          initialValue:
                                                              editInjury[
                                                                  "info"],
                                                          decoration:
                                                              const InputDecoration(
                                                            labelStyle:
                                                                TextStyle(
                                                              color: Colors.red,
                                                            ),
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            labelText:
                                                                "Informace (nepovinné)",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editInjury[
                                                                      "info"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        TextFormField(
                                                          cursorColor:
                                                              Colors.red,
                                                          initialValue: editInjury[
                                                                          "maximalPoints"]
                                                                      .toString() ==
                                                                  "null"
                                                              ? ""
                                                              : editInjury[
                                                                      "maximalPoints"]
                                                                  .toString(),
                                                          decoration:
                                                              const InputDecoration(
                                                            labelStyle:
                                                                TextStyle(
                                                              color: Colors.red,
                                                            ),
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            labelText:
                                                                "Maximální počet bodů (číslo)",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editInjury[
                                                                      "maximalPoints"] =
                                                                  int.tryParse(
                                                                      value);
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
                                                      : (editInjury[
                                                                      "letter"] !=
                                                                  null &&
                                                              editInjury[
                                                                      "situation"] !=
                                                                  null &&
                                                              editInjury[
                                                                      "diagnosis"] !=
                                                                  null &&
                                                              editInjury[
                                                                      "necessaryEquipment"] !=
                                                                  null &&
                                                              editInjury[
                                                                      "maximalPoints"] !=
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
                            onPressed: globals.selectedInjury == null
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
                                                                injuryId: globals
                                                                    .selectedInjury!
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
                    if (globals.selectedInjury != null)
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                  child: Text(
                                      "Diagnóza: ${globals.selectedInjury!.diagnosis}"),
                                ),
                                const SizedBox(width: 50),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    globals.loadMode = "injury";
                                    Navigator.pushReplacementNamed(
                                        context, "/loading");
                                  },
                                  child: const Text("Otevřít"),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text("ID: ${globals.selectedInjury!.id}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(
                                  "Informace: ${globals.selectedInjury!.info}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(
                                  "Písmeno: ${globals.selectedInjury!.letter}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(
                                  "Maximální počet bodů: ${globals.selectedInjury!.maximalPoints}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(
                                  "Nezbytné vybavení: ${globals.selectedInjury!.necessaryEquipment}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(
                                  "ID rozhodčího: ${globals.selectedInjury!.refereeId}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                              child: Text(
                                  "Situace: ${globals.selectedInjury!.situation}"),
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
