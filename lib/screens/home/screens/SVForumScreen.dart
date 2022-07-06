import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/screens/home/components/SVForumRepliesComponent.dart';
import 'package:brokerstreet/screens/home/components/SVForumTopicComponent.dart';
import 'package:brokerstreet/utils/SVColors.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

import '../components/SVPostComponent.dart';

class SVForumScreen extends StatefulWidget {
  const SVForumScreen({Key? key}) : super(key: key);

  @override
  State<SVForumScreen> createState() => _SVForumScreenState();
}

class _SVForumScreenState extends State<SVForumScreen> {
  List<String> tabList = ['Home', 'Bars', 'Restaurants'];

  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
  }

  // Widget getTabContainer() {
  //   if (selectedTab == 0) {
  //     // return SVForumTopicComponent(isFavTab: false);
  //     return SVPostComponent();
  //   } else if (selectedTab == 1) {
  //     // return SVForumRepliesComponent();
  //     return SVPostComponent();
  //   } else if (selectedTab == 2) {
  //     // return Offstage();
  //     return SVPostComponent();
  //   } else
  //     // return SVForumTopicComponent(isFavTab: true);
  //     return SVPostComponent();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: svGetScaffoldColor(),
      appBar: AppBar(
        backgroundColor: svGetScaffoldColor(),
        iconTheme: IconThemeData(color: context.iconColor),
        title: Text('Insomnis', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: context.cardColor, borderRadius: radius(8)),
              child: AppTextField(
                textFieldType: TextFieldType.NAME,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Here',
                  hintStyle: secondaryTextStyle(color: svGetBodyColor()),
                  prefixIcon: Image.asset('images/socialv/icons/ic_Search.png',
                          height: 16,
                          width: 16,
                          fit: BoxFit.cover,
                          color: svGetBodyColor())
                      .paddingAll(16),
                ),
              ),
            ),
            HorizontalList(
              spacing: 0,
              padding: EdgeInsets.all(16),
              itemCount: tabList.length,
              itemBuilder: (context, index) {
                return AppButton(
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(8)),
                  text: tabList[index],
                  textStyle: boldTextStyle(
                      color: selectedTab == index
                          ? Colors.white
                          : svGetBodyColor(),
                      size: 14),
                  onTap: () {
                    selectedTab = index;
                    setState(() {});
                  },
                  elevation: 0,
                  color: selectedTab == index
                      ? SVAppColorPrimary
                      : svGetScaffoldColor(),
                );
              },
            ),
            // getTabContainer(),
            Container()
          ],
        ),
      ),
    );
  }
}
