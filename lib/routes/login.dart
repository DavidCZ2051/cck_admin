//packages
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//files
import 'package:cck_admin/globals.dart' as globals;

const borderColor = Color(0xFF805306);

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

  getUserDetails(String token, int userId) async {
    final response = await get(
      Uri.parse("${globals.url}/user/detail/$userId"),
      headers: {"token": token},
    );
    final jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      globals.user.firstName = jsonData["firstName"];
      globals.user.lastName = jsonData["lastName"];
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }

  sendLoginRequest() async {
    final response = await get(
      Uri.parse("${globals.url}/user/login"),
      headers: {"email": email!, "password": password!},
    );
    setState(() {
      _isLoading = false;
    });
    final jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await getUserDetails(jsonData["token"], jsonData["userId"]);
      globals.user.token = jsonData["token"];
      final storage = new FlutterSecureStorage();
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

      Navigator.pushReplacementNamed(context, "/lobby");
      password = null;
    } else {
      print("Request failed with status: ${response.statusCode}.");
      if (jsonData["error"] == "Bad login") {
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
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: TextFormField(
                onChanged: (value) {
                  if (!_isLoading) {
                    email = value;
                  }
                },
                textAlign: TextAlign.justify,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.red[50],
                  hintText: "Email",
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.amber,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
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
                  filled: true,
                  fillColor: Colors.red[50],
                  hintText: "Heslo",
                  suffixIcon: InkWell(
                    child: Icon(
                        hiddenPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.red),
                    onTap: () {
                      hiddenPassword = !hiddenPassword;
                      setState(() {});
                    },
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 5, 50, 0),
              child: ElevatedButton(
                onPressed: () {
                  if (globals.debug) {
                    Navigator.pushReplacementNamed(context, "/lobby");
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
                    setState(() {
                      _isLoading = true;
                    });
                    sendLoginRequest();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
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
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
