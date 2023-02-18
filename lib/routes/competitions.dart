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
  Map<String, dynamic> editCompetition = {};
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
      selectedCompetition = null;
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

  handleCompetitionEdit({
    required String token,
    required int competitionId,
    required Map<String, dynamic> competition,
  }) async {
    setState(() {
      loading["edit"] = true;
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
    print("Editing competition: $competition");
    var object = await functions.editCompetition(
      token: token,
      competitionId: competitionId,
      competition: competition,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.competitions = [];
      object = await functions.getCompetitions(
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

    if (object.functionCode == globals.FunctionCode.success) {
      globals.competitions = [];
      object = await functions.getCompetitions(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const widgets.WindowsStuff(path: "Soutěže"),
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
                        for (globals.Competition competition
                            in globals.competitions)
                          Card(
                            color: selectedCompetition == competition
                                ? Colors.red
                                : Colors.white,
                            child: InkWell(
                              /* onDoubleTap: () {
                                selectedCompetition = competition;
                                globals.selectedCompetition =
                                    selectedCompetition;
                                globals.loadMode = "competition";
                                Navigator.pushReplacementNamed(
                                    context, "/loading");
                              }, */
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
                                        child: Text(
                                            "${competition.type} - ID: ${competition.id}"),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
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
                                                      cursorColor: Colors.red,
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
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        labelText:
                                                            "Popis soutěže",
                                                        floatingLabelStyle:
                                                            TextStyle(
                                                          color: Colors.red,
                                                        ),
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
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                          onPressed: () async {
                                                            DateTime? date =
                                                                await showDatePicker(
                                                              cancelText:
                                                                  "Zrušit",
                                                              confirmText: "OK",
                                                              helpText:
                                                                  "Vyberte datum",
                                                              errorFormatText:
                                                                  "Nesprávný formát (mm/dd/rrrr)",
                                                              errorInvalidText:
                                                                  "Nesprávné datum",
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
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                          onPressed: () async {
                                                            DateTime? date =
                                                                await showDatePicker(
                                                              cancelText:
                                                                  "Zrušit",
                                                              confirmText: "OK",
                                                              helpText:
                                                                  "Vyberte datum",
                                                              errorFormatText:
                                                                  "Nesprávný formát (mm/dd/rrrr)",
                                                              errorInvalidText:
                                                                  "Nesprávné datum",
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
                                                    newCompetition = {};
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

                                    editCompetition["type"] =
                                        selectedCompetition!.type;
                                    editCompetition["startDate"] =
                                        selectedCompetition!.startDate;
                                    editCompetition["endDate"] =
                                        selectedCompetition!.endDate;
                                    editCompetition["description"] =
                                        selectedCompetition!.description;

                                    showGeneralDialog(
                                        context: context,
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return StatefulBuilder(
                                              builder: ((context, setState) {
                                            return AlertDialog(
                                              title:
                                                  const Text("Úprava soutěže"),
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
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            // competition type
                                                            children: [
                                                              const Text(
                                                                "Typ soutěže: ",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              DropdownButton(
                                                                value:
                                                                    editCompetition[
                                                                        "type"],
                                                                items: [
                                                                  for (var type
                                                                      in globals
                                                                          .competitionTypes
                                                                          .values)
                                                                    DropdownMenuItem(
                                                                      value:
                                                                          type,
                                                                      child:
                                                                          Text(
                                                                        type,
                                                                      ),
                                                                    ),
                                                                ],
                                                                onChanged:
                                                                    (dynamic
                                                                        value) {
                                                                  setState(() {
                                                                    editCompetition[
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
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: TextFormField(
                                                            cursorColor:
                                                                Colors.red,
                                                            initialValue:
                                                                editCompetition[
                                                                    "description"],
                                                            onChanged:
                                                                (String value) {
                                                              setState(() {
                                                                editCompetition[
                                                                        "description"] =
                                                                    value;
                                                              });
                                                              setstate();
                                                            },
                                                            decoration:
                                                                const InputDecoration(
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                              labelStyle:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              labelText:
                                                                  "Popis soutěže",
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            // competition start date
                                                            children: [
                                                              const Text(
                                                                "Datum začátku: ",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  DateTime?
                                                                      date =
                                                                      await showDatePicker(
                                                                    cancelText:
                                                                        "Zrušit",
                                                                    confirmText:
                                                                        "OK",
                                                                    helpText:
                                                                        "Vyberte datum",
                                                                    errorFormatText:
                                                                        "Nesprávný formát (mm/dd/rrrr)",
                                                                    errorInvalidText:
                                                                        "Nesprávné datum",
                                                                    context:
                                                                        context,
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
                                                                  if (date !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      editCompetition[
                                                                              "startDate"] =
                                                                          date;
                                                                    });
                                                                    setstate();
                                                                    print(
                                                                        "Selected date: ${editCompetition["startDate"]}");
                                                                  }
                                                                },
                                                                child: Text(
                                                                  editCompetition[
                                                                              "startDate"] ==
                                                                          null
                                                                      ? "Vyberte datum"
                                                                      : functions.formatDateTime(
                                                                          dateTime:
                                                                              editCompetition["startDate"]),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            // competition end date
                                                            children: [
                                                              const Text(
                                                                "Datum konce: ",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  DateTime?
                                                                      date =
                                                                      await showDatePicker(
                                                                    cancelText:
                                                                        "Zrušit",
                                                                    confirmText:
                                                                        "OK",
                                                                    helpText:
                                                                        "Vyberte datum",
                                                                    errorFormatText:
                                                                        "Nesprávný formát (mm/dd/rrrr)",
                                                                    errorInvalidText:
                                                                        "Nesprávné datum",
                                                                    context:
                                                                        context,
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
                                                                  if (date !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      editCompetition[
                                                                              "endDate"] =
                                                                          date;
                                                                    });
                                                                    setstate();
                                                                    print(
                                                                        "Selected date: ${editCompetition["endDate"]}");
                                                                  }
                                                                },
                                                                child: Text(
                                                                  editCompetition[
                                                                              "endDate"] ==
                                                                          null
                                                                      ? "Vyberte datum"
                                                                      : functions.formatDateTime(
                                                                          dateTime:
                                                                              editCompetition["endDate"]),
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
                                                        MaterialStateProperty
                                                            .all(
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
                                                        MaterialStateProperty
                                                            .all(Colors.red),
                                                  ),
                                                  onPressed: () {
                                                    handleCompetitionEdit(
                                                      token:
                                                          globals.user.token!,
                                                      competitionId:
                                                          selectedCompetition!
                                                              .id,
                                                      competition:
                                                          editCompetition,
                                                    );
                                                  },
                                                  child: const Text(
                                                      "Aplikovat změny"),
                                                ),
                                              ],
                                            );
                                          }));
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
