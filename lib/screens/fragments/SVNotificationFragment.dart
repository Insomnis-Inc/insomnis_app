// ignore_for_file: prefer_const_constructors, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/screens/fragments/SVProfileFragment.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/models/SVNotificationModel.dart';
import 'package:brokerstreet/screens/notification/components/SVBirthdayNotificationComponent.dart';
import 'package:brokerstreet/screens/notification/components/SVLikeNotificationComponent.dart';
import 'package:brokerstreet/screens/notification/components/SVNewPostNotificationComponent.dart';
import 'package:brokerstreet/screens/notification/components/SVRequestNotificationComponent.dart';
import 'package:brokerstreet/utils/SVCommon.dart';
import 'package:brokerstreet/utils/SVConstants.dart';

import '../../http/controllers/notificationController.dart';
import '../../http/models/NotificationApi.dart';
import '../notification/components/NotificationComponent.dart';

class SVNotificationFragment extends StatefulWidget {
  @override
  State<SVNotificationFragment> createState() => _SVNotificationFragmentState();
}

class _SVNotificationFragmentState extends State<SVNotificationFragment> {
  List<SVNotificationModel> listToday = getNotificationsToday();
  List<SVNotificationModel> listMonth = getNotificationsThisMonth();
  List<SVNotificationModel> listEarlier = getNotificationsEarlier();

  Widget getNotificationComponent(
      {String? type, required SVNotificationModel element}) {
    if (type == SVNotificationType.like) {
      return SVLikeNotificationComponent(element: element);
    } else if (type == SVNotificationType.request) {
      return SVRequestNotificationComponent(element: element);
    } else if (type == SVNotificationType.newPost) {
      return SVNewPostNotificationComponent(element: element);
    } else {
      return SVBirthdayNotificationComponent(element: element);
    }
  }

  late Future<List<NotificationApi?>> _notifications;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _onRefresh() async {
    var res = notifications();
    setState(() {
      _notifications = res;
    });
  }

  @override
  void initState() {
    super.initState();

    _notifications = notifications();
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
        iconTheme: IconThemeData(color: context.iconColor),
        title: Text('Notification', style: boldTextStyle(size: 20)),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('RECENT', style: boldTextStyle()).paddingAll(16),
            Divider(height: 0, indent: 16, endIndent: 16),
            Container(
              padding: EdgeInsets.all(v16),
              child: Text(
                'No notifications yet',
                style: TextStyle(color: APP_ACCENT),
              ),
            ),
            FutureBuilder<List<NotificationApi?>>(
              future: _notifications,
              builder:
                  (context, AsyncSnapshot<List<NotificationApi?>> snapshot) {
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
                  );
                }

                return Column(
                  children: snapshot.data!.map((e) {
                    return NotificationComponent(e!).onTap(() {
                      if (e.type == 'following') {
                        navigatePage(context,
                            className: SVProfileFragment(e.notifier!.id));
                      }
                    });
                  }).toList(),
                );
              },
            ),
            // Column(
            //   children: listToday.map((e) {
            //     return getNotificationComponent(
            //         type: e.notificationType, element: e);
            //   }).toList(),
            // ),
            // Text('THIS MONTH', style: boldTextStyle()).paddingAll(16),
            // Divider(height: 0, indent: 16, endIndent: 16),
            // Column(
            //   children: listMonth.map((e) {
            //     return getNotificationComponent(
            //         type: e.notificationType, element: e);
            //   }).toList(),
            // ),
            // Text('Earlier', style: boldTextStyle()).paddingAll(16),
            // Divider(height: 0, indent: 16, endIndent: 16),
            // Column(
            //   children: listEarlier.map((e) {
            //     return getNotificationComponent(
            //         type: e.notificationType, element: e);
            //   }).toList(),
            // ),
            // 16.height,
          ],
        ),
      ),
    );
  }
}
