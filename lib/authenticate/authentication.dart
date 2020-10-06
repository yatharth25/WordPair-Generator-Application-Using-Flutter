import 'package:flutter/widgets.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Authentication with ChangeNotifier {
  Future<Map<String, String>> register(String email, String password) async {
    var result = new Map<String, String>();
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA0LVSUCcY0Rn8LX4QQERV9wfcsUxUtZpc';
    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    final data = json.decode(response.body);
    if (data['error'] != null) {
      result['status'] = 'false';
      result['data'] = data['error']['message'];
      return result;
    } else {
      result['status'] = 'true';
      result['data'] = data['email'];
      return result;
    }
  }

  Future<Map<String, String>> signin(String email, String password) async {
    var result = new Map<String, String>();
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA0LVSUCcY0Rn8LX4QQERV9wfcsUxUtZpc';

    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    final data = json.decode(response.body);
    if (data['error'] != null) {
      result['status'] = 'false';
      result['data'] = data['error']['message'];
      return result;
    } else {
      result['status'] = 'true';
      result['data'] = data['email'];
      var session = FlutterSession();
      await session.set("email", data['email']);
      await session.set("idToken", data['idToken']);
      return result;
    }
  }
}
