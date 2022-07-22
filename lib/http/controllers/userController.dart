// ignore_for_file: unused_import, body_might_complete_normally_nullable

import 'dart:convert';
import 'dart:io';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:brokerstreet/main.dart';

import '../env.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

Dio dio = Dio();

/* == SIGN UP == */
Future<bool> userSignUp({
  required String email,
  required String username,
  required String type,
}) async {
  // Dio dio = Dio();
  Map<String, String> inputs = {
    'email': email,
    'username': username,
    'type': type
  };

  FormData formData = FormData.fromMap(inputs);

  // var response = await dio.post('$API_URL/register', data: formData);
  // print("Signup CODE: ${response.toString().replaceAll("|", '')}");

  var postUri = Uri.parse("$API_URL/register");
  var request = http.MultipartRequest("POST", postUri);
  request.fields['email'] = email;
  request.fields['username'] = username;
  request.fields['type'] = type;
  // request.files.add(new http.MultipartFile.fromBytes('file', await File.fromUri("<path/to/file>").readAsBytes(), contentType: new MediaType('image', 'jpeg')))

  var response = await request.send();
  // .then((response) async {
  if (response.statusCode == 200) {
    print("Uploaded! ${response.statusCode}");
    var jsonData = json
        .decode((await response.stream.bytesToString()).replaceAll("|", ''));
    print(jsonData);
    print(jsonData['data']['id']);

    await saveId(jsonData['data']['id']);
    await saveEmail(email);
    return true;
  }
  // });

  // try {
  //   // if (response.statusCode.toString().replaceAll("|", '') == '200') {
  //   //   var jsonData = json.decode(response.toString().replaceAll("|", ''));
  //   //   print(jsonData['data']['id']);
  //   //   await saveId(jsonData['data']['id']);
  //   //   return true;
  //   // } else {
  //   //   // print("CODE: ${response.statusCode}");
  //   //   return false;
  //   // }
  //   return false;
  // } catch (e) {
  //   print("Error: ${e.toString()}");
  //   return false;
  // }
  return false;

  // print("DATA: ${response.data}");
}

/* == LOGIN == */
Future<bool> userLogIn(String email) async {
  FormData formData = FormData.fromMap({'email': email});

  var response = await dio.post('$API_URL/login', data: formData);

  // var postUri = Uri.parse("$API_URL/login");
  // var request = http.MultipartRequest("POST", postUri);
  // request.fields['email'] = email;
  // request.files.add(new http.MultipartFile.fromBytes('file', await File.fromUri("<path/to/file>").readAsBytes(), contentType: new MediaType('image', 'jpeg')))

  // var response = await request.send();
  // .then((response) async {
  if (response.statusCode == 200) {
    print("Uploaded! ${response.statusCode}");
    var jsonData = json.decode(response.toString());
    print('LOGIN ${jsonData['data']['id']}');
    await saveId(jsonData['data']['id']);

    return true;
  }
  // });

  // print("CODE: ${response.statusCode.toString().replaceAll("|", '')}");
  // if (response.statusCode.toString().replaceAll("|", '') == '200') {
  //   // print('donedd');
  //   var jsonData = json.decode(response.toString().replaceAll("|", ''));
  //   print(jsonData);

  //   // UserApi? _user;
  //   try {
  //     print(jsonData['data']['id']);
  //     await saveId(jsonData['data']['id']);
  //     return true;
  //     // _user = UserApi.fromJson(jsonData['data']);
  //   } catch (e) {
  //     print("USER: $e");
  //     // return "Wow";
  //     return false;
  //   }
  //   // return _user;
  // } else {
  //   if (response.statusCode == 404) {
  //     return false;
  //   }
  return false;
  // }
}

Future<UserApi?> userProfile(String id) async {
  print("User: here");
  var response = await http.get(Uri.parse('$API_URL/users/$id'));

  print("User: after");
  print("User: ${response.statusCode}");

  try {
    var jsonD = jsonDecode(response.body.replaceAll('|', ''));
    print(jsonD.toString());
    return UserApi.fromJson(
      jsonD['data'],
    );
  } catch (e) {
    print("Parse Error: $e");
  }
}

// ############################################################################
// ######################################## FOLLOWERS #########################
// ############################################################################

Future<List<UserApi?>> userFollowers(String id) async {
  var response = await http.get(Uri.parse('$API_URL/users/$id/followers'));

  print("User: ${response.statusCode}");

  var jsonD = jsonDecode(response.body.replaceAll('|', ''));
  print(jsonD.toString());

  List<UserApi?> results = [];
  try {
    for (var item in jsonD['data']) {
      results.add(UserApi.fromJson(
        item,
      ));
    }
  } catch (e) {
    print("Parse Error: $e");
  }
  return results;
}

