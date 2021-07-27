import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class AuthRequest
{
  String login;
  String password;

  AuthRequest({this.login, this.password});

  Map toJson() => {
    'login': login,
    'password': password
  };
}
class AuthResponse
{
  String token;
  AuthResponse({this.token});
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(token: json['token']);
  }
}



class TokenManager {
  static String _token = 'token_string';

  static Future<bool> _auth(String login, String password) async {
    Uri url = Uri.http('localhost:8082','auth');
    var data = jsonEncode(new AuthRequest(login: login, password: password));
    final response = await http.Client().post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data
    );
    log('${response.statusCode.toString()}, ${response.body}');
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = jsonDecode(response.body);
      AuthResponse tmp = AuthResponse.fromJson(jsonBody);
      _token = tmp.token;
      return true;
    }
    return false;
    //return AuthResponse.fromJson(jsonBody);
    // _token = response.body;
  }

  static void updateToken(String login, String password, Function callbackSuccess, Function callbackFailed) {
    Future<bool> res = _auth(login, password);
    res.then((value) { value ? callbackSuccess() : callbackFailed();});
   // _token = response.body;
  }
  static String getToken() => _token;
}
