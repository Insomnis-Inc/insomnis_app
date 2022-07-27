// ignore_for_file: unused_import, body_might_complete_normally_nullable

import 'dart:convert';
import 'package:brokerstreet/http/models/Comment.dart';
import 'package:brokerstreet/http/models/Post.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:brokerstreet/main.dart';

import '../env.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

Dio dio = Dio();

Future<List<Comment?>> postComments(String postId) async {
  var response = await http
      .get(Uri.parse('$API_URL/posts/$postId/comments/' + await retrieveId()));
  print("User: ${response.statusCode}");

  var jsonD = jsonDecode(response.body.replaceAll('|', ''));
  print(jsonD.toString());

  List<Comment?> results = [];
  try {
    for (var item in jsonD['data']) {
      results.add(Comment.fromJson(
        item,
      ));
    }
  } catch (e) {
    print("Parse Error Zion: $e");
  }
  return results;
}

Future<List<Comment?>> commentComments(String commentId) async {
  var response = await http.get(
      Uri.parse('$API_URL/comments/$commentId/check/' + await retrieveId()));
  print("User: ${response.statusCode}");

  var jsonD = jsonDecode(response.body.replaceAll('|', ''));
  print(jsonD.toString());

  List<Comment?> results = [];
  try {
    for (var item in jsonD['data']) {
      results.add(Comment.fromJson(
        item,
      ));
    }
  } catch (e) {
    print("Parse Error Zion: $e");
  }
  return results;
}

Future<bool> commentCreate(
    {required String text, String? postId, String? commentId}) async {
  Dio dio = Dio();
  Map<String, dynamic> inputs = {
    'text': text,
    'post_id': postId,
    'comment_id': commentId
  };

  FormData formData = FormData.fromMap(inputs);

  try {
    var response = await dio.post('$API_URL/comments/' + await retrieveId(),
        data: formData);
    print("CODE: ${response.statusCode}");
    if (response.statusCode == 200) {
      // var jsonData = json.decode(response.toString().replaceAll('|', ''));
      // print(jsonData);
      return true;
    } else {
      // print("CODE: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("Error Zion: ${e.toString()}");
    return false;
  }

  // print("DATA: ${response.data}");
}

Future<bool> commentUpdate({required String text, required String id}) async {
  Dio dio = Dio();
  Map<String, dynamic> inputs = {'text': text};

  FormData formData = FormData.fromMap(inputs);

  try {
    var response =
        await dio.post('$API_URL/comments/$id/update', data: formData);
    print("CODE: ${response.statusCode}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.toString().replaceAll('|', ''));
      print(jsonData);
      return true;
    } else {
      // print("CODE: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("Error: ${e.toString()}");
    return false;
  }

  // print("DATA: ${response.data}");
}

Future<bool> commentLike(String commentId) async {
  print("comment liked");
  var response =
      await dio.get('$API_URL/comments/$commentId/like/' + await retrieveId());
  print("CODE: ${response.statusCode.toString()}");
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> commentDislike(String commentId) async {
  print("comment disliked");
  var response = await dio
      .get('$API_URL/comments/$commentId/dislike/' + await retrieveId());
  print("CODE: ${response.statusCode.toString()}");
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
