import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/utils/SVConstants.dart';

class SVProfileHeaderComponent extends StatelessWidget {
  const SVProfileHeaderComponent(this.user, {Key? key}) : super(key: key);
  final UserApi user;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              CachedNetworkImage(
                imageUrl: user.cover,
                width: context.width(),
                height: 130,
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.asset(
                  "assets/images/avatar.png",
                  height: 56,
                  width: 56,
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ).cornerRadiusWithClipRRectOnly(
                  topLeft: SVAppCommonRadius.toInt(),
                  topRight: SVAppCommonRadius.toInt()),
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: radius(18)),
                  child: CachedNetworkImage(
                    imageUrl: user.avatar,
                    height: 88,
                    width: 88,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                      "assets/images/avatar.png",
                      height: 56,
                      width: 56,
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ).cornerRadiusWithClipRRect(SVAppCommonRadius),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
