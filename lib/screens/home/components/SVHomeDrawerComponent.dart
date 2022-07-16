// ignore_for_file: prefer_const_constructors

import 'package:brokerstreet/http/models/Extra.dart';
import 'package:flutter/material.dart';
import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/main.dart';
import 'package:brokerstreet/menu/menu_index.dart';
import 'package:brokerstreet/screens/EventsScreen.dart';
import 'package:brokerstreet/screens/SVSplashScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:brokerstreet/models/SVCommonModels.dart';
import 'package:brokerstreet/screens/home/screens/SVForumScreen.dart';
import 'package:brokerstreet/screens/profile/screens/SVGroupProfileScreen.dart';
import 'package:brokerstreet/utils/SVColors.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

import '../../auth/screens/SVSignInScreen.dart';

class SVHomeDrawerComponent extends StatefulWidget {
  @override
  State<SVHomeDrawerComponent> createState() => _SVHomeDrawerComponentState();
}

class _SVHomeDrawerComponentState extends State<SVHomeDrawerComponent>
    with AutomaticKeepAliveClientMixin {
  List<SVDrawerModel> options = getDrawerOptions();
  late Future<List<Extra?>> _posts;

  int selectedIndex = -1;
  late String id;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    id = await retrieveId();
  }

  Future<void> _onRefresh() async {
    // var res = userPosts(user.id);
    // setState(() {
    //   _posts = res;
    // });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var v16 = width / 20;
    super.build(context);
    return FutureBuilder<List<Extra?>>(
      future: _posts,
      builder: (context, AsyncSnapshot<List<Extra?>> snapshot) {
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
                        margin: EdgeInsets.symmetric(horizontal: v16 * 4),
                        child: normalButton(
                            v16: v16, bgColor: APP_ACCENT, title: "refresh"),
                      ))),
            ),
          );
        }

        return ListView(
          children: [
            8.height,
            Image.asset('images/socialv/backgroundImage.png',
                height: 120, width: context.width()),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Image.asset('images/socialv/faces/face_1.png',
            //                 height: 62, width: 62, fit: BoxFit.cover)
            //             .cornerRadiusWithClipRRect(8),
            //         16.width,
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Text('Mal Nurrisht', style: boldTextStyle(size: 18)),
            //             8.height,
            //             Text('malnur@gmail.com',
            //                 style: secondaryTextStyle(color: svGetBodyColor())),
            //           ],
            //         ),
            //       ],
            //     ),
            //     IconButton(
            //       icon: Image.asset('images/socialv/icons/ic_CloseSquare.png',
            //           height: 16,
            //           width: 16,
            //           fit: BoxFit.cover,
            //           color: context.iconColor),
            //       onPressed: () {
            //         finish(context);
            //       },
            //     ),
            //   ],
            // ).paddingOnly(left: 16, right: 8, bottom: 20, top: 20),
            20.height,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((e) {
                int index = options.indexOf(e);
                return SettingItemWidget(
                  decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? SVAppColorPrimary.withAlpha(30)
                          : context.cardColor),
                  title: e.title.validate(),
                  titleTextStyle: boldTextStyle(size: 14),
                  leading: Image.asset(e.image.validate(),
                      height: 22,
                      width: 22,
                      fit: BoxFit.cover,
                      color: SVAppColorPrimary),
                  onTap: () {
                    selectedIndex = index;
                    setState(() {});
                    if (selectedIndex == options.length - 1) {
                      finish(context);
                      finish(context);
                    } else if (selectedIndex == 2) {
                      // finish(context);
                      logOutCustom(context);
                      navigatePage(context, className: new SVSignInScreen());
                    } else if (selectedIndex == 0) {
                      finish(context);
                      const EventsPage().launch(context);
                    } else if (selectedIndex == 1) {
                      finish(context);
                      SVGroupProfileScreen().launch(context);
                      // MenuIndex(id).launch(context);
                    }
                  },
                );
              }).toList(),
            ).expand(),
            // const Divider(indent: 16, endIndent: 16),
            // SnapHelperWidget<PackageInfo>(
            //   future: PackageInfo.fromPlatform(),
            //   onSuccess: (data) =>
            //       Text(data.version, style: boldTextStyle(color: svGetBodyColor())),
            // ),
            20.height,
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
