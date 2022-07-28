// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:brokerstreet/utils/SVCommon.dart';
import '../custom_colors.dart';
import 'editnamebiolocation.dart';
import 'updatePhotos.dart';

class EditProfileMenu extends StatefulWidget {
  final UserApi user;
  EditProfileMenu({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileMenuState createState() => _EditProfileMenuState();
}

class _EditProfileMenuState extends State<EditProfileMenu> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double v16 = width / 20;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: svGetScaffoldColor(),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: APP_ACCENT,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        title: Text(
          "Edit Profile",
          style: normalTextStyle.copyWith(color: APP_ACCENT),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Edit Userame"),
              onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => EditNameBioLocation(
                            user: widget.user,
                          ))),
            ),
            ListTile(
              title: Text("Edit Profile and Cover photos"),
              onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => UpdatePhotos(
                            user: widget.user,
                          ))),
            ),
          ],
        ),
      ),
    );
  }
}
