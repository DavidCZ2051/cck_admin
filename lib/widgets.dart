// packages
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
// files
import 'package:cck_admin/globals.dart' as globals;

class MyNavigationRail extends StatefulWidget {
  const MyNavigationRail({super.key});

  @override
  State<MyNavigationRail> createState() => _MyNavigationRailState();
}

class _MyNavigationRailState extends State<MyNavigationRail> {
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: globals.navigationDrawer.expanded,
      indicatorColor: Colors.red,
      onDestinationSelected: (value) {
        setState(() {
          if (globals.navigationDrawer.index != value) {
            globals.navigationDrawer.index = value;

            Navigator.pushReplacementNamed(
                context, globals.navigationDrawer.navigationMap[value]);
          }
        });
      },
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text("Lobby"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text("Nastavení"),
        ),
      ],
      selectedIndex: globals.navigationDrawer.index,
    );
  }
}

class ErrorDialog extends StatefulWidget {
  const ErrorDialog({super.key, required this.statusCode});

  final int statusCode;

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  Map errorDescription = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Chyba ${widget.statusCode}'),
      content: errorDescription.containsKey(widget.statusCode)
          ? Text(errorDescription[widget.statusCode])
          : const Text('Neznámá chyba'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}

class WindowsStuff extends StatelessWidget {
  const WindowsStuff({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Row(
        children: [
          Expanded(
            child: MoveWindow(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: Text(path),
              ),
              onDoubleTap: () {
                appWindow.maximizeOrRestore();
              },
            ),
          ),
          MinimizeWindowButton(
            animate: true,
          ),
          MaximizeWindowButton(
            animate: true,
          ),
          CloseWindowButton(
            animate: true,
            onPressed: () async {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Opravdu chcete ukončit aplikaci?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Zrušit",
                          style: TextStyle(color: Colors.red)),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      onPressed: () {
                        appWindow.close();
                      },
                      child: const Text("Zavřít aplikaci"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
