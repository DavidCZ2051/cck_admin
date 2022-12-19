// packages
import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/widgets.dart' as widgets;
import 'package:cck_admin/functions.dart' as functions;

class Competition extends StatefulWidget {
  const Competition({super.key});

  @override
  State<Competition> createState() => _CompetitionState();
}

class _CompetitionState extends State<Competition> {
  Map<String, bool> loading = {};

  setstate() {
    setState(() {});
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
                          onTap: null,
                          selected: true,
                        ),
                        ListTile(
                          leading: const Icon(Icons.room),
                          title: const Text("Stanoviště"),
                          onTap: () {
                            Navigator.pushNamed(context, "/stations");
                          },
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
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    child: Column(
                      children: [
                        Text(
                            "Popis soutěže: ${globals.selectedCompetition!.description}"),
                        Text(
                            "Počet týmů: ${globals.selectedCompetition!.teams.length}"),
                        Text(
                            "Počet stanovišť: ${globals.selectedCompetition!.stations.length}"),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
