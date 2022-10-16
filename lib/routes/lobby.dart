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
        title: const Text("Hlavní panel"),
        actions: [
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
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(primary: Colors.red),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Zrušit",
                        style: TextStyle(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red, primary: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/login");
                        globals.user.firstName = null;
                        globals.user.lastName = null;
                        globals.user.token = null;
                      },
                      child: const Text(
                        "Odhlásit se",
                        style: TextStyle(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
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
