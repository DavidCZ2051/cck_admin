//packages
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//files
import 'package:cck_admin/globals.dart' as globals;
import 'package:cck_admin/functions.dart' as functions;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
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
      print("$_rememberPassword test");
      if (_rememberPassword) {
        storage.write(key: "password", value: password);
        print("heslo uloženo, $password");
      } else {
        storage.delete(key: "password");
        print("heslo smazáno");
      }
      Navigator.pushReplacementNamed(context, "/loading");
      password = null;
    } else {
      print("Request failed with status: ${object.statusCode}.");
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
    }
  }

  getData() async {
    const storage = FlutterSecureStorage();
    _rememberPassword =
        await storage.read(key: "rememberPassword") == "true" ? true : false;
    print("rememberPassword from SP: $_rememberPassword");
    if (_rememberPassword) {
      password = await storage.read(key: "password");
      print("password from SP: $password");
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(25.0),
                child: Image(
                  image: AssetImage("assets/images/cck_logo_transparent.png"),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
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
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 4,
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
    );
  }
}
