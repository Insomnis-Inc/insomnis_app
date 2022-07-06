import 'package:flutter/material.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/models/SVSearchModel.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

class SVFollowResult extends StatelessWidget {
  final UserApi element;

  SVFollowResult(this.element);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.network(element.avatar,
                    height: 56, width: 56, fit: BoxFit.cover)
                .cornerRadiusWithClipRRect(8),
            20.width,
            Column(
              children: [
                Row(
                  children: [
                    Text(element.username, style: boldTextStyle()),
                    6.width,
                    element.verified
                        ? Image.asset('images/socialv/icons/ic_TickSquare.png',
                            height: 14, width: 14, fit: BoxFit.cover)
                        : Offstage(),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
                6.height,
                Text(element.isFollowing ? "Follows you" : "Doesn't follow you",
                    style: secondaryTextStyle(color: svGetBodyColor())),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ],
        ),
        Image.asset(
          'images/socialv/icons/ic_CloseSquare.png',
          height: 20,
          width: 20,
          fit: BoxFit.cover,
          color: context.iconColor,
        ),
      ],
    );
  }
}
