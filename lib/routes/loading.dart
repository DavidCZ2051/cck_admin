// packages
import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/functions.dart' as functions;
import 'package:cck_admin/widgets.dart' as widgets;

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    if (globals.loadMode == "competitions") {
      loadType = "competitions";
    } else if (globals.loadMode == "competition") {
      loadType = "teams";
    }
    handleLoadingStuff();
  }

  String? loadType;

  Map description = {
    "competitions": 'Načítání soutěží...',
    "teams": 'Načítání týmů...',
    "stations": 'Načítání stanovišť...',
    "injuries": 'Načítání zranění...',
    "teamMembers": 'Načítání členů týmů...',
    "figurants": 'Načítání figurantů...',
  };

  handleLoadingStuff() async {
    if (globals.loadMode == "competitions") {
      setState(() {
        loadType = "competitions";
      });
      globals.competitions = [];
      var object = await functions.getCompetitions(token: globals.user.token!);
      if (object.functionCode == globals.FunctionCode.error) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Chyba'),
                content: Text(
                    'Nepodařilo se načíst soutěže. Chybový kód: ${object.statusCode}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Zavřít'),
                  ),
                ],
              );
            });
        Navigator.pushReplacementNamed(context, "/login");
        return;
      }
      Navigator.pushReplacementNamed(context, "/competitions");
    } else if (globals.loadMode == "competition") {
      setState(() {
        loadType = "teams";
      });
      var object = await functions.getTeams(token: globals.user.token!);
      if (object.functionCode == globals.FunctionCode.error) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Chyba'),
                content: Text(
                    'Nepodařilo se načíst týmy. Chybový kód: ${object.statusCode}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Zavřít'),
                  ),
                ],
              );
            });
        Navigator.pushReplacementNamed(context, "/competitions");
        return;
      }
      setState(() {
        loadType = "teamMembers";
      });
      object = await functions.getTeamMembers(token: globals.user.token!);
      if (object.functionCode == globals.FunctionCode.error) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Chyba'),
                content: Text(
                    'Nepodařilo se načíst členy týmu. Chybový kód: ${object.statusCode}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Zavřít'),
                  ),
                ],
              );
            });
        Navigator.pushReplacementNamed(context, "/competitions");
        return;
      }
      setState(() {
        loadType = "stations";
      });
      object = await functions.getStations(token: globals.user.token!);
      if (object.functionCode == globals.FunctionCode.error) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Chyba'),
                content: Text(
                    'Nepodařilo se načíst stanoviště. Chybový kód: ${object.statusCode}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Zavřít'),
                  ),
                ],
              );
            });
        Navigator.pushReplacementNamed(context, "/competitions");
        return;
      }
      Navigator.pushReplacementNamed(context, "/competition");
    } else if (globals.loadMode == "injuries") {
      setState(() {
        loadType = "injuries";
      });

      if (globals.selectedStation != null) {
        globals.selectedStation!.injuries = [];
      }

      var object = await functions.getInjuries(token: globals.user.token!);
      if (object.functionCode == globals.FunctionCode.error) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Chyba'),
                content: Text(
                    'Nepodařilo se načíst zranění. Chybový kód: ${object.statusCode}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Zavřít'),
                  ),
                ],
              );
            });
        Navigator.pushReplacementNamed(context, "/stations");
        return;
      }
      Navigator.pushReplacementNamed(context, "/injuries");
    } else if (globals.loadMode == "injury") {
      setState(() {
        loadType = "figurants";
      });

      if (globals.selectedInjury != null) {
        globals.selectedInjury!.figurants = [];
      }

      var object = await functions.getFigurants(token: globals.user.token!);
      if (object.functionCode == globals.FunctionCode.error) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Chyba'),
                content: Text(
                    'Nepodařilo se načíst zranění. Chybový kód: ${object.statusCode}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Zavřít'),
                  ),
                ],
              );
            });
        Navigator.pushReplacementNamed(context, "/injuries");
        return;
      }
      Navigator.pushReplacementNamed(context, "/injury");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const widgets.WindowsStuff(),
          const Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 50, minWidth: 50),
            child: const CircularProgressIndicator(
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description[loadType] ?? 'error',
            style: const TextStyle(fontSize: 22),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
