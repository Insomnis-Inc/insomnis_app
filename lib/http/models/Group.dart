import 'package:brokerstreet/http/env.dart';
import 'package:brokerstreet/http/models/UserApi.dart';

class Group {
  final String id;
  final String name;
  bool isMember;
  final String adminId;
  final String profilePic;
  final String memberCount;
  final UserApi admin;
  // final List<UserApi?> users;
  final String coverPic;
  final String createdAt;

  Group(
      {required this.id,
      required this.name,
      required this.isMember,
      required this.adminId,
      required this.memberCount,
      required this.profilePic,
      // required this.users,
      required this.coverPic,
      required this.createdAt,
      required this.admin});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
        id: json['group'][0]['id'],
        name: json['group'][0]['name'],
        adminId: json['group'][0]['admin_id'],
        createdAt: json['group'][0]['created_at'],
        coverPic: media_url + (json['group'][0]['cover_pic'] ?? ''),
        profilePic: media_url + (json['group'][0]['profile_pic'] ?? ''),
        memberCount: json['group'][0]['member_count'],
        isMember: json['is_member'].toString() == '1' ? true : false,
        admin: UserApi.fromJson(json['admin'][0]));
  }
}

class GroupTile {
  final String id;
  final String name;
  final String adminId;
  final String profilePic;
  final String memberCount;
  final String coverPic;
  final String createdAt;
  bool isMember;

  GroupTile(
      {required this.id,
      required this.name,
      required this.adminId,
      required this.isMember,
      required this.memberCount,
      required this.profilePic,
      required this.coverPic,
      required this.createdAt});

  factory GroupTile.fromJson(Map<String, dynamic> json) {
    return GroupTile(
      id: json['id'],
      name: json['name'],
      adminId: json['admin_id'],
      createdAt: json['created_at'],
      coverPic: media_url + (json['cover_pic'] ?? ''),
      profilePic: media_url + (json['profile_pic'] ?? ''),
      isMember: json['is_member'].toString() == '1' ? true : false,
      memberCount: json['member_count'],
    );
  }
}
