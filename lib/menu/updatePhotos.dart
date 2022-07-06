// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brokerstreet/http/controllers/userController.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:brokerstreet/screens/SVSplashScreen.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

import '../../main.dart';
import '../custom_colors.dart';
import '../toast.dart';

class UpdatePhotos extends StatefulWidget {
  final UserApi user;
  const UpdatePhotos({Key? key, required this.user}) : super(key: key);

  @override
  _UpdatePhotosState createState() => _UpdatePhotosState();
}

class _UpdatePhotosState extends State<UpdatePhotos> {
  late File _profilePicFile, _coverPicFile;
  bool _profileUploaded = false, _coverUploaded = false;
  late String _myId;
  @override
  void initState() {
    super.initState();
    var _tokenBox = Hive.box(TokenBox);
    _myId = _tokenBox.get("id");
  }

  final ImagePicker _picker = ImagePicker();

  Future _onAddImageClick({bool isCover = false}) async {
    final XFile? imageX = await _picker.pickImage(source: ImageSource.gallery);
    File? image = File(imageX!.path);

    setState(() {
      if (isCover) {
        _coverPicFile = image;
        _coverUploaded = true;
      } else {
        _profilePicFile = image;
        _profileUploaded = true;
      }
    });
  }

  onSent() async {
    showToast("Updating ", context);
    if (_coverUploaded) {
      userPhotos(coverPic: _coverPicFile, isCover: true, myId: _myId)
          .then((value) {
        if (value) {
          showSuccessToast("Cover Photo Updated Successfully", context);
        } else {
          showErrorToast(
              "Error updating cover photo, check your connection", context);
        }
      });
    }

    if (_profileUploaded) {
      userPhotos(isCover: false, profilePic: _profilePicFile, myId: _myId)
          .then((value) {
        if (value) {
          showSuccessToast("Profile Photo Updated Successfully", context);
        } else {
          showErrorToast(
              "Error updating profile photo, check your connection", context);
        }
      });
    }
    // Navigator.pop(context);
    await Future.delayed(Duration(seconds: 3));

    navigatePage(context, className: SVSplashScreen());
  }

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
          "Edit Photos",
          style: normalTextStyle.copyWith(color: APP_ACCENT),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: ListView(
          padding: EdgeInsets.only(top: v16 * 1.4, left: v16, right: v16),
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: v16 * 1.5),
              child: Text(
                "Upload cover and profile photos",
                style: titleTextStyle,
              ),
            ),
            Container(
              height: height / 2.6,
              child: Stack(
                children: <Widget>[
                  InkWell(
                    onTap: () => _onAddImageClick(isCover: true),
                    child: Container(
                      width: double.maxFinite,
                      height: height / 4,
                      decoration: BoxDecoration(
                        color: SHIMMER_DARK,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _coverUploaded
                            ? Image.file(
                                _coverPicFile,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                widget.user.cover,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: v16 * 3,
                    left: width / 3.6,
                    child: InkWell(
                      onTap: () => _onAddImageClick(),
                      child: CircleAvatar(
                        backgroundColor: SCAFFOLD_BG,
                        radius: (v16 * 2.8) + 3,
                        child: CircleAvatar(
                          backgroundColor: SHIMMER_DARK,
                          radius: v16 * 2.8,
                          backgroundImage: _profileUploaded
                              ? FileImage(_profilePicFile)
                              : NetworkImage(widget.user.avatar)
                                  as ImageProvider,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: v16 * 0.5,
                    left: width / 3.8,
                    child: Text(
                      "Tap on the image",
                      style: normalTextStyle,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () => onSent(),
        child: Container(
          height: 50,
          width: v16 * 7,
          child: normalButton(v16: v16, bgColor: APP_ACCENT, title: "Done"),
        ),
      ),
    );
  }
}
