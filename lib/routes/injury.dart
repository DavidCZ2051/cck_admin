// packages
import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/widgets.dart' as widgets;

class Injury extends StatefulWidget {
  const Injury({super.key});

  @override
  State<Injury> createState() => _InjuryState();
}

class _InjuryState extends State<Injury> {
  Map<String, bool> loading = {};

  setstate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const widgets.WindowsStuff(
              path: "Soutěž > Stanoviště > Zranění > Přehled zranění"),
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
                                    "${globals.selectedInjury!.diagnosis} - ID: ${globals.selectedInjury!.id}"),
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
                        const ListTile(
                          leading: Icon(
                            Icons.home,
                            color: Colors.red,
                          ),
                          title: Text(
                            "Přehled zranění",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          selected: true,
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
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 640,
                    ),
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Text(
                                "Diagnóza: ${globals.selectedInjury!.diagnosis}"),
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
                                maxLines: 4,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                "Situace: ${globals.selectedInjury!.situation}"),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Text(
                                "Počet figurantů: ${globals.selectedInjury!.figurants.length}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Text(
                                "Počet úloh: ${globals.selectedInjury!.tasks.length}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: Text(
                                "Počet léčebných procedur: ${globals.selectedInjury!.treatmentProcedures.length}"),
                          ),
                        ],
                      ),
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
