// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/http/controllers/userController.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/models/SVSearchModel.dart';
import 'package:brokerstreet/screens/fragments/SVProfileFragment.dart';
import 'package:brokerstreet/screens/search/components/SVSearchCardComponent.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

import '../search/components/SVFollowResult.dart';

class SVFollowing extends StatefulWidget {
  final String id;

  SVFollowing(this.id);
  @override
  State<SVFollowing> createState() => _SVFollowingState();
}

class _SVFollowingState extends State<SVFollowing> {
  List<SVSearchModel> list = [];
  // List<SVSearchModel> tags = [];

  late Future<List<UserApi?>> _users;
  Future<void> _onRefresh() async {
    var res = userFollowings(widget.id);
    setState(() {
      _users = res;
    });
  }

  @override
  void initState() {
    _users = userFollowings(widget.id);
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(svGetScaffoldColor());
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var v16 = width / 20;
    return Scaffold(
      backgroundColor: svGetScaffoldColor(),
      appBar: AppBar(
        backgroundColor: svGetScaffoldColor(),
        title: Text('Following', style: boldTextStyle(size: 20)),
        automaticallyImplyLeading: true,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: context.iconColor),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<UserApi?>>(
            future: _users,
            builder: (context, AsyncSnapshot<List<UserApi?>> snapshot) {
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

              if (snapshot.data == null || snapshot.data!.length == 0) {
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

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RECENT', style: boldTextStyle()).paddingAll(16),
                  ListView.separated(
                    padding: EdgeInsets.all(16),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return SVFollowResult(snapshot.data![index]!).onTap(() {
                        SVProfileFragment(snapshot.data![index]!.id)
                            .launch(context);
                      });
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(height: 20);
                    },
                    itemCount: snapshot.data!.length,
                  ),
                ],
              );
            }),
      ),
    );
  }
}
