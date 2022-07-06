// ignore_for_file: prefer_const_constructors, prefer_final_fields, sized_box_for_whitespace, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/http/controllers/postController.dart';
import 'package:brokerstreet/http/controllers/userController.dart';
import 'package:brokerstreet/http/models/Post.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:brokerstreet/main.dart';
import 'package:brokerstreet/screens/fragments/SVFollowers.dart';
import 'package:brokerstreet/toast.dart';
import 'package:brokerstreet/utils/SVColors.dart';
import 'package:brokerstreet/utils/SVCommon.dart';
import 'package:brokerstreet/utils/SVConstants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../home/components/SVPostComponent.dart';
import '../home/components/SVStoryComponent.dart';
import '../profile/components/SVProfileHeaderComponent.dart';
import 'SVFollowing.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(this.user, {Key? key, this.mine = false}) : super(key: key);
  final UserApi user;
  final bool mine;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  bool isFollowing = false;
  late UserApi user;
  late TabController _tabController;
  late Future<List<Post?>> _posts;
  late Future<List<Post?>> _likedPosts;
  late String myId;

  Future<void> _onRefresh() async {
    var res = userPosts(user.id);
    setState(() {
      _posts = res;
    });
  }

  Future<void> _onRefresh2() async {
    var res = userPosts(user.id);
    setState(() {
      _likedPosts = res;
    });
  }

  @override
  void initState() {
    user = widget.user;
    _tabController = TabController(length: 2, vsync: this);
    _posts = userPosts(user.id);
    _likedPosts = userLikedPosts(user.id);
    init();
    super.initState();
  }

  init() async {
    myId = await retrieveId();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var v16 = width / 20;
    return Column(
      children: [
        SVProfileHeaderComponent(user),
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user.username, style: boldTextStyle(size: 20)),
            4.width,
            if (user.verified)
              Image.asset('images/socialv/icons/ic_TickSquare.png',
                  height: 14, width: 14, fit: BoxFit.cover),
          ],
        ),
        if (user.address != null)
          Text(user.address!,
              style: secondaryTextStyle(color: svGetBodyColor())),
        16.height,
        if (user.bio != null)
          Text(user.bio!, style: secondaryTextStyle(color: svGetBodyColor())),
        if (user.bio != null) 16.height,
        if (!widget.mine)
          AppButton(
            shapeBorder: RoundedRectangleBorder(
                borderRadius: radius(4),
                side: BorderSide(color: SVAppColorPrimary)),
            text: isFollowing ? 'Following' : 'Follow',
            textStyle: boldTextStyle(
                color: isFollowing ? Colors.white : SVAppColorPrimary),
            onTap: () async {
              bool res = isFollowing;
              setState(() {
                isFollowing = !isFollowing;
              });
              if (res) {
                await userUnfollow(id: user.id);
              } else {
                await userFollow(id: user.id);
              }
            },
            elevation: 0,
            color: isFollowing ? SVAppColorPrimary : svGetScaffoldColor(),
          ),
        if (!widget.mine) 24.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Column(
            //   children: [
            //     Text('Posts',
            //         style:
            //             secondaryTextStyle(color: svGetBodyColor(), size: 12)),
            //     4.height,
            //     Text(user.postCount, style: boldTextStyle(size: 18)),
            //   ],
            // ),
            Column(
              children: [
                Text('Followers',
                    style:
                        secondaryTextStyle(color: svGetBodyColor(), size: 12)),
                4.height,
                Text(user.followersCount, style: boldTextStyle(size: 18)),
              ],
            ).onTap(() {
              navigatePage(context, className: SVFollowers(user.id));
            }),
            Column(
              children: [
                Text('Following',
                    style:
                        secondaryTextStyle(color: svGetBodyColor(), size: 12)),
                4.height,
                Text(user.followingCount, style: boldTextStyle(size: 18)),
              ],
            ).onTap(() {
              navigatePage(context, className: SVFollowing(user.id));
            })
          ],
        ),
        16.height,
        // if (widget.mine)
        //   Container(
        //     margin: EdgeInsets.all(16),
        //     decoration: BoxDecoration(
        //         color: context.cardColor,
        //         borderRadius: radius(SVAppCommonRadius)),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         16.height,
        //         Text('Your Stories', style: boldTextStyle(size: 14))
        //             .paddingSymmetric(horizontal: 16),
        //         SVStoryComponent(),
        //       ],
        //     ),
        //   ),
        // if (widget.mine) 16.height,
        // SVProfilePostsComponent(),

        TabBar(
          controller: _tabController,
          labelColor: APP_ACCENT,
          indicatorColor: APP_ACCENT,
          unselectedLabelColor: APP_GREY,
          // ignore: prefer_const_literals_to_create_immutables
          tabs: [
            Tab(
              text: widget.mine ? "My Posts" : "Posts",
            ),
            Tab(
              text: "Liked Posts",
            ),
          ],
        ),
        Container(
          width: width,
          height: height * 0.7,
          child: TabBarView(
            controller: _tabController,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
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
                      child: RefreshIndicator(
                        triggerMode: RefreshIndicatorTriggerMode.anywhere,
                        color: APP_ACCENT,
                        onRefresh: () => _onRefresh(),
                        child: Center(
                            child: InkWell(
                                onTap: () => _onRefresh(),
                                child: Container(
                                  height: 64,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: v16 * 4),
                                  child: normalButton(
                                      v16: v16,
                                      bgColor: APP_ACCENT,
                                      title: "refresh"),
                                ))),
                      ),
                    );
                  }

                  return ListView(
                    children: [
                      SVPostComponent(snapshot.data!, myId),
                    ],
                  );
                },
              ),
              FutureBuilder<List<Post?>>(
                future: _likedPosts,
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
                      child: RefreshIndicator(
                        triggerMode: RefreshIndicatorTriggerMode.anywhere,
                        color: APP_ACCENT,
                        onRefresh: () => _onRefresh2(),
                        child: Center(
                            child: InkWell(
                                onTap: () => _onRefresh2(),
                                child: Container(
                                  height: 64,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: v16 * 4),
                                  child: normalButton(
                                      v16: v16,
                                      bgColor: APP_ACCENT,
                                      title: "refresh"),
                                ))),
                      ),
                    );
                  }

                  return ListView(
                    children: [
                      SVPostComponent(snapshot.data!, myId),
                    ],
                  );
                },
              ),
            ],
          ),
        ),

        // SVPostComponent(),
        // 16.height,
      ],
    );
  }
}
