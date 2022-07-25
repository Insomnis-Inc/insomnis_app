import 'package:brokerstreet/http/models/Group.dart';
import 'package:brokerstreet/screens/fragments/groupCreate.dart';
import 'package:brokerstreet/utils/SVCommon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../custom_colors.dart';
import '../../http/controllers/groupController.dart';
import '../profile/screens/SVGroupProfileScreen.dart';

class GroupList extends StatefulWidget {
  const GroupList({Key? key}) : super(key: key);

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList>
    with AutomaticKeepAliveClientMixin {
  late Future<List<GroupTile?>> _groups, _allgroups;
  Future<void> _onRefresh() async {
    var res = userGroups();
    setState(() {
      _groups = res;
    });
  }

  Future<void> _onRefreshAll() async {
    var res = allGroups();
    setState(() {
      _allgroups = res;
    });
  }

  @override
  void initState() {
    _groups = userGroups();
    _allgroups = allGroups();
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(svGetScaffoldColor());
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double v16 = width / 20;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: context.cardColor,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          bottom: TabBar(
            isScrollable: true,
            labelColor: APP_ACCENT,
            unselectedLabelColor: APP_GREY,
            tabs: [
              Tab(
                text: "My Groups",
              ),
              Tab(
                text: "All Groups",
              ),
            ],
          ),
          title: const Text(
            'Groups',
            style: TextStyle(color: APP_ACCENT),
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder<List<GroupTile?>>(
                future: _groups,
                builder: (context, AsyncSnapshot<List<GroupTile?>> snapshot) {
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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('RECENT', style: boldTextStyle()).paddingAll(16),
                      ListView.separated(
                        padding: EdgeInsets.all(16),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GroupCardComponent(snapshot.data![index]!)
                              .onTap(() {
                            SVGroupProfileScreen(snapshot.data![index]!.id)
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
            FutureBuilder<List<GroupTile?>>(
                future: _allgroups,
                builder: (context, AsyncSnapshot<List<GroupTile?>> snapshot) {
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
                        onRefresh: () => _onRefreshAll(),
                        child: Center(
                            child: InkWell(
                                onTap: () => _onRefreshAll(),
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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('RECENT', style: boldTextStyle()).paddingAll(16),
                      ListView.separated(
                        padding: EdgeInsets.all(16),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GroupCardComponent(snapshot.data![index]!)
                              .onTap(() {
                            SVGroupProfileScreen(snapshot.data![index]!.id)
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: APP_ACCENT,
            onPressed: () => navigatePage(context, className: GroupCreate()),
            child: Icon(EvaIcons.edit2Outline, color: svGetScaffoldColor())),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class GroupCardComponent extends StatelessWidget {
  final GroupTile element;

  GroupCardComponent(this.element);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CachedNetworkImage(
              imageUrl: element.profilePic.validate(),
              height: 56,
              width: 56,
              fit: BoxFit.cover,
              placeholder: (context, url) => Image.asset(
                "assets/images/avatar.png",
                height: 56,
                width: 56,
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ).cornerRadiusWithClipRRect(8),
            20.width,
            Column(
              children: [
                Row(
                  children: [
                    Text(element.name.validate(), style: boldTextStyle()),
                    6.width,
                    // element.verified.validate()
                    //     ? Image.asset('images/socialv/icons/ic_TickSquare.png',
                    //         height: 14, width: 14, fit: BoxFit.cover)
                    //     : Offstage(),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
                6.height,
                // Text(element.username,
                //     style: secondaryTextStyle(color: svGetBodyColor())),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ],
        ),
        // Image.asset(
        //   'images/socialv/icons/ic_CloseSquare.png',
        //   height: 20,
        //   width: 20,
        //   fit: BoxFit.cover,
        //   color: context.iconColor,
        // ),
      ],
    );
  }
}
