// ignore_for_file: prefer_const_constructors

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:brokerstreet/main.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/screens/fragments/SVAddPostFragment.dart';
import 'package:brokerstreet/screens/fragments/SVHomeFragment.dart';
import 'package:brokerstreet/screens/fragments/SVNotificationFragment.dart';
import 'package:brokerstreet/screens/fragments/SVProfileFragment.dart';
import 'package:brokerstreet/screens/fragments/SVSearchFragment.dart';
import 'package:brokerstreet/utils/SVCommon.dart';
import 'package:brokerstreet/main.dart';

import 'fragments/SVMessagesFragment.dart';

class SVDashboardScreen extends StatefulWidget {
  @override
  State<SVDashboardScreen> createState() => _SVDashboardScreenState();
}

class _SVDashboardScreenState extends State<SVDashboardScreen> {
  int selectedIndex = 0;
  late String myId;

  Widget getFragment() {
    if (selectedIndex == 0) {
      return SVHomeFragment();
    } else if (selectedIndex == 1) {
      return SVSearchFragment();
    } else if (selectedIndex == 2) {
      //return AddPostFragment();
    } else if (selectedIndex == 3) {
      return SVNotificationFragment();
    } else if (selectedIndex == 4) {
      return SVMessagesFragment();
    }
    return SVHomeFragment();
  }

  @override
  void initState() {
    setStatusBarColor(Colors.transparent);
    super.initState();
    init();
  }

  init() async {
    myId = await retrieveId();
    // myId = '96caac87-00e5-4e08-9742-01bbfece6093';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: svGetScaffoldColor(),
      body: getFragment(),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('images/socialv/icons/ic_Home.png',
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                    color: context.iconColor)
                .paddingTop(12),
            label: '',
            activeIcon: Image.asset('images/socialv/icons/ic_HomeSelected.png',
                    height: 24, width: 24, fit: BoxFit.cover)
                .paddingTop(12),
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/socialv/icons/ic_Search.png',
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                    color: context.iconColor)
                .paddingTop(12),
            label: '',
            activeIcon: Image.asset(
                    'images/socialv/icons/ic_SearchSelected.png',
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover)
                .paddingTop(12),
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/socialv/icons/ic_Plus.png',
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                    color: context.iconColor)
                .paddingTop(12),
            label: '',
            activeIcon: Image.asset('images/socialv/icons/ic_PlusSelected.png',
                    height: 24, width: 24, fit: BoxFit.cover)
                .paddingTop(12),
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/socialv/icons/ic_Notification.png',
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                    color: context.iconColor)
                .paddingTop(12),
            label: '',
            activeIcon: Image.asset(
                    'images/socialv/icons/ic_NotificationSelected.png',
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover)
                .paddingTop(12),
          ),
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.messageCircleOutline).paddingTop(12),
            label: '',
            activeIcon: Icon(EvaIcons.messageCircle).paddingTop(12),
          ),
        ],
        onTap: (val) {
          selectedIndex = val;
          setState(() {});
          if (val == 2) {
            selectedIndex = 0;
            setState(() {});
            SVAddPostFragment().launch(context);
          }
        },
        currentIndex: selectedIndex,
      ),
    );
  }
}
