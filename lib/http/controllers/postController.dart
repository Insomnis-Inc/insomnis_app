// ignore_for_file: unused_import, body_might_complete_normally_nullable

import 'dart:convert';
import 'dart:io';
import 'package:brokerstreet/http/models/Comment.dart';
import 'package:brokerstreet/http/models/Post.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:brokerstreet/main.dart';

import '../env.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

Dio dio = Dio();

Future<List<Post?>> userPosts(String id) async {
  var response = await http.get(Uri.parse('$API_URL/posts/$id'));
  print("User: ${response.statusCode}");

  List<Post?> results = [];
  try {
    var jsonD = jsonDecode(response.body.replaceAll('|', ''));
    print(jsonD.toString());

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

Future<List<Post?>> userLikedPosts(String id) async {
  var response = await http.get(Uri.parse('$API_URL/posts/$id/liked'));
  print("User: ${response.statusCode}");

  var jsonD = jsonDecode(response.body.replaceAll('|', ''));
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

Future<bool> postCreate(
    {required String type, required String text, File? attached}) async {
  Dio _dio = Dio();
  Map<String, dynamic> inputs = {
    'text': text,
    'attached':
        attached != null ? await MultipartFile.fromFile(attached.path) : '',
    'type': type
  };
  print('test 4400');
  FormData formData = FormData.fromMap(inputs);

  try {
    var response = await _dio.post(
        '$API_URL/posts/' + await retrieveId() + '/create',
        data: formData);
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
    print("Error nana : ${e.toString()}");
    return false;
  }

  // print("DATA: ${response.data}");
}

Future<bool> postUpdate({required String text, required String postId}) async {
  Dio dio = Dio();
  Map<String, dynamic> inputs = {'text': text};

  FormData formData = FormData.fromMap(inputs);

  try {
    var response =
        await dio.post('$API_URL/posts/$postId/update', data: formData);
    print("CODE: ${response.statusCode}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.toString());
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

Future<bool> postDelete(String postId) async {
  Dio dio = Dio();

  try {
    var response = await dio.get('$API_URL/posts/$postId/delete');
    print("CODE: ${response.statusCode}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.toString());
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

Future<Post?> singlePost(
    {required String postId, required String userId}) async {
  var response = await dio.get('$API_URL/posts/$postId/show/$userId');

  print("User: ${response.statusCode}");

  var jsonD = jsonDecode(response.toString());
  print(jsonD.toString());

  try {
    return Post.fromJson(
      jsonD['data'],
    );
  } catch (e) {
    print("Parse Error: $e");
  }
}

Future<bool> postLike(String postId) async {
  var response =
      await dio.get('$API_URL/posts/$postId/like/' + await retrieveId());
  print("CODE: ${response.statusCode.toString()}");
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> postDislike(String postId) async {
  var response =
      await dio.get('$API_URL/posts/$postId/dislike/' + await retrieveId());
  print("CODE: ${response.statusCode.toString()}");
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
