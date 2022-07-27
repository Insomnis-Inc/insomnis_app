import 'package:brokerstreet/http/models/Group.dart';
import 'package:brokerstreet/screens/fragments/SVAddPostFragment.dart';
import 'package:brokerstreet/toast.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/screens/profile/components/SVProfileHeaderComponent.dart';
import 'package:brokerstreet/screens/profile/components/SVProfilePostsComponent.dart';
import 'package:brokerstreet/utils/SVColors.dart';
import 'package:brokerstreet/utils/SVCommon.dart';
import 'package:brokerstreet/utils/SVConstants.dart';

import '../../../custom_colors.dart';
import '../../../http/controllers/groupController.dart';
import '../../../http/models/Post.dart';
import '../../../main.dart';
import '../../home/components/SVPostComponent.dart';

class SVGroupProfileScreen extends StatefulWidget {
  final String groupId;
  final bool isMember;
  SVGroupProfileScreen(this.groupId, this.isMember);

  @override
  State<SVGroupProfileScreen> createState() => _SVGroupProfileScreenState();
}

class _SVGroupProfileScreenState extends State<SVGroupProfileScreen>
    with AutomaticKeepAliveClientMixin {
  late Future<Group?> _group;
  late Future<List<Post?>> _posts;
  late String myId;
  Future<void> _onRefresh() async {
    var res = singleGroup(widget.groupId);
    setState(() {
      _group = res;
    });
  }

  late bool isMember;

  init() async {
    myId = await retrieveId();
  }

  _joinOrLeaveGroup(bool _isMember) {
    setState(() {
      isMember = !_isMember;
    });
    if (_isMember) {
      leaveGroup(widget.groupId)
          .then((value) => showToast("you are out of the group", context));
    } else {
      //
      joinGroup(widget.groupId)
          .then((value) => showToast("you are in the group", context));
    }
  }

  @override
  void initState() {
    _group = singleGroup(widget.groupId);
    _posts = groupPosts(widget.groupId);
    isMember = widget.isMember;
    init();
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(svGetScaffoldColor());
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var v16 = width / 20;
    return Scaffold(
      backgroundColor: svGetScaffoldColor(),
      appBar: AppBar(
        backgroundColor: svGetScaffoldColor(),
        iconTheme: IconThemeData(color: context.iconColor),
        title: Text('Group', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        // actions: [
        //   IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
        // ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Group?>(
            future: _group,
            builder: (context, AsyncSnapshot<Group?> snapshot) {
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

              isMember = snapshot.data!.isMember;
              return Column(
                children: [
                  // SVProfileHeaderComponent(User) must,
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.data!.name, style: boldTextStyle(size: 20)),
                      4.width,
                      // Image.asset('images/socialv/icons/ic_TickSquare.png',
                      //     height: 14, width: 14, fit: BoxFit.cover),
                    ],
                  ),
                  8.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/socialv/icons/ic_GlobeAntarctic.png',
                        height: 16,
                        width: 16,
                        fit: BoxFit.cover,
                        color: context.iconColor,
                      ),
                      8.width,
                      Text('Public Group',
                          style: secondaryTextStyle(color: svGetBodyColor())),
                      18.width,
                      Image.asset(
                        'images/socialv/icons/ic_Calendar.png',
                        height: 16,
                        width: 16,
                        fit: BoxFit.cover,
                        color: context.iconColor,
                      ),
                      8.width,
                      Text(snapshot.data!.createdAt,
                          style: secondaryTextStyle(color: svGetBodyColor())),
                    ],
                  ),
                  16.height,
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: radius(SVAppCommonRadius)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        borderRadius: radius(100)),
                                    child: Image.asset(
                                            'images/socialv/faces/face_2.png',
                                            height: 32,
                                            width: 32,
                                            fit: BoxFit.cover)
                                        .cornerRadiusWithClipRRect(100),
                                  ),
                                  Positioned(
                                    left: 14,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          borderRadius: radius(100)),
                                      child: Image.asset(
                                              'images/socialv/faces/face_3.png',
                                              height: 32,
                                              width: 32,
                                              fit: BoxFit.cover)
                                          .cornerRadiusWithClipRRect(100),
                                    ),
                                  ),
                                  Positioned(
                                    left: 30,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          borderRadius: radius(100)),
                                      child: Image.asset(
                                              'images/socialv/faces/face_4.png',
                                              height: 32,
                                              width: 32,
                                              fit: BoxFit.cover)
                                          .cornerRadiusWithClipRRect(100),
                                    ),
                                  ),
                                  Positioned(
                                    left: 46,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          borderRadius: radius(100)),
                                      child: Image.asset(
                                              'images/socialv/faces/face_5.png',
                                              height: 32,
                                              width: 32,
                                              fit: BoxFit.cover)
                                          .cornerRadiusWithClipRRect(100),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          borderRadius: radius(100)),
                                      child: Image.asset(
                                              'images/socialv/faces/face_1.png',
                                              height: 32,
                                              width: 32,
                                              fit: BoxFit.cover)
                                          .cornerRadiusWithClipRRect(100),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            16.width,
                            Text('${snapshot.data!.memberCount} Members',
                                style: secondaryTextStyle(
                                    color: context.iconColor)),
                          ],
                        ),
                        28.height,
                        AppButton(
                          shapeBorder:
                              RoundedRectangleBorder(borderRadius: radius(4)),
                          text: isMember ? 'Leave Group' : 'Join Group',
                          textStyle: boldTextStyle(color: Colors.white),
                          onTap: () => _joinOrLeaveGroup(isMember),
                          elevation: 0,
                          color: SVAppColorPrimary,
                          width: context.width() - 64,
                        ),
                        10.height,
                      ],
                    ),
                  ),
                  16.height,
                  FutureBuilder<List<Post?>>(
                    future: _posts,
                    builder: (context, AsyncSnapshot<List<Post?>> snapshot) {
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

                      if (snapshot.data == null || snapshot.data?.length == 0) {
                        return Container(
                          height: height * 0.8,
                          width: width,
                          child: Center(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Nothing to show',
                                style:
                                    TextStyle(fontSize: 16, color: APP_ACCENT),
                              ).paddingOnly(bottom: 8),
                              InkWell(
                                  onTap: () => _onRefresh(),
                                  child: Container(
                                    height: 64,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: v16 * 4),
                                    child: normalButton(
                                        v16: v16 * 0.7,
                                        bgColor: APP_ACCENT,
                                        title: "refresh"),
                                  )),
                            ],
                          )),
                        );
                      }

                      return Container(
                        height: height,
                        width: width,
                        child: ListView(
                          padding: EdgeInsets.only(bottom: 144),
                          children: [
                            SVPostComponent(snapshot.data!, myId),
                          ],
                        ),
                      );
                    },
                  ),
                  16.height,
                ],
              );
            }),
      ),
      floatingActionButton: isMember
          ? FloatingActionButton(
              backgroundColor: APP_ACCENT,
              onPressed: () => navigatePage(context,
                  className: SVAddPostFragment(isGroup: true)),
              child: Icon(EvaIcons.editOutline, color: REAL_WHITE))
          : Offstage(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
