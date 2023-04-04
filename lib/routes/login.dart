//packages
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/functions.dart' as functions;
import 'package:cck_admin/widgets.dart' as widgets;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? email;
  String? password;
  bool hiddenPassword = true;
  bool _rememberPassword = false;
  bool _isLoading = false;

  handleLogin() async {
    setState(() {
      _isLoading = true;
    });
    var object = await functions.login(email: email!, password: password!);
    setState(() {
      _isLoading = false;
    });
    if (object.functionCode == globals.FunctionCode.success) {
      const storage = FlutterSecureStorage();
      storage.write(
          key: "rememberPassword", value: _rememberPassword.toString());
      if (_rememberPassword) {
        storage.write(key: "password", value: password);
      } else {
        storage.delete(key: "password");
      }
      globals.loadMode = "competitions";
      Navigator.pushReplacementNamed(context, "/loading");
      password = null;
    } else if (object.functionCode == globals.FunctionCode.error) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            "Chyba",
            style: TextStyle(fontSize: 22),
          ),
          content: const Text(
            "Email nebo heslo nejsou správné.",
            style: TextStyle(fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "OK",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        barrierDismissible: true,
      );
    } else if (object.functionCode == globals.FunctionCode.connectionError) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            "Chyba",
            style: TextStyle(fontSize: 22),
          ),
          content: const Text(
            "Nepodařilo se připojit k serveru.",
            style: TextStyle(fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        barrierDismissible: true,
      );
    }
  }

  getData() async {
    const storage = FlutterSecureStorage();
    _rememberPassword =
        await storage.read(key: "rememberPassword") == "true" ? true : false;
    debugPrint("rememberPassword from SP: $_rememberPassword");
    if (_rememberPassword) {
      password = await storage.read(key: "password");
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const widgets.WindowsStuff(path: ""),
          Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Image(
                      image:
                          AssetImage("assets/images/cck_logo_transparent.png"),
                      height: 220,
                    ),
                  ),
                  const Text(
                    "Přihlášení",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: TextFormField(
                        initialValue: 'lukasl32@atlas.cz',
                        onChanged: (value) {
                          if (!_isLoading) {
                            email = value;
                          }
                        },
                        textAlign: TextAlign.justify,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.red),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.amber,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: TextFormField(
                        onChanged: (value) {
                          if (!_isLoading) {
                            password = value;
                          }
                        },
                        controller: TextEditingController(text: password),
                        obscureText: hiddenPassword,
                        textAlign: TextAlign.justify,
                        decoration: InputDecoration(
                          labelText: "Heslo",
                          labelStyle: const TextStyle(color: Colors.red),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hiddenPassword = !hiddenPassword;
                              });
                            },
                            icon: Icon(
                              color: Colors.black,
                              hiddenPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey[700],
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            activeColor: Colors.red,
                            value: _rememberPassword,
                            onChanged: (value) =>
                                setState(() => _rememberPassword = value!),
                          ),
                          GestureDetector(
                            child: const Text(
                              "Zapamatovat heslo",
                              style: TextStyle(fontSize: 15),
                            ),
                            onTap: () {
                              setState(() {
                                _rememberPassword = !_rememberPassword;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 5, 50, 0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: ElevatedButton(
                        onPressed: () {
                          if (globals.debug) {
                            Navigator.pushReplacementNamed(
                                context, "/competitions");
                          } else if (email == null ||
                              email == "" ||
                              password == null ||
                              password == "") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Vyplňte email a heslo",
                                  style: TextStyle(fontSize: 16),
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else if (!_isLoading) {
                            handleLogin();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Center(
                            child: _isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 4,
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        'Přihlašování...',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  )
                                : const Text(
                                    "Přihlásit se",
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
