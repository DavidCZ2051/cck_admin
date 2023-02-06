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

  handleTaskDelete({
    required String token,
    required int injuryTaskId,
  }) async {
    setState(() {
      loading["delete"] = true;
    });
    setstate();
    print("Deleting task with id: $injuryTaskId");
    var object = await functions.deleteInjuryTask(
      token: token,
      injuryTaskId: injuryTaskId,
    );
    setState(() {
      loading["delete"] = false;
    });
    setstate();
    if (object.functionCode == globals.FunctionCode.success) {
      setState(() {
        globals.selectedInjury!.tasks.removeWhere(
          (task) => task.id == injuryTaskId,
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

  handleTaskCreate({
    required String token,
    required Map<String, dynamic> task,
  }) async {
    setState(() {
      loading["create"] = true;
    });

    task["injuryId"] = globals.selectedInjury!.id;

    print("Creating task with data: $task");
    var object = await functions.createInjuryTask(
      token: token,
      task: task,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.selectedInjury!.tasks = [];
      object = await functions.getInjuryTasks(
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

  handleTaskEdit({
    required String token,
    required Map<String, dynamic> task,
  }) async {
    setState(() {
      loading["edit"] = true;
    });

    print("Editing task with data: $task");
    var object = await functions.editInjuryTask(
      token: token,
      injuryTask: task,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.selectedInjury!.tasks = [];
      object = await functions.getInjuryTasks(
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
                                        title: const Text("Přidání úlohy"),
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
                                                    initialValue: newTask[
                                                                    "maximalMinusPoints"]
                                                                .toString() ==
                                                            "null"
                                                        ? ""
                                                        : newTask[
                                                                "maximalMinusPoints"]
                                                            .toString(),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          "Maximální počet mínusových bodů",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newTask["maximalMinusPoints"] =
                                                            int.tryParse(value);
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    initialValue:
                                                        newTask["title"],
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "Název",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newTask["title"] =
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
                                                    newTask = {};
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
                                                : (newTask["title"] != null &&
                                                        newTask["maximalMinusPoints"] !=
                                                            null)
                                                    ? () async {
                                                        await handleTaskCreate(
                                                          token: globals
                                                              .user.token!,
                                                          task: newTask,
                                                        );
                                                      }
                                                    : null,
                                            child: const Text("Přidat úlohu"),
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
                            onPressed: selectedTask == null
                                ? null
                                : () {
                                    editTask = selectedTask!.map;
                                    print(editTask);
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title: const Text("Úprava úlohy"),
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
                                                          initialValue: editTask[
                                                                          "maximalMinusPoints"]
                                                                      .toString() ==
                                                                  "null"
                                                              ? ""
                                                              : editTask[
                                                                      "maximalMinusPoints"]
                                                                  .toString(),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                "Maximální počet mínusových bodů",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editTask[
                                                                      "maximalMinusPoints"] =
                                                                  int.tryParse(
                                                                      value);
                                                            });
                                                          },
                                                        ),
                                                        TextFormField(
                                                          initialValue:
                                                              editTask["title"],
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: "Název",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editTask[
                                                                      "title"] =
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
                                                              editTask = {};
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
                                                      : (editTask["title"] !=
                                                                  null &&
                                                              editTask[
                                                                      "maximalMinusPoints"] !=
                                                                  null)
                                                          ? () async {
                                                              await handleTaskEdit(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                task: editTask,
                                                              );
                                                            }
                                                          : null,
                                                  child: const Text(
                                                      "Upravit úlohy"),
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
                            onPressed: selectedTask == null
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
                                                  const Text("Smazání úlohy"),
                                              content: loading["delete"] == true
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const [
                                                        CircularProgressIndicator(),
                                                      ],
                                                    )
                                                  : const Text(
                                                      "Opravdu chcete smazat úlohu?"),
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
                                                              await handleTaskDelete(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                injuryTaskId:
                                                                    selectedTask!
                                                                        .id,
                                                              );
                                                            },
                                                  child: const Text(
                                                      "Smazat úlohu"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                            label: const Text("Smazat"),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    if (globals.selectedInjury!.tasks.isEmpty)
                      const Center(
                        child: Text(
                          "Zatím nejsou přidány žádné úlohy.",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    if (globals.selectedInjury!.tasks.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              for (globals.Task task
                                  in globals.selectedInjury!.tasks)
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 80,
                                    minWidth: 330,
                                  ),
                                  child: Card(
                                    color: selectedTask == task
                                        ? Colors.red
                                        : Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (selectedTask == task) {
                                            selectedTask = null;
                                          } else {
                                            selectedTask = task;
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
                                            child: Text("ID: ${task.id}"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 0, 0),
                                            child: Text("Název: ${task.title}"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 0, 8),
                                            child: Text(
                                              "Maximální počet mínusových bodů: ${task.maximalMinusPoints}",
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
