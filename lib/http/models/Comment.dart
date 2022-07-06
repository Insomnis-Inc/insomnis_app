import 'package:brokerstreet/http/models/UserApi.dart';

class Comment {
  final String id;
  final String text;
  final UserApi creator;
  final String comments;
  final String likes;
  bool liked;
  final String createdAt;
  final bool isCommentReply;

  Comment(
      {required this.id,
      required this.text,
      required this.comments,
      required this.liked,
      required this.likes,
      this.isCommentReply = false,
      required this.createdAt,
      required this.creator});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'],
        text: json['text'],
        comments: json['comments'],
        createdAt: json['created_at'],
        isCommentReply: json['post_id'] == null ? true : false,
        liked: json['liked'] == '1' ? true : false,
        likes: json['likes'],
        creator: UserApi.fromJson(json['creator'][0]));
  }
}