Future<List<UserApi?>> userFollowings(String id) async {
  var response = await http.get(Uri.parse('$API_URL/users/$id/followings'));
  print("User: ${response.statusCode}");

  var jsonD = jsonDecode(response.body.replaceAll('|', ''));
  print(jsonD.toString());

  List<UserApi?> results = [];
  try {
    for (var item in jsonD['data']) {
      results.add(UserApi.fromJson(
        item,
      ));
    }
  } catch (e) {
    print("Parse Error: $e");
  }
  return results;
}

Future<bool> userFollow({required String id}) async {
  var response =
      await dio.get('$API_URL/users/' + await retrieveId() + '/follow/$id');
  print("CODE: ${response.statusCode.toString()}");
  if (response.statusCode == 200) {
    // print('donedd');
    var jsonData = json.decode(response.toString());
    print(jsonData);

    return true;
  } else {
    return false;
  }
}

Future<bool> userUnfollow({required String id}) async {
  var response =
      await dio.get('$API_URL/users/' + await retrieveId() + '/unfollow/$id');
  print("CODE: ${response.statusCode.toString()}");
  if (response.statusCode == 200) {
    // print('donedd');
    var jsonData = json.decode(response.toString());
    print(jsonData);

    return true;
  } else {
    return false;
  }
}

/* == NAME BIO LOCATION == */
Future<bool> userNameBioLocation({
  required String name,
  required String myId,
  required String address,
  required String bio,
}) async {
  try {
    Dio dio = new Dio();

    Map<String, dynamic> inputs = {
      'address': address,
      'bio': bio,
      'username': name
    };

    FormData formData = FormData.fromMap(inputs);

    try {
      var response =
          await dio.post('$API_URL/users/$myId/update', data: formData);
      // print("CODE: ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.toString());
        return true;
      } else {
        // print("CODE: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // print("Error: ${e.toString()}");
      return false;
    }
  } catch (e) {
    // print("ST: ${e.toString()}");
    return false;
  }

  // print("DATA: ${response.data}");
}

/* == NAME BIO LOCATION == */
Future<bool> userPhone({
  required String phone,
  required String myId,
}) async {
  try {
    Dio dio = new Dio();

    Map<String, dynamic> inputs = {
      'phone': phone,
    };

    FormData formData = FormData.fromMap(inputs);

    try {
      var response =
          await dio.post('$API_URL/users/$myId/phone', data: formData);
      // print("CODE: ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.toString());
        return true;
      } else {
        // print("CODE: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // print("Error: ${e.toString()}");
      return false;
    }
  } catch (e) {
    // print("ST: ${e.toString()}");
    return false;
  }

  // print("DATA: ${response.data}");
}

/* == NAME BIO LOCATION == */
Future<bool> userCurrency({
  required String currency,
  required String myId,
}) async {
  try {
    Dio dio = new Dio();

    Map<String, dynamic> inputs = {
      'currency': currency,
    };

    FormData formData = FormData.fromMap(inputs);

    try {
      var response =
          await dio.post('$API_URL/users/$myId/currency', data: formData);
      // print("CODE: ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.toString());
        return true;
      } else {
        // print("CODE: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // print("Error: ${e.toString()}");
      return false;
    }
  } catch (e) {
    // print("ST: ${e.toString()}");
    return false;
  }

  // print("DATA: ${response.data}");
}

/* == SIGN UP == */
Future<bool> userPhotos(
    {required String myId,
    File? coverPic,
    required bool isCover,
    File? profilePic}) async {
  try {
    Dio dio = new Dio();

    Map<String, dynamic> inputs = isCover
        ? {'cover_pic': await MultipartFile.fromFile(coverPic!.path)}
        : {'profile_pic': await MultipartFile.fromFile(profilePic!.path)};

    FormData formData = FormData.fromMap(inputs);

    try {
      var response = await dio.post(
          isCover
              ? '$API_URL/users/$myId/cover_photo'
              : '$API_URL/users/$myId/profile_photo',
          data: formData);
      // print("CODE: ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.toString());
        return true;
      } else {
        // print("CODE: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // print("Error: ${e.toString()}");
      return false;
    }
  } catch (e) {
    // print("ST: ${e.toString()}");
    return false;
  }

  // print("DATA: ${response.data}");
}
