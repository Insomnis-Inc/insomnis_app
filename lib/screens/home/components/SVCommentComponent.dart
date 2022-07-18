// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:brokerstreet/http/controllers/commentsController.dart';
import 'package:brokerstreet/http/models/Comment.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/models/SVCommentModel.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

class SVCommentComponent extends StatefulWidget {
  final Comment comment;

  SVCommentComponent(this.comment);

  @override
  State<SVCommentComponent> createState() => _SVCommentComponentState();
}

class _SVCommentComponentState extends State<SVCommentComponent> {
  late int _likesQ;
  @override
  void initState() {
    _likesQ = int.parse(widget.comment.likes).validate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.comment.creator.avatar.validate(),
                  height: 48,
                  width: 48,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                    "assets/images/avatar.png",
                    height: 56,
                    width: 56,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ).cornerRadiusWithClipRRect(8),
                16.width,
                Text(widget.comment.creator.displayname.validate(),
                    style: boldTextStyle(size: 14)),
                4.width,
                if (widget.comment.creator.verified.validate())
                  Image.asset('images/socialv/icons/ic_TickSquare.png',
                      height: 14, width: 14, fit: BoxFit.cover),
              ],
            ),
            Row(
              children: [
                Image.asset(
                  'images/socialv/icons/ic_TimeSquare.png',
                  height: 14,
                  width: 14,
                  fit: BoxFit.cover,
                  color: context.iconColor,
                ),
                8.width,
                Text(widget.comment.createdAt.validate(),
                    style:
                        secondaryTextStyle(color: svGetBodyColor(), size: 12)),
              ],
            )
          ],
        ),
        16.height,
        Text(widget.comment.text.validate(),
            style: secondaryTextStyle(color: svGetBodyColor())),
        16.height,
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: radius(4), color: svGetScaffoldColor()),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.comment.liked.validate()
                      ? Image.asset('images/socialv/icons/ic_HeartFilled.png',
                          height: 14, width: 14, fit: BoxFit.fill)
                      : Image.asset(
                          'images/socialv/icons/ic_Heart.png',
                          height: 14,
                          width: 14,
                          fit: BoxFit.cover,
                          color: svGetBodyColor(),
                        ),
                  2.width,
                  Text('$_likesQ', style: secondaryTextStyle(size: 12)),
                ],
              ),
            ).onTap(() async {
              bool isliked = widget.comment.liked;
              widget.comment.liked = !widget.comment.liked.validate();
              setState(() {});
              if (widget.comment.liked) {
                setState(() {
                  _likesQ += 1;
                });
              } else {
                setState(() {
                  _likesQ -= 1;
                });

                if (!isliked) {
                  await commentLike(widget.comment.id);
                } else {
                  await commentDislike(widget.comment.id);
                }
              }
            }, borderRadius: radius(4)),
            16.width,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: radius(4), color: svGetScaffoldColor()),
              child: Text('Reply', style: secondaryTextStyle(size: 12)),
            )
          ],
        )
      ],
    ).paddingOnly(
        top: 16,
        left: widget.comment.isCommentReply.validate() ? 70 : 16,
        right: 16,
        bottom: 16);
  }
}
