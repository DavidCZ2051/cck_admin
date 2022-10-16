//packages
import 'package:flutter/material.dart';
//files
import 'package:cck_admin/globals.dart' as globals;

class Lobby extends StatefulWidget {
  const Lobby({Key? key}) : super(key: key);

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Hlavní panel"),
        actions: <Widget>[
          IconButton(
            tooltip: "Odhlášení",
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text(
                    "Odhlášení",
                    style: TextStyle(fontSize: 22),
                    overflow: TextOverflow.ellipsis,
                  ),
                  content: const Text(
                    "Opravdu se chcete odhlásit?",
                    style: TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Zrušit",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/login");
                        globals.user.firstName = null;
                        globals.user.lastName = null;
                        globals.user.token = null;
                      },
                      child: const Text(
                        "Odhlásit se",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                barrierDismissible: true,
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Lobby'),
      ),
    );
  }
}
