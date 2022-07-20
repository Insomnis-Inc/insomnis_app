import 'dart:convert';

import 'package:brokerstreet/http/models/Post.dart';

import '../../main.dart';
import '../env.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

Dio dio = Dio();

/// ==========================================================
/// ==========================================================
/// Search Saved Posts
/// ==========================================================
/// ==========================================================

Future<List<Post?>> searchSavedPosts({required String term}) async {
  var response = await http
      .get(Uri.parse('$API_URL/search/$term/saved/' + await retrieveId()));
  print("Search Saveds: ${response.statusCode}");

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
/// Get Saved Posts
/// ==========================================================
/// ==========================================================
Future<List<Post?>> getSavedPosts() async {
  var response = await http
      .get(Uri.parse('$API_URL/users/' + await retrieveId() + '/savedposts'));
  print("Saved Posts: ${response.statusCode}");

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

Future<bool> savePost(String postId) async {
  var response = await dio
      .get('$API_URL/users/' + await retrieveId() + '/posts/$postId/save');
  print("SAVE POST: ${response.statusCode.toString()}");
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> unsavePost(String postId) async {
  var response = await dio
      .get('$API_URL/users/' + await retrieveId() + '/posts/$postId/unsave');
  print("UNSAVE POST: ${response.statusCode.toString()}");
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
