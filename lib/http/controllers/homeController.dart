import 'dart:convert';
import 'package:brokerstreet/http/models/Post.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:brokerstreet/main.dart';

import '../env.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

Dio dio = Dio();

Future<List<Post?>> timelinePosts() async {
  var response =
      await http.get(Uri.parse('$API_URL/timeline/' + await retrieveId()));
  print("User: ${response.statusCode}");

  var jsonD = jsonDecode(response.body.replaceAll('|', ''));
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

Future<List<Post?>> barPosts() async {
  var response =
      await http.get(Uri.parse('$API_URL/bars/' + await retrieveId()));
  print("User: ${response.statusCode}");

  var jsonD = jsonDecode(response.body.replaceAll('|', ''));
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

Future<List<Post?>> resPosts() async {
  var response =
      await http.get(Uri.parse('$API_URL/restaurants/' + await retrieveId()));
  print("User: ${response.statusCode}");

  var jsonD = jsonDecode(response.body.replaceAll('|', ''));
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

Future<List<Post?>> trendingPosts() async {
  var response =
      await http.get(Uri.parse('$API_URL/trending/' + await retrieveId()));
  print("User: ${response.statusCode}");

  var jsonD = jsonDecode(response.body.replaceAll('|', ''));
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
