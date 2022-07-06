// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/main.dart';
import 'package:brokerstreet/utils/SVCommon.dart';
import '../../custom_colors.dart';
import '../../http/controllers/userController.dart';
import '../../utils/SVColors.dart';
import 'profilePage.dart';

class SVProfileFragment extends StatefulWidget {
  const SVProfileFragment(this.id, {Key? key, this.mine = false})
      : super(key: key);
  final bool mine;
  final String id;
  @override
  State<SVProfileFragment> createState() => _SVProfileFragmentState();
}

class _SVProfileFragmentState extends State<SVProfileFragment> {
  late Future<UserApi?> _user;

  @override
  void initState() {
    _user = userProfile(widget.id);
    setStatusBarColor(Colors.transparent);
    super.initState();
  }

  Future<void> _onRefresh() async {
    var res = userProfile(widget.id);
    print(widget.id);
    setState(() {
      _user = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var v16 = width / 20;
    return Observer(
      builder: (_) => Scaffold(
        backgroundColor: svGetScaffoldColor(),
        appBar: AppBar(
          backgroundColor: svGetScaffoldColor(),
          title: Text('Profile', style: boldTextStyle(size: 20)),
          automaticallyImplyLeading: true,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: context.iconColor),
          actions: [
            if (widget.mine)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    appStore.isDarkMode
                        ? EvaIcons.sunOutline
                        : EvaIcons.moonOutline,
                    color: APP_ACCENT,
                  ),
                  Switch(
                    onChanged: (val) {
                      appStore.toggleDarkMode(value: val);
                      saveDarkMode(val);
                    },
                    value: appStore.isDarkMode,
                    activeColor: SVAppColorPrimary,
                  ),
                ],
              ),
            //IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
          ],
        ),
        body: SingleChildScrollView(
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

              return ProfilePage(
                snapshot.data!,
                mine: widget.mine,
              );
            },
          ),
        ),
      ),
    );
  }
}
