import 'package:brokerstreet/http/env.dart';
import 'package:brokerstreet/http/models/UserApi.dart';

class Group {
  final String id;
  final String name;
  bool isAdmin;
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
      required this.isAdmin,
      required this.adminId,
      required this.memberCount,
      required this.profilePic,
      // required this.users,
      required this.coverPic,
      required this.createdAt,
      required this.admin});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
        id: json['group']['id'],
        name: json['group']['name'],
        adminId: json['group']['admin_id'],
        createdAt: json['group']['created_at'],
        coverPic: media_url + (json['group']['cover_pic'] ?? ''),
        profilePic: media_url + (json['group']['profile_pic'] ?? ''),
        memberCount: json['group']['member_count'],
        isAdmin: json['is_admin'].toString() == '1' ? true : false,
        admin: UserApi.fromJson(json['admin']));
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

  GroupTile(
      {required this.id,
      required this.name,
      required this.adminId,
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
      memberCount: json['member_count'],
    );
  }
}
