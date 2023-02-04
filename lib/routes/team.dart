// packages
import 'dart:ffi';

import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/functions.dart' as functions;
import 'package:cck_admin/widgets.dart' as widgets;

class Team extends StatefulWidget {
  const Team({super.key});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  Map<String, dynamic> newTeamMember = {};
  Map<String, dynamic> editTeamMember = {};
  globals.TeamMember? selectedTeamMember;
  Map<String, bool> loading = {
    "delete": false,
    "create": false,
    "edit": false,
  };

  setstate() {
    setState(() {});
  }

  handleTeamMemberDelete({
    required String token,
    required int teamMemberId,
  }) async {
    setState(() {
      loading["delete"] = true;
    });
    setstate();
    print("Deleting team member with id: $teamMemberId");
    var object = await functions.deleteTeamMember(
      token: token,
      teamMemberId: selectedTeamMember!.id,
    );
    setState(() {
      loading["delete"] = false;
    });
    setstate();
    selectedTeamMember = null;

    if (object.functionCode == globals.FunctionCode.success) {
      setState(() {
        globals.selectedTeam!.members.removeWhere(
          (teamMember) => teamMember.id == teamMemberId,
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

  handleTeamMemberCreate({
    required String token,
    required Map<String, dynamic> teamMember,
  }) async {
    setState(() {
      loading["create"] = true;
    });

    print("Creating team member with data: $teamMember");
    var object = await functions.createTeamMember(
      token: token,
      teamMember: teamMember,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.selectedTeam!.members = [];
      object = await functions.getTeamMembers(
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

  handleTeamMemberEdit({
    required String token,
    required Map<String, dynamic> teamMember,
  }) async {
    setState(() {
      loading["edit"] = true;
    });

    print("Editing team member with data: $teamMember");
    var object = await functions.editTeamMember(
      token: token,
      teamMember: teamMember,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.selectedTeam!.members = [];
      object = await functions.getTeamMembers(
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
                                        "${globals.selectedTeam!.organization} - ID: ${globals.selectedTeam!.id}"),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, "/teams");
                                    },
                                    child: const Text("Zpět"),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                child: Text(
                                  "Číslo: ${globals.selectedTeam!.number}",
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        for (globals.TeamMember teamMember
                            in globals.selectedTeam!.members)
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: 60,
                              minWidth: 330,
                            ),
                            child: Card(
                              color: selectedTeamMember == teamMember
                                  ? Colors.red
                                  : Colors.white,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (selectedTeamMember == teamMember) {
                                      selectedTeamMember = null;
                                    } else {
                                      selectedTeamMember = teamMember;
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
                                              "${teamMember.firstName} ${teamMember.lastName}- ID: ${teamMember.id}"),
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
                                        title: const Text("Přidání člena týmu"),
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
                                                    initialValue: newTeamMember[
                                                        "firstName"],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "Jméno",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newTeamMember[
                                                                "firstName"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    initialValue: newTeamMember[
                                                        "lastName"],
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "Příjmení",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newTeamMember[
                                                            "lastName"] = value;
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    initialValue: newTeamMember[
                                                        "phoneNumber"],
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "Telefon",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newTeamMember[
                                                                "phoneNumber"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    initialValue: newTeamMember[
                                                        "birthDate"],
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          "Datum narození",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newTeamMember[
                                                                "birthDate"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    initialValue:
                                                        newTeamMember["type"],
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "Typ",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newTeamMember["type"] =
                                                            int.parse(value);
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
                                                    newTeamMember = {};
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
                                                : (newTeamMember["firstName"] != null &&
                                                        newTeamMember[
                                                                "lastName"] !=
                                                            null &&
                                                        newTeamMember["type"] !=
                                                            null &&
                                                        newTeamMember[
                                                                "teamId"] !=
                                                            null)
                                                    ? () async {
                                                        await handleTeamMemberCreate(
                                                          token: globals
                                                              .user.token!,
                                                          teamMember:
                                                              newTeamMember,
                                                        );
                                                      }
                                                    : null,
                                            child:
                                                const Text("Přidat člena týmu"),
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
                            onPressed: selectedTeamMember == null
                                ? null
                                : () {
                                    editTeamMember = selectedTeamMember!.map;
                                    print(editTeamMember);
                                    /* showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Úprava člena týmu"),
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
                                                              editInjury[
                                                                  "situation"],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              const InputDecoration(
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
                                                          initialValue:
                                                              editInjury[
                                                                  "diagnosis"],
                                                          decoration:
                                                              const InputDecoration(
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
                                                          initialValue: editInjury[
                                                              "necessaryEquipment"],
                                                          decoration:
                                                              const InputDecoration(
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
                                                          initialValue:
                                                              editInjury[
                                                                  "info"],
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                "Informace",
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
                                                            labelText:
                                                                "Maximální počet bodů",
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
                                                                      "info"] !=
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
                                    ); */
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
                            onPressed: selectedTeamMember == null
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
                                                  "Smazání člena týmu"),
                                              content: loading["delete"] == true
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const [
                                                        CircularProgressIndicator(),
                                                      ],
                                                    )
                                                  : const Text(
                                                      "Opravdu chcete smazat člena týmu?"),
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
                                                              await handleTeamMemberDelete(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                teamMemberId:
                                                                    selectedTeamMember!
                                                                        .id,
                                                              );
                                                            },
                                                  child: const Text(
                                                      "Smazat člena týmu"),
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
                    if (selectedTeamMember != null)
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(
                                  "Jméno: ${selectedTeamMember!.firstName}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(
                                  "Příjmení: ${selectedTeamMember!.lastName}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(
                                  "Datum narození: ${selectedTeamMember!.birthDate ?? "Není zadáno"}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Text(
                                  "Telefonní číslo: ${selectedTeamMember!.phoneNumber ?? "Není zadáno"}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                              child: Text("Typ: ${selectedTeamMember!.type}"),
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
