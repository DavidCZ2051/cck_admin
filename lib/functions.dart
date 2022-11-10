// packages
import 'package:flutter/material.dart';
import 'package:http/http.dart';
// files
import 'package:cck_admin/globals.dart' as globals;

Future<globals.FunctionObject> login({
  required String email,
  required String password,
}) async {
  Response response = await post(
    Uri.parse("http://${globals.url}/api/login"),
    body: {
      "email": email,
      "password": password,
    },
  );
  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    return globals.FunctionObject(
      statusCode: 200,
      functionCode: 0,
    );
  } else {
    return globals.FunctionObject(
      statusCode: response.statusCode,
      functionCode: 1,
    );
  }
}
