import 'package:brokerstreet/http/env.dart';
import 'package:brokerstreet/http/models/UserApi.dart';

class Post {
  final String id;
  final String text;
  final String attached;
  final String type;
  final String comments;
  final String likes;
  final UserApi creator;
  bool liked;
  final String createdAt;
  bool saved;

  Post(
      {required this.id,
      required this.text,
      required this.type,
      required this.attached,
      required this.comments,
      required this.liked,
      required this.createdAt,
      required this.saved,
      required this.likes,
      required this.creator});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        text: json['text'] ?? '',
        type: json['type'],
        createdAt: json['created_at'],
        attached: json['attached'] ?? '',
        comments: json['comments'],
        liked: json['liked'].toString() == '1' ? true : false,
        saved: json['saved'].toString() == '1' ? true : false,
        likes: json['likes'],
        creator: UserApi.fromJson(json['creator'][0]));
  }
}
