// packages
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:file_saver/file_saver.dart';
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
  WidgetsToImageController imageController = WidgetsToImageController();
  Map<String, dynamic> newTeamMember = {};
  Map<String, dynamic> editTeamMember = {};
  globals.TeamMember? selectedTeamMember;
  Map<String, bool> loading = {
    "delete": false,
    "create": false,
    "edit": false,
  };

  void makeImage() {
    imageController.capture().then((capturedImage) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await FileSaver.instance.saveFile(
          name: "qr_${selectedTeamMember!.id}",
          bytes: capturedImage!,
          ext: "png",
        );
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("QR kód uložen do stažených souborů!"),
          ),
        );
      });
    });
  }

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
    debugPrint("Deleting team member with id: $teamMemberId");
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

    debugPrint("Creating team member with data: $teamMember");
    var object = await functions.createTeamMember(
      token: token,
      teamMember: teamMember,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.selectedTeam!.members = [];
      object = await functions.getTeamMembers(
        token: token,
      );
      object = await functions.getQrCodes(
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

    debugPrint("Editing team member with data: $teamMember");
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
          const widgets.WindowsStuff(path: "Soutěž > Tým"),
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
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
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
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        teamMember.type == 1
                                            ? Icons.person_add_alt_1
                                            : teamMember.type == 2
                                                ? Icons.group
                                                : Icons.person,
                                        size: 30,
                                      ),
                                    ),
                                    Text(
                                        "${teamMember.firstName} ${teamMember.lastName}- ID: ${teamMember.id}"),
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
                              newTeamMember = {
                                "teamId": globals.selectedTeam!.id.toString(),
                              };
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
                                                    cursorColor: Colors.red,
                                                    initialValue: newTeamMember[
                                                        "firstName"],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelStyle: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                        color: Colors.red,
                                                      )),
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
                                                    cursorColor: Colors.red,
                                                    initialValue: newTeamMember[
                                                        "lastName"],
                                                    decoration:
                                                        const InputDecoration(
                                                      labelStyle: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                        color: Colors.red,
                                                      )),
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
                                                    cursorColor: Colors.red,
                                                    initialValue: newTeamMember[
                                                        "phoneNumber"],
                                                    decoration:
                                                        const InputDecoration(
                                                      labelStyle: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                        color: Colors.red,
                                                      )),
                                                      labelText:
                                                          "Telefon (nepovinné)",
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
                                                    cursorColor: Colors.red,
                                                    initialValue: newTeamMember[
                                                        "birthDate"],
                                                    decoration:
                                                        const InputDecoration(
                                                      labelStyle: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                        color: Colors.red,
                                                      )),
                                                      labelText:
                                                          "Datum narození (nepovinné)",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newTeamMember[
                                                                "birthDate"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  DropdownButton(
                                                    items: const [
                                                      DropdownMenuItem(
                                                        value: 3,
                                                        child: Text("Člen"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: 1,
                                                        child: Text("Velitel"),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: 2,
                                                        child: Text("Doprovod"),
                                                      ),
                                                    ],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newTeamMember["type"] =
                                                            value;
                                                      });
                                                    },
                                                    value:
                                                        newTeamMember["type"],
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
                                    showDialog(
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
                                                          cursorColor:
                                                              Colors.red,
                                                          initialValue:
                                                              editTeamMember[
                                                                  "firstName"],
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
                                                              color: Colors.red,
                                                            )),
                                                            labelText: "Jméno",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editTeamMember[
                                                                      "firstName"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        TextFormField(
                                                          cursorColor:
                                                              Colors.red,
                                                          initialValue:
                                                              editTeamMember[
                                                                  "lastName"],
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
                                                              color: Colors.red,
                                                            )),
                                                            labelText:
                                                                "Příjmení",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editTeamMember[
                                                                      "lastName"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        TextFormField(
                                                          cursorColor:
                                                              Colors.red,
                                                          initialValue:
                                                              editTeamMember[
                                                                  "phoneNumber"],
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
                                                              color: Colors.red,
                                                            )),
                                                            labelText:
                                                                "Telefon (nepovinné)",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editTeamMember[
                                                                      "phoneNumber"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        TextFormField(
                                                          cursorColor:
                                                              Colors.red,
                                                          initialValue:
                                                              editTeamMember[
                                                                  "birthDate"],
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
                                                              color: Colors.red,
                                                            )),
                                                            labelText:
                                                                "Datum narození (nepovinné)",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editTeamMember[
                                                                      "birthDate"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        DropdownButton(
                                                          items: const [
                                                            DropdownMenuItem(
                                                              value: 3,
                                                              child:
                                                                  Text("Člen"),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 1,
                                                              child: Text(
                                                                  "Velitel"),
                                                            ),
                                                            DropdownMenuItem(
                                                              value: 2,
                                                              child: Text(
                                                                  "Doprovod"),
                                                            ),
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editTeamMember[
                                                                      "type"] =
                                                                  value;
                                                            });
                                                          },
                                                          value: editTeamMember[
                                                              "type"],
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
                                                          editTeamMember = {};
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
                                                      : (editTeamMember[
                                                                      "firstName"] !=
                                                                  null &&
                                                              editTeamMember[
                                                                      "lastName"] !=
                                                                  null &&
                                                              editTeamMember[
                                                                      "type"] !=
                                                                  null &&
                                                              editTeamMember[
                                                                      "teamId"] !=
                                                                  null)
                                                          ? () async {
                                                              await handleTeamMemberEdit(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                teamMember:
                                                                    editTeamMember,
                                                              );
                                                            }
                                                          : null,
                                                  child: const Text(
                                                      "Upravit člena týmu"),
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
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                  child: Text(
                                      "Jméno: ${selectedTeamMember!.firstName}"),
                                ),
                                const SizedBox(width: 40),
                                if (selectedTeamMember!.type == 1)
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("QR kód"),
                                              content: WidgetsToImage(
                                                controller: imageController,
                                                child: AspectRatio(
                                                  aspectRatio: 1.6 / 1,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          PrettyQr(
                                                            data:
                                                                selectedTeamMember!
                                                                    .qrJson,
                                                            size: 400,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(20),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${selectedTeamMember!.firstName} ${selectedTeamMember!.lastName}",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        30,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Tým číslo ${globals.selectedTeam!.number}",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        25,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    makeImage();
                                                  },
                                                  child: const Text("Uložit"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Zavřít"),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(Icons.qr_code),
                                  ),
                              ],
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
                              child: Text(
                                  "Typ: ${globals.teamMemberTypes[selectedTeamMember!.type]}"),
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
