// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:brokerstreet/screens/SVDashboardScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/http/controllers/userController.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:brokerstreet/screens/SVSplashScreen.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

import '../../main.dart';
import '../toast.dart';

class EditNameBioLocation extends StatefulWidget {
  final UserApi user;
  const EditNameBioLocation({Key? key, required this.user}) : super(key: key);

  @override
  _EditNameBioLocationState createState() => _EditNameBioLocationState();
}

class _EditNameBioLocationState extends State<EditNameBioLocation> {
  late TextEditingController _bioController,
      _usernameController,
      _addressController;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() {
    _bioController = TextEditingController(text: widget.user.bio);
    _addressController = TextEditingController(text: widget.user.address);
    _usernameController = TextEditingController(text: widget.user.username);
  }

  onSent() async {
    String bio = _bioController.text.trim();
    String username = _usernameController.text.trim();
    String address = _addressController.text.trim();

    showToast("Updating ", context);

    userNameBioLocation(name: username, address: address, bio: bio)
        .then((value) {
      if (value) {
        showSuccessToast("Profile Updated Successfully", context);
      } else {
        showErrorToast(
            "Error updating profile, check your connection", context);
      }
    });
    await Future.delayed(Duration(seconds: 3));
    // Navigator.of(context).popUntil(ModalRoute.withName("/edit_product"));
    // Navigator.pop(context);
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => SVDashboardScreen()));
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
          "Edit Personal Details",
          style: normalTextStyle.copyWith(color: APP_ACCENT),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: ListView(
          padding: EdgeInsets.all(v16),
          children: <Widget>[
            Container(
              child: Text(
                "Username",
                style: normalTextStyle,
              ),
            ),
            Container(
              child: TextField(
                controller: _usernameController,
                autofocus: false,
                decoration: InputDecoration(
                    focusColor: APP_PRIMARY,
                    prefixIcon: Icon(Icons.account_circle_outlined),
                    border: OutlineInputBorder(
                      gapPadding: 2,
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    )),
              ),
            ),

            Container(
              padding: EdgeInsets.only(top: v16),
              child: Text(
                "Address",
                style: normalTextStyle,
              ),
            ),
            Container(
              child: TextField(
                controller: _addressController,
                maxLines: 3,
                autofocus: false,
                decoration: InputDecoration(
                    focusColor: APP_PRIMARY,
                    hintText: "Enter your location",
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      gapPadding: 2,
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    )),
              ),
            ),
            // Container(
            //   padding: EdgeInsets.only(top: v16),
            //   child: Text(
            //     "Bio",
            //     style: normalTextStyle,
            //   ),
            // ),
            // Container(
            //   child: TextField(
            //     controller: _bioController,
            //     maxLines: 3,
            //     autofocus: false,
            //     decoration: InputDecoration(
            //         focusColor: APP_PRIMARY,
            //         // hintText: "Outline what you sell in less than 3 lines",
            //         prefixIcon: Icon(Icons.store),
            //         border: OutlineInputBorder(
            //           gapPadding: 2,
            //           borderSide: BorderSide(color: Colors.black, width: 2),
            //         )),
            //   ),
            // ),
            InkWell(
              onTap: () => onSent(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: normalButton(
                    v16: v16, bgColor: APP_ACCENT, title: "upload"),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: InkWell(
      //   onTap: () => onSent(),
      //   child: Container(
      //     height: 64,
      //     width: v16 * 7,
      //     child: normalButton(v16: v16, bgColor: APP_ACCENT, title: "upload"),
      //   ),
      // ),
    );
  }
}
