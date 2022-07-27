// ignore_for_file: prefer_const_constructors

import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/getx/getxCommentController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:brokerstreet/http/controllers/commentsController.dart';
import 'package:brokerstreet/http/models/Comment.dart';
import 'package:get/get.dart';
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
  bool showComments = false;
  Future<List<Comment?>>? _commentComments;
  @override
  void initState() {
    _likesQ = int.parse(widget.comment.likes).validate();
    _commentComments = commentComments(widget.comment.id);
    super.initState();
  }

  Future<void> _onRefresh() async {
    var res = commentComments(widget.comment.id);
    setState(() {
      _commentComments = res;
    });
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.comment.creator.displayname.validate(),
                            style: boldTextStyle(size: 16))
                        .paddingOnly(bottom: 4),
                    Row(
                      children: [
                        Image.asset(
                          'images/socialv/icons/ic_TimeSquare.png',
                          height: 12,
                          width: 12,
                          fit: BoxFit.cover,
                          color: Theme.of(context).iconTheme.color!,
                        ),
                        8.width,
                        Text(widget.comment.createdAt.validate(),
                            style: secondaryTextStyle(
                                color: svGetBodyColor(), size: 12)),
                      ],
                    )
                  ],
                ),
                // 4.width,
                // if (widget.comment.creator.verified.validate())
                //   Image.asset('images/socialv/icons/ic_TickSquare.png',
                //       height: 14, width: 14, fit: BoxFit.cover),
              ],
            ),
          ],
        ),
        16.height,
        Text(widget.comment.text.validate(),
            style: secondaryTextStyle(color: svGetBodyColor())),
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                          ? Image.asset(
                              'images/socialv/icons/ic_HeartFilled.png',
                              height: 14,
                              width: 14,
                              fit: BoxFit.fill)
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
                  }

                  if (!isliked) {
                    commentLike(widget.comment.id).then((value) => null);
                  } else {
                    commentDislike(widget.comment.id).then((value) => null);
                  }
                }, borderRadius: radius(4)),
                16.width,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: radius(4), color: svGetScaffoldColor()),
                  child: Text('Reply', style: secondaryTextStyle(size: 12)),
                ).onTap(() {
                  // print('hallo');
                  Get.find<GetxCommentController>()
                      .commentReply(true, widget.comment.id);
                })
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: radius(4), color: svGetScaffoldColor()),
              child: Text(
                  '${showComments ? 'close' : 'replies'} (${widget.comment.comments})',
                  style: secondaryTextStyle(size: 12)),
            ).onTap(() {
              setState(() {
                showComments = !showComments;
              });
            }).visible(widget.comment.comments.toInt() > 0)
          ],
        ),
        FutureBuilder<List<Comment?>>(
          future: _commentComments,
          builder: (context, AsyncSnapshot<List<Comment?>> snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  color: APP_ACCENT,
                ),
              ));
            }

            if (snapshot.data == null || snapshot.data?.length == 0) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Nothing to show',
                      style: TextStyle(fontSize: 16, color: APP_ACCENT),
                    ).paddingOnly(bottom: 8),
                    InkWell(
                        onTap: () => _onRefresh(),
                        child: Container(
                          height: 64,
                          margin: EdgeInsets.symmetric(horizontal: 16 * 4),
                          child: normalButton(
                              v16: 16 * 0.7,
                              bgColor: APP_ACCENT,
                              title: "refresh"),
                        )),
                  ],
                )),
              );
            }

            return ListView.builder(
              // padding: EdgeInsets.all(16),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SVCommentComponent(snapshot.data![index]!);
              },
              // separatorBuilder: (BuildContext context, int index) {
              //   return Divider(height: 20);
              // },
              itemCount: snapshot.data!.length,
            );
          },
        ).visible(showComments),
      ],
    ).paddingOnly(
        top: 16,
        left: widget.comment.isCommentReply.validate() ? 32 : 16,
        right: widget.comment.isCommentReply.validate() ? 0 : 16,
        bottom: 16);
  }
}
