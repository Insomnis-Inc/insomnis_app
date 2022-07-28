import 'package:brokerstreet/http/env.dart';

class UserApi {
  final String id;
  final String email;
  final String username;
  final String displayname;
  final String avatar;
  final String cover;
  // final String url;
  // final bool active;
  final String postCount;
  final String followersCount;
  final String followingCount;
  // final String mutualFriends;
  // final String likesCount;
  final bool canFollow;
  final bool isFollowingMe;
  final bool isFollowing;
  final bool verified;
  final String? address;
  final String? bio;

  UserApi(
      {required this.id,
      required this.email,
      required this.username,
      required this.displayname,
      required this.avatar,
      required this.cover,
      // required this.url,
      // required this.active,
      required this.postCount,
      required this.followersCount,
      required this.followingCount,
      required this.bio,
      required this.address,
      // required this.mutualFriends,
      // required this.likesCount,
      required this.canFollow,
      required this.verified,
      required this.isFollowingMe,
      required this.isFollowing});

  factory UserApi.fromJson(Map<String, dynamic> json) {
    return UserApi(
        id: json['id'],
        email: json['email'],
        username: json['username'],
        displayname: json['display_name'],
        avatar: json['profile_pic'],
        cover: json['cover_pic'],
        // url: json['url'],
        // active: json['active'] == '1' ? true : false,
        verified: json['verified'].toString() == '1' ? true : false,
        postCount: json['post_count'] ?? '1',
        followersCount: json['followers'].toString(),
        followingCount: json['following'].toString(),
        bio: json['bio'],
        address: json['address'],
        // mutualFriends: json['details']['mutual_friends_count'].toString(),
        // likesCount: json['details']['likes_count'],
        canFollow: json['you_follow'].toString() == '1' ? false : true,
        isFollowingMe: json['is_following_me'].toString() == '1' ? true : false,
        isFollowing: json['you_follow'].toString() == '1' ? true : false);
  }
}
