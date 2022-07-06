// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:brokerstreet/http/models/NotificationApi.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

class NotificationComponent extends StatelessWidget {
  final NotificationApi element;

  NotificationComponent(this.element);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(element.notifier!.avatar,
                height: 40, width: 40, fit: BoxFit.cover)
            .cornerRadiusWithClipRRect(8),
        8.width,
        Column(
          children: [
            Row(
              children: [
                Text(element.notifier!.username,
                    style: boldTextStyle(size: 14)),
                2.width,
                element.notifier!.verified
                    ? Image.asset('images/socialv/icons/ic_TickSquare.png',
                        height: 14, width: 14, fit: BoxFit.cover)
                    : Offstage(),
              ],
              mainAxisSize: MainAxisSize.min,
            ),
            6.height,
            Text(element.text,
                style: secondaryTextStyle(color: svGetBodyColor())),
            6.height,
            Text('${element.timeAgo} ago',
                style: secondaryTextStyle(color: svGetBodyColor(), size: 12)),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ],
    ).paddingAll(16).paddingAll(16);
  }
}
