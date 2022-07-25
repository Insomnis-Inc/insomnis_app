// ignore_for_file: prefer_const_constructors

import 'package:brokerstreet/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:brokerstreet/utils/SVCommon.dart';
import 'package:nb_utils/nb_utils.dart';

import '../custom_colors.dart';
import '../http/controllers/userController.dart';
import 'edit_profile_menu.dart';

class MenuIndex extends StatefulWidget {
  const MenuIndex(this.myId, {Key? key}) : super(key: key);
  final String myId;
  @override
  _MenuIndexState createState() => _MenuIndexState();
}

class _MenuIndexState extends State<MenuIndex> {
  late Future<UserApi?> _user;
  late String myId;

  init() async {
    myId = widget.myId;
    _user = userProfile(myId);
  }

  @override
  void initState() {
    init();
    setStatusBarColor(Colors.transparent);
    super.initState();
  }

  Future<void> _onRefresh() async {
    var res = userProfile(myId);

    setState(() {
      _user = res;
    });
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
          "Edit Profile",
          style: normalTextStyle.copyWith(color: APP_ACCENT),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: FutureBuilder<UserApi?>(
          future: _user,
          builder: (context, AsyncSnapshot<UserApi?> snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: height * 0.7,
                width: width,
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.all(v16),
                  child: CircularProgressIndicator(
                    color: APP_ACCENT,
                  ),
                )),
              );
            }

            if (snapshot.data == null) {
              return Container(
                height: height * 0.8,
                width: width,
                child: RefreshIndicator(
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  color: APP_ACCENT,
                  onRefresh: () => _onRefresh(),
                  child: Center(
                      child: InkWell(
                          onTap: () => _onRefresh(),
                          child: Container(
                            height: 64,
                            margin: EdgeInsets.symmetric(horizontal: v16 * 4),
                            child: normalButton(
                                v16: v16,
                                bgColor: APP_ACCENT,
                                title: "refresh"),
                          ))),
                ),
              );
            }

            // return ProfilePage(
            //   snapshot.data!,
            //   mine: widget.mine,
            // );
            return EditProfileMenu(
              user: snapshot.data!,
            );
          },
        ),
      ),
    );
  }
}
