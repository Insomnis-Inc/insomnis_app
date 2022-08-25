import 'dart:convert';
import 'package:brokerstreet/http/models/Post.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:brokerstreet/main.dart';

import '../env.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../models/NotificationApi.dart';

Dio dio = Dio();

Future<List<NotificationApi?>> notifications() async {
  var response =
      await http.get(Uri.parse('$API_URL/notifications/' + await retrieveId()));
  print("User: ${response.statusCode}");

  var jsonD = jsonDecode(response.body.replaceAll('|', ''));
  print(jsonD.toString());

  List<NotificationApi?> results = [];
  try {
    for (var item in jsonD['data']) {
      results.add(NotificationApi.fromJson(
        item,
      ));
    }
  } catch (e) {
    print("Parse Error: $e");
  }
  return results;
}
