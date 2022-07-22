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

import '../models/Group.dart';

Dio dio = Dio();

Future<List<Group?>> allGroups() async {
  var response = await http.get(Uri.parse('$API_URL/groups'));
  print("User: ${response.statusCode}");

  List<Group?> results = [];
  try {
    var jsonD = jsonDecode(response.body.replaceAll('|', ''));
    print(jsonD.toString());

    for (var item in jsonD['data']) {
      results.add(Group.fromJson(
        item,
      ));
    }
  } catch (e) {
    print("Parse Error: $e");
  }
  return results;
}

Future<List<Group?>> userGroups() async {
  var response =
      await http.get(Uri.parse('$API_URL/groups/' + await retrieveId()));
  print("User: ${response.statusCode}");

  var jsonD = jsonDecode(response.body);
  print(jsonD.toString());

  List<Group?> results = [];
  try {
    for (var item in jsonD['data']) {
      results.add(Group.fromJson(
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

Future<bool> groupDelete(String groupId) async {
  Dio dio = Dio();

  try {
    var response = await dio.get('$API_URL/groups/$groupId/delete');
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

Future<Group?> singleGroup(String groupId) async {
  var response =
      await dio.get('$API_URL/groups/$groupId/users/' + await retrieveId());

  print("User: ${response.statusCode}");

  var jsonD = jsonDecode(response.toString());
  print(jsonD.toString());

  try {
    return Group.fromJson(
      jsonD['data'],
    );
  } catch (e) {
    print("Parse Error: $e");
  }
}

Future<bool> joinGroup(String groupId) async {
  var response = await dio
      .get('$API_URL/groups/$groupId/users/' + await retrieveId() + '/add');
  print("CODE: ${response.statusCode.toString()}");
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> leaveGroup(String groupId) async {
  var response = await dio
      .get('$API_URL/groups/$groupId/users/' + await retrieveId() + '/remove');
  print("CODE: ${response.statusCode.toString()}");
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

/// create Group
Future<bool> groupCreate(
    {required String name, File? profilePic, File? coverPic}) async {
  Dio dio = Dio();
  Map<String, dynamic> inputs = {
    'name': name,
    'cover_pic':
        coverPic != null ? await MultipartFile.fromFile(coverPic.path) : '',
    'profile_pic':
        profilePic != null ? await MultipartFile.fromFile(profilePic.path) : '',
  };

  FormData formData = FormData.fromMap(inputs);

  try {
    var response =
        await dio.post('$API_URL/groups/' + await retrieveId(), data: formData);
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

/// update Group
Future<bool> groupUpdate(
    {required String name,
    required String groupId,
    File? profilePic,
    File? coverPic}) async {
  Dio dio = Dio();
  Map<String, dynamic> inputs = {
    'name': name,
    'cover_pic':
        coverPic != null ? await MultipartFile.fromFile(coverPic.path) : '',
    'profile_pic':
        profilePic != null ? await MultipartFile.fromFile(profilePic.path) : '',
  };

  FormData formData = FormData.fromMap(inputs);

  try {
    var response =
        await dio.post('$API_URL/groups/$groupId/update', data: formData);
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

/// create Group post
Future<bool> groupPostCreate(
    {required String type,
    required String text,
    required String groupId,
    File? attached}) async {
  Dio dio = Dio();
  Map<String, dynamic> inputs = {
    'text': text,
    'group_id': groupId,
    'attached':
        attached != null ? await MultipartFile.fromFile(attached.path) : '',
    'type': type
  };

  FormData formData = FormData.fromMap(inputs);

  try {
    var response = await dio.post(
        '$API_URL/groups/' + await retrieveId() + '/posts',
        data: formData);
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

/// ==========================================================
/// ==========================================================
/// Search Group Posts
/// ==========================================================
/// ==========================================================

Future<List<Post?>> searchGroupPosts(
    {required String term, required String groupId}) async {
  var response = await http.get(Uri.parse(
      '$API_URL/search/$term/groups/$groupId/users/' + await retrieveId()));
  print("Search Groups: ${response.statusCode}");

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
/// Get Group Posts
/// ==========================================================
/// ==========================================================

Future<List<Post?>> groupPosts(String groupId) async {
  var response = await http.get(Uri.parse(
      '$API_URL/groups/$groupId/users/' + await retrieveId() + '/posts'));
  print("group Posts: ${response.statusCode}");

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
