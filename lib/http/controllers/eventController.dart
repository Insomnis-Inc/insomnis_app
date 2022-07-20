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

Future<bool> eventCreate(
    {required String type,
    required String text,
    required String eventType,
    File? attached}) async {
  Dio dio = Dio();
  Map<String, dynamic> inputs = {
    'text': text,
    'event_type': eventType,
    'attached':
        attached != null ? await MultipartFile.fromFile(attached.path) : '',
    'type': type
  };

  FormData formData = FormData.fromMap(inputs);

  try {
    var response =
        await dio.post('$API_URL/events/' + await retrieveId(), data: formData);
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

Future<bool> eventDelete(String postId) async {
  Dio dio = Dio();

  try {
    var response = await dio.get('$API_URL/events/$postId/delete');
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

Future<List<Post?>> events() async {
  var response =
      await http.get(Uri.parse('$API_URL/events/' + await retrieveId()));
  print("User: ${response.statusCode}");

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

List<String> getEvents() {
  return ['Clubs', 'Concerts', 'Sports', 'Trips'];
  //  'Apartments & Hotels'
}

Future<List<Post?>> eventsType(String eventType) async {
  var response = await http.get(Uri.parse(
      '$API_URL/events/' + await retrieveId() + '/type/' + eventType));
  print("Event type: ${response.statusCode}");

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
