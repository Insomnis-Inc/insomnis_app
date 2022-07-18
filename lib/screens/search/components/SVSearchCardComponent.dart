import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/models/SVSearchModel.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

class SVSearchCardComponent extends StatelessWidget {
  final UserApi element;

  SVSearchCardComponent(this.element);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CachedNetworkImage(
              imageUrl: element.avatar.validate(),
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
                    Text(element.displayname.validate(),
                        style: boldTextStyle()),
                    6.width,
                    element.verified.validate()
                        ? Image.asset('images/socialv/icons/ic_TickSquare.png',
                            height: 14, width: 14, fit: BoxFit.cover)
                        : Offstage(),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
                6.height,
                Text(element.username,
                    style: secondaryTextStyle(color: svGetBodyColor())),
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
