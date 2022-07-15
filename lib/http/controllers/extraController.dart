import 'dart:convert';

import 'package:brokerstreet/http/models/Extra.dart';
import 'package:brokerstreet/http/models/Post.dart';

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
Future<List<Extra?>> getExtras() async {
  var response = await http.get(Uri.parse('$API_URL/extras'));
  print("Extras: ${response.statusCode}");

  var jsonD = jsonDecode(response.body);
  print(jsonD.toString());

  List<Extra?> results = [];
  try {
    for (var item in jsonD['data']) {
      results.add(Extra.fromJson(
        item,
      ));
    }
  } catch (e) {
    print("Parse Error: $e");
  }
  return results;
}

/// ==========================================================
/// ==========================================================
/// Search Extra Posts
/// ==========================================================
/// ==========================================================

Future<List<Post?>> searchExtraPosts(
    {required String term, required String extraId}) async {
  var response = await http.get(Uri.parse(
      '$API_URL/search/$term/extras/$extraId/users/' + await retrieveId()));
  print("Search Extras: ${response.statusCode}");

  var jsonD = jsonDecode(response.body);
  print(jsonD.toString());

  List<Post?> results = [];
  try {
    for (var item in jsonD['posts']) {
      results.add(Post.fromJson(
        item,
      ));
    }
  } catch (e) {
    print("Parse Error: $e");
  }
  return results;
}

/// ==========================================================
/// ==========================================================
/// Get Extra Posts
/// ==========================================================
/// ==========================================================

Future<List<Post?>> extraPosts(String extraId) async {
  var response = await http
      .get(Uri.parse('$API_URL/extras/$extraId/users/' + await retrieveId()));
  print("Extra Posts: ${response.statusCode}");

  var jsonD = jsonDecode(response.body);
  print(jsonD.toString());

  List<Post?> results = [];
  try {
    for (var item in jsonD['data']) {
      results.add(Post.fromJson(
        item,
      ));
    }
  } catch (e) {
    print("Parse Error: $e");
  }
  return results;
}
