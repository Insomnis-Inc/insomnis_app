// ignore_for_file: unused_import

import 'dart:convert';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:brokerstreet/main.dart';

import '../env.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

Dio dio = Dio();

Future<List<UserApi?>> search(String term) async {
  var response = await http
      .get(Uri.parse('$API_URL/search/$term/users/' + await retrieveId()));
  print("Search: ${response.statusCode}");

  var jsonD = jsonDecode(response.body.replaceAll("|", ''));
  print(jsonD.toString());

  List<UserApi?> results = [];
  try {
    for (var item in jsonD['users']) {
      results.add(UserApi.fromJson(
        item,
      ));
    }
  } catch (e) {
    print("Parse Error: $e");
  }
  return results;
}
