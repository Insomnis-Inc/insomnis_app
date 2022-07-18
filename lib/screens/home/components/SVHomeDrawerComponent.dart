// ignore_for_file: prefer_const_constructors

import 'package:brokerstreet/auth/intro.dart';
import 'package:brokerstreet/screens/fragments/ExtraPosts.dart';
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

import '../../../http/models/Extra.dart';
import '../../auth/screens/SVSignInScreen.dart';

class SVHomeDrawerComponent extends StatefulWidget {
  @override
  State<SVHomeDrawerComponent> createState() => _SVHomeDrawerComponentState();
}

class _SVHomeDrawerComponentState extends State<SVHomeDrawerComponent> {
  List<Extra> options = getDrawerOptions();

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

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        8.height,
        Image.asset('images/socialv/backgroundImage.png',
            height: 136, width: context.width()),
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
        // 0.height,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((e) {
            int index = options.indexOf(e);
            return SettingItemWidget(
              decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? SVAppColorPrimary.withAlpha(30)
                      : context.cardColor),
              title: e.name.validate(),
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
                  logOutCustom(context);
                  navigatePage(context, className: IntroPage());
                } else if (selectedIndex == 0) {
                  finish(context);
                  const EventsPage().launch(context);
                } else if (selectedIndex == 1) {
                  finish(context);
                  SVGroupProfileScreen().launch(context);
                  // MenuIndex(id).launch(context);
                } else if (selectedIndex > 1) {
                  finish(context);
                  ExtraPosts(title: e.name!, extraId: e.id ?? 'non')
                      .launch(context);
                }
              },
            );
          }).toList(),
        ),
        // const Divider(indent: 16, endIndent: 16),
        // SnapHelperWidget<PackageInfo>(
        //   future: PackageInfo.fromPlatform(),
        //   onSuccess: (data) =>
        //       Text(data.version, style: boldTextStyle(color: svGetBodyColor())),
        // ),
        16.height,
      ],
    );
  }
}
