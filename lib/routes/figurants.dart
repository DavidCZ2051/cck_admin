// packages
import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/functions.dart' as functions;
import 'package:cck_admin/widgets.dart' as widgets;

class Figurants extends StatefulWidget {
  const Figurants({super.key});

  @override
  State<Figurants> createState() => _FigurantsState();
}

class _FigurantsState extends State<Figurants> {
  Map<String, dynamic> newFigurant = {};
  Map<String, dynamic> editFigurant = {};
  globals.Figurant? selectedFigurant;
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
    selectedFigurant = null;
  }

  handleFigurantCreate({
    required String token,
    required Map<String, dynamic> figurant,
  }) async {
    setState(() {
      loading["create"] = true;
    });

    figurant["injuryId"] = globals.selectedInjury!.id;

    print("Creating figurant with data: $figurant");
    var object = await functions.createFigurant(
      token: token,
      figurant: figurant,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.selectedInjury!.figurants = [];
      object = await functions.getFigurants(
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
                                    child: Text(
                                        "${globals.selectedInjury!.situation} - ID: ${globals.selectedInjury!.id}"),
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
                        const ListTile(
                          leading: Icon(Icons.person),
                          title: Text("Figuranti"),
                          selected: true,
                        ),
                        ListTile(
                          leading: const Icon(Icons.assignment),
                          title: const Text("Úlohy"),
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/tasks");
                          },
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
                                        title: const Text("Přidání figuranta"),
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
                                                        "instructions"],
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "Instrukce",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newFigurant[
                                                                "instructions"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    initialValue:
                                                        newFigurant["makeup"],
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "Makeup",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newFigurant["makeup"] =
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
                                                : (newFigurant["instructions"] !=
                                                            null &&
                                                        newFigurant["makeup"] !=
                                                            null)
                                                    ? () async {
                                                        await handleFigurantCreate(
                                                            token: globals
                                                                .user.token!,
                                                            figurant:
                                                                newFigurant);
                                                      }
                                                    : null,
                                            child:
                                                const Text("Přidat figuranta"),
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
                                    print(editFigurant);
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Úprava figuranta"),
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
                                                          initialValue:
                                                              editFigurant[
                                                                  "instructions"],
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                "Instrukce",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editFigurant[
                                                                      "instructions"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        TextFormField(
                                                          initialValue:
                                                              editFigurant[
                                                                  "makeup"],
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: "Makeup",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editFigurant[
                                                                      "makeup"] =
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
                                                      : (editFigurant["instructions"] !=
                                                                  null &&
                                                              editFigurant[
                                                                      "makeup"] !=
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
                                                      "Upravit figuranta"),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
