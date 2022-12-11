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
    handleLoadingStuff();
  }

  Map description = {
    "competitions": 'Načítání soutěží...',
    "teams": 'Načítání týmů...',
    "stations": 'Načítání stanovišť...'
  };

  handleLoadingStuff() async {
    if (globals.loadMode == "competitions") {
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
            description[globals.loadMode],
            style: const TextStyle(fontSize: 22),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
