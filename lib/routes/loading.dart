// packages
import 'package:flutter/material.dart';
// files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/functions.dart' as functions;

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
    0: 'Načítám soutěže...',
    1: 'Načítám informace o soutěžích...',
  };
  int progress = 0;

  handleLoadingStuff() async {
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
    setState(() {
      progress = 1;
    });
    Navigator.pushReplacementNamed(context, "/competitions");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              description[progress],
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
