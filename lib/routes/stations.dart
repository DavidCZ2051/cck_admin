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
  }

  handleStationCreate({
    required String token,
    required Map<String, dynamic> station,
  }) async {
    setState(() {
      loading["create"] = true;
    });
    print("Creating station with data: $station");
    var object = await functions.createStation(
      token: token,
      station: station,
      competitionId: globals.selectedCompetition!.id,
    );
    setState(() {
      loading["create"] = false;
    });

    if (object.functionCode == globals.FunctionCode.success) {
      setState(() {});
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text(globals.selectedCompetition!.type),
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
                        ListTile(
                          leading: const Icon(Icons.room),
                          title: const Text("Stanoviště"),
                          onTap: null,
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
                                                children: [],
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
                                            onPressed: () {},
                                            /* loading["create"] == true
                                                ? null
                                                : (true) // here should be some validation
                                                    ? null
                                                    : () async {
                                                        await handleTeamCreate(
                                                          token: globals
                                                              .user.token!,
                                                          team: newTeam,
                                                        );
                                                      }, */
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
                                    print(globals.competitions);
                                    showGeneralDialog(
                                        context: context,
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return AlertDialog(
                                            title:
                                                const Text("Úprava stanoviště"),
                                            content: Column(
                                              children: [
                                                Row(
                                                  children: const [
                                                    Text("Typ: "),
                                                    Text("Předkolo"),
                                                  ],
                                                )
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                style: ButtonStyle(
                                                  overlayColor:
                                                      MaterialStateProperty.all(
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
                                                      MaterialStateProperty.all(
                                                          Colors.red),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                    "Aplikovat změny"),
                                              ),
                                            ],
                                          );
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
                    if (globals.selectedCompetition!.teams.isEmpty)
                      const Center(
                        child: Text(
                          "Zatím nejsou přidány žádné stanoviště",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    if (globals.selectedCompetition!.stations.isNotEmpty)
                      for (globals.Station station
                          in globals.selectedCompetition!.stations)
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          "${station.title} - ID: ${station.id}"),
                                    ],
                                  ),
                                  Text(station.number.toString()),
                                ],
                              ),
                            ),
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
