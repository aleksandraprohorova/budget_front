import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'AuthRequests.dart';
import '../entity/Balance.dart';

List<Balance> parseBalances(List<dynamic> responseBody) {
  return responseBody.map<Balance>((json) => Balance.fromJson(json)).toList();
}

class BalancesListResponse {
  List<Balance> balances;
  BalancesListResponse({this.balances});

  factory BalancesListResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonDynamic = json['balances'];

    List<Balance> balancesList = parseBalances(jsonDynamic);
    return BalancesListResponse(
      balances: balancesList,
    );
  }
}

Future<List<Balance>> fetchBalances(http.Client client) async {
  log('fetch balances');
  final response = await client.get(Uri.http('localhost:8082', 'balances'),
    headers: {HttpHeaders.authorizationHeader: 'Bearer ${TokenManager.getToken()}'});
  log('${response.statusCode.toString()}, ${response.body}');
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonBody = jsonDecode(response.body);
    BalancesListResponse balancesListResponse = BalancesListResponse.fromJson(jsonBody);
    List<Balance> balancesList = balancesListResponse.balances;
    return balancesList;
  } else {
    throw Exception('Failed to load balances');
  }
}

class AddBalanceRequest {
  DateTime dateStart;
  DateTime dateEnd;

  AddBalanceRequest({this.dateStart, this.dateEnd});

  final DateFormat formatterServer = DateFormat('yyyy-MM-ddTHH:mm:ss');

  Map toJson() => {
    'dateStart': formatterServer.format(dateStart),
    'dateEnd': formatterServer.format(dateEnd)
  };
}

Future<bool> addBalance(http.Client client, AddBalanceRequest request) async {
  log('add Balance');
  log(request.dateStart.toString());
  log(request.dateEnd.toString());
  var data = jsonEncode(request);
  final response = await client.post(Uri.http('localhost:8082', 'balances'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${TokenManager.getToken()}'
      },
      body: data);
  log('${response.statusCode.toString()}, ${response.body}');
  return (response.statusCode == 200);
}

Future<bool> deleteBalance(http.Client client, int id) async {
  log('delete balance');
  log(id.toString());
  Uri url = Uri.http('localhost:8082','balances',{ "id": id.toString() });
  final response = await client.delete(url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer ${TokenManager.getToken()}'
    },);
  log('${response.statusCode.toString()}, ${response.body}');
  return (response.statusCode == 200);
}
