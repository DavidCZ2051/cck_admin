// packages
import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/functions.dart' as functions;
import 'package:cck_admin/widgets.dart' as widgets;

class Stations extends StatefulWidget {
  const Stations({super.key});

  @override
  State<Stations> createState() => _StationsState();
}

class _StationsState extends State<Stations> {
  Map<String, dynamic> newStation = {};
  Map<String, dynamic> editStation = {};
  globals.Station? selectedStation;
  Map<String, bool> loading = {
    "delete": false,
    "create": false,
    "edit": false,
  };

  setstate() {
    setState(() {});
  }

  handleStationDelete({
    required String token,
    required int stationId,
  }) async {
    setState(() {
      loading["delete"] = true;
    });
    setstate();
    print("Deleting station with id: $stationId");
    var object = await functions.deleteStation(
      token: token,
      stationId: selectedStation!.id,
    );
    setState(() {
      loading["delete"] = false;
    });
    setstate();
    if (object.functionCode == globals.FunctionCode.success) {
      setState(() {
        globals.selectedCompetition!.stations.removeWhere(
          (station) => station.id == selectedStation!.id,
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
    selectedStation = null;
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

  handleStationEdit({
    required String token,
    required Map<String, dynamic> station,
  }) async {
    setState(() {
      loading["edit"] = true;
    });

    station["type"] = globals.getStationTypeId(type: station["type"]);
    station["tier"] = globals.getStationTierId(tier: station["tier"]);

    print("Editing station with data: $station");
    var object = await functions.editStation(
      token: token,
      station: station,
      stationId: selectedStation!.id,
    );

    if (object.functionCode == globals.FunctionCode.success) {
      globals.selectedCompetition!.stations = [];
      object = await functions.getStations(
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
                                        Text(globals.selectedCompetition!.type),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      globals.loadMode = "competitions";
                                      Navigator.pushReplacementNamed(
                                          context, "/loading");
                                    },
                                    child: const Text("Zpět"),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      globals
                                          .selectedCompetition!.startDateString,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      globals
                                          .selectedCompetition!.endDateString,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        globals.selectedCompetition!.state),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.home),
                          title: const Text("Přehled soutěže"),
                          onTap: () {
                            Navigator.pushNamed(context, "/competition");
                          },
                        ),
                        const ListTile(
                          leading: Icon(
                            Icons.room,
                            color: Colors.red,
                          ),
                          title: Text(
                            "Stanoviště",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          selected: true,
                        ),
                        ListTile(
                          leading: const Icon(Icons.people),
                          title: const Text("Týmy"),
                          onTap: () {
                            Navigator.pushNamed(context, "/teams");
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
                                                    cursorColor: Colors.red,
                                                    initialValue: newStation[
                                                                    "number"]
                                                                .toString() ==
                                                            "null"
                                                        ? ""
                                                        : newStation["number"]
                                                            .toString(),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelStyle: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      labelText:
                                                          "Číslo (číslo)",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newStation["number"] =
                                                            int.tryParse(value);
                                                      });
                                                    },
                                                  ),
                                                  TextFormField(
                                                    cursorColor: Colors.red,
                                                    initialValue:
                                                        newStation["title"],
                                                    decoration:
                                                        const InputDecoration(
                                                      labelStyle: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      labelText: "Název",
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newStation["title"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  //station type
                                                  DropdownButton(
                                                    hint: const Text(
                                                        "Typ stanoviště"),
                                                    value: newStation["type"],
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
                                                        newStation["type"] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                  //station tier
                                                  DropdownButton(
                                                    hint: const Text(
                                                        "Druh stanoviště"),
                                                    value: newStation["tier"],
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
                                                        newStation["tier"] =
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
                                                    newStation = {};
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
                                                : (newStation["title"] !=
                                                            null &&
                                                        newStation["tier"] !=
                                                            null &&
                                                        newStation["type"] !=
                                                            null &&
                                                        newStation["number"] !=
                                                            null)
                                                    ? () async {
                                                        await handleStationCreate(
                                                          token: globals
                                                              .user.token!,
                                                          station: newStation,
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
                            onPressed: selectedStation == null
                                ? null
                                : () {
                                    editStation = selectedStation!.map;
                                    editStation["tier"] = globals
                                        .stationTiers[editStation["tier"]];
                                    editStation["type"] = globals
                                        .stationTypes[editStation["type"]];
                                    print(editStation);
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
                                                          cursorColor:
                                                              Colors.red,
                                                          initialValue: editStation[
                                                                          "number"]
                                                                      .toString() ==
                                                                  "null"
                                                              ? ""
                                                              : editStation[
                                                                      "number"]
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
                                                                "Číslo (číslo)",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editStation[
                                                                      "number"] =
                                                                  int.tryParse(
                                                                      value);
                                                            });
                                                          },
                                                        ),
                                                        TextFormField(
                                                          cursorColor:
                                                              Colors.red,
                                                          initialValue:
                                                              editStation[
                                                                  "title"],
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
                                                            labelText: "Název",
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              editStation[
                                                                      "title"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        //station competition
                                                        DropdownButton(
                                                          hint: const Text(
                                                              "Soutěž"),
                                                          value: editStation[
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
                                                              editStation[
                                                                      "competitionId"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        //station type
                                                        DropdownButton(
                                                          hint: const Text(
                                                              "Typ stanoviště"),
                                                          value: editStation[
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
                                                              editStation[
                                                                      "type"] =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                        //station tier
                                                        DropdownButton(
                                                          hint: const Text(
                                                              "Druh stanoviště"),
                                                          value: editStation[
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
                                                              editStation[
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
                                                              editStation = {};
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
                                                      : (editStation[
                                                                      "title"] !=
                                                                  null &&
                                                              editStation[
                                                                      "tier"] !=
                                                                  null &&
                                                              editStation[
                                                                      "type"] !=
                                                                  null &&
                                                              editStation[
                                                                      "number"] !=
                                                                  null)
                                                          ? () async {
                                                              await handleStationEdit(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                station:
                                                                    editStation,
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
                            onPressed: selectedStation == null
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
                                                  "Smazání stanoviště"),
                                              content: loading["delete"] == true
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const [
                                                        CircularProgressIndicator(),
                                                      ],
                                                    )
                                                  : const Text(
                                                      "Opravdu chcete smazat stanoviště?"),
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
                                                              await handleStationDelete(
                                                                token: globals
                                                                    .user
                                                                    .token!,
                                                                stationId:
                                                                    selectedStation!
                                                                        .id,
                                                              );
                                                            },
                                                  child: const Text(
                                                      "Smazat stanoviště"),
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
                    if (globals.selectedCompetition!.stations.isEmpty)
                      const Center(
                        child: Text(
                          "Zatím nejsou přidány žádné stanoviště",
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
                              const Text(
                                "První stupeň",
                                style: TextStyle(fontSize: 20),
                              ),
                              for (globals.Station station in globals
                                  .selectedCompetition!.stations
                                  .where((element) => element.tier == 2))
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 80,
                                    minWidth: 330,
                                  ),
                                  child: Card(
                                    color: selectedStation == station
                                        ? Colors.red
                                        : Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (selectedStation == station) {
                                            selectedStation = null;
                                          } else {
                                            selectedStation = station;
                                          }
                                        });
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 8, 0, 0),
                                                child: Text(
                                                    "${station.title} - ID: ${station.id}"),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                onPressed: () {
                                                  station.injuries = [];
                                                  globals.selectedStation =
                                                      station;
                                                  globals.loadMode = "injuries";
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context, "/loading");
                                                },
                                                child: const Text("Otevřít"),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 0, 0),
                                            child: Text(
                                                "Číslo: ${station.number}"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 0, 8),
                                            child: Text(
                                              "Typ: ${globals.stationTypes[station.type]}",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const VerticalDivider(),
                          Column(
                            children: [
                              const Text(
                                "Druhý stupeň",
                                style: TextStyle(fontSize: 20),
                              ),
                              for (globals.Station station in globals
                                  .selectedCompetition!.stations
                                  .where((element) => element.tier == 3))
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 80,
                                    minWidth: 330,
                                  ),
                                  child: Card(
                                    color: selectedStation == station
                                        ? Colors.red
                                        : Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (selectedStation == station) {
                                            selectedStation = null;
                                          } else {
                                            selectedStation = station;
                                          }
                                        });
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 8, 0, 0),
                                                child: Text(
                                                    "${station.title} - ID: ${station.id}"),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                onPressed: () {
                                                  station.injuries = [];
                                                  globals.selectedStation =
                                                      station;

                                                  globals.loadMode = "injuries";
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context, "/loading");
                                                },
                                                child: const Text("Otevřít"),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 0, 0),
                                            child: Text(
                                                "Číslo: ${station.number}"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 0, 8),
                                            child: Text(
                                              "Typ: ${globals.stationTypes[station.type]}",
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
