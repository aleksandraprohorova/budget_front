import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'AuthRequests.dart';
import '../entity/Operation.dart';
import 'package:http/http.dart' as http;

List<Operation> parseOperations(List<dynamic> responseBody) {
  return responseBody.map<Operation>((json) => Operation.fromJson(json)).toList();
}

class OperationsListResponse {
  List<Operation> operations;
  OperationsListResponse({this.operations});

  factory OperationsListResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonDynamic = json['operations'];

    List<Operation> operationsList = parseOperations(jsonDynamic);
    return OperationsListResponse(
      operations: operationsList,
    );
  }
}

Future<List<Operation>> fetchOperations(http.Client client) async {
  log('fetch operations');
  final response = await client.get(Uri.http('localhost:8082', 'operations'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${TokenManager.getToken()}'});
  log('${response.statusCode.toString()}, ${response.body}');
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonBody = jsonDecode(response.body);
    OperationsListResponse articlesListResponse = OperationsListResponse.fromJson(jsonBody);
    List<Operation> operationsList = articlesListResponse.operations;
    return operationsList;
  } else {
    throw Exception('Failed to load operations');
  }
}

Future<List<Operation>> fetchOperationsOfBalance(http.Client client, int balance_id) async {
  log('fetch operations of balance');
  log(balance_id.toString());
  Uri url = Uri.http('localhost:8082','operations/balance',{ "id": balance_id.toString() });
  log(url.toString());
  final response = await client.get(url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer ${TokenManager.getToken()}'
    },);
  log('${response.statusCode.toString()}, ${response.body}');
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonBody = jsonDecode(response.body);
    OperationsListResponse articlesListResponse = OperationsListResponse.fromJson(jsonBody);
    List<Operation> operationsList = articlesListResponse.operations;
    return operationsList;
  } else {
    throw Exception('Failed to load operations');
  }
}

class AddOperationRequest {
  Operation operation;

  AddOperationRequest({this.operation});

  Map toJson() => {
    'operation': operation
  };
}

Future<bool> addOperation(http.Client client, AddOperationRequest request) async {
  log('add Operation');
  log(request.operation.createDate.toString());
  var data = jsonEncode(request);
  final response = await client.post(Uri.http('localhost:8082', 'operations'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${TokenManager.getToken()}'
      },
      body: data);
  log('${response.statusCode.toString()}, ${response.body}');
  return (response.statusCode == 200);
}

Future<bool> deleteOperation(http.Client client, int id) async {
  log('delete operations');
  log(id.toString());
  Uri url = Uri.http('localhost:8082','operations',{ "id": id.toString() });
  final response = await client.delete(url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer ${TokenManager.getToken()}'
    },);
  log('${response.statusCode.toString()}, ${response.body}');
  return (response.statusCode == 200);
}
