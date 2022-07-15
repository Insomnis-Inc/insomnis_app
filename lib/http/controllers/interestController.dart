import 'dart:convert';

import 'package:brokerstreet/http/models/Interest.dart';

import '../../main.dart';
import '../env.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

Dio dio = Dio();

/// ==========================================================
/// ==========================================================
/// Get Extras
/// ==========================================================
/// ==========================================================
Future<List<Interest?>> getInterests() async {
  var response = await http.get(Uri.parse('$API_URL/interests'));
  print("Interests: ${response.statusCode}");

  var jsonD = jsonDecode(response.body);
  print(jsonD.toString());

  List<Interest?> results = [];
  try {
    for (var item in jsonD['data']) {
      results.add(Interest.fromJson(
        item,
      ));
    }
  } catch (e) {
    print("Parse Error: $e");
  }
  return results;
}
