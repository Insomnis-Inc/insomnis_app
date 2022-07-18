// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:brokerstreet/http/controllers/postController.dart';
import 'package:brokerstreet/http/models/Post.dart';
import 'package:brokerstreet/main.dart';
import 'package:brokerstreet/screens/fragments/SVProfileFragment.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/models/SVPostModel.dart';
import 'package:brokerstreet/screens/home/screens/SVCommentScreen.dart';
import 'package:brokerstreet/utils/SVCommon.dart';
import 'package:brokerstreet/utils/SVConstants.dart';

class SVPostComponent extends StatefulWidget {
  final List<Post?> posts;
  final String myId;
  const SVPostComponent(this.posts, this.myId, {Key? key});
  @override
  State<SVPostComponent> createState() => _SVPostComponentState();
}

class _SVPostComponentState extends State<SVPostComponent>
    with AutomaticKeepAliveClientMixin {
  // List<SVPostModel> postList = getPosts();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: widget.posts.length,
      padding: EdgeInsets.only(bottom: 48),
      itemBuilder: (context, index) {
        bool mine = widget.posts[index]!.creator.id == widget.myId;
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
              borderRadius: radius(SVAppCommonRadius),
              color: context.cardColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.posts[index]!.creator.avatar,
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
                      ).cornerRadiusWithClipRRect(SVAppCommonRadius).onTap(() {
                        if (!mine) {
                          SVProfileFragment(widget.posts[index]!.creator.id)
                              .launch(context);
                        }
                      }),
                      12.width,
                      Text(
                              mine
                                  ? 'You'
                                  : widget.posts[index]!.creator.displayname,
                              style: boldTextStyle())
                          .onTap(() {
                        if (!mine) {
                          SVProfileFragment(widget.posts[index]!.creator.id)
                              .launch(context);
                        }
                      }),
                      4.width,
                      if (widget.posts[index]!.creator.verified)
                        Image.asset('images/socialv/icons/ic_TickSquare.png',
                                height: 14, width: 14, fit: BoxFit.cover)
                            .onTap(() {
                          if (!mine) {
                            SVProfileFragment(widget.posts[index]!.creator.id)
                                .launch(context);
                          }
                        }),
                    ],
                  ).paddingSymmetric(horizontal: 16),
                  Row(
                    children: [
                      Text(widget.posts[index]!.createdAt,
                          style: secondaryTextStyle(
                              color: svGetBodyColor(), size: 12)),
                      if (mine)
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.more_horiz)),
                    ],
                  ).paddingSymmetric(horizontal: 8),
                ],
              ),
              16.height,
              widget.posts[index]!.text.isNotEmpty
                  ? svRobotoText(
                          text: widget.posts[index]!.text,
                          textAlign: TextAlign.start)
                      .paddingSymmetric(horizontal: 16)
                  : Offstage(),
              widget.posts[index]!.text.isNotEmpty ? 16.height : Offstage(),
              if (widget.posts[index]!.type == 'image')
                Image.network(
                  widget.posts[index]!.attached,
                  height: 300,
                  width: context.width() - 32,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRect(SVAppCommonRadius).center(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'images/socialv/icons/ic_Chat.png',
                        height: 22,
                        width: 22,
                        fit: BoxFit.cover,
                        color: context.iconColor,
                      ).onTap(() {
                        SVCommentScreen(widget.posts[index]!.id)
                            .launch(context);
                      },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent),
                      IconButton(
                        icon: widget.posts[index]!.liked.validate()
                            ? Image.asset(
                                'images/socialv/icons/ic_HeartFilled.png',
                                height: 20,
                                width: 22,
                                fit: BoxFit.fill)
                            : Image.asset(
                                'images/socialv/icons/ic_Heart.png',
                                height: 22,
                                width: 22,
                                fit: BoxFit.cover,
                                color: context.iconColor,
                              ),
                        onPressed: () async {
                          bool isliked = widget.posts[index]!.liked.validate();
                          widget.posts[index]!.liked =
                              !widget.posts[index]!.liked.validate();
                          setState(() {});
                          if (!isliked) {
                            await postLike(widget.posts[index]!.id);
                          } else {
                            await postDislike(widget.posts[index]!.id);
                          }
                        },
                      ),
                      // Image.asset(
                      //   'images/socialv/icons/ic_Send.png',
                      //   height: 22,
                      //   width: 22,
                      //   fit: BoxFit.cover,
                      //   color: context.iconColor,
                      // ).onTap(() {
                      //   svShowShareBottomSheet(context);
                      // },
                      //     splashColor: Colors.transparent,
                      //     highlightColor: Colors.transparent),
                    ],
                  ),
                  Text('${widget.posts[index]!.comments.validate()} comments',
                          style: secondaryTextStyle(color: svGetBodyColor()))
                      .onTap(() {
                    SVCommentScreen(widget.posts[index]!.id).launch(context);
                  }),
                ],
              ).paddingSymmetric(horizontal: 16),
              // Divider(indent: 16, endIndent: 16, height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SizedBox(
              //       width: 56,
              //       child: Stack(
              //         alignment: Alignment.centerLeft,
              //         children: [
              //           Positioned(
              //             child: Container(
              //               decoration: BoxDecoration(
              //                   border:
              //                       Border.all(color: Colors.white, width: 2),
              //                   borderRadius: radius(100)),
              //               child: Image.asset(
              //                       'images/socialv/faces/face_1.png',
              //                       height: 24,
              //                       width: 24,
              //                       fit: BoxFit.cover)
              //                   .cornerRadiusWithClipRRect(100),
              //             ),
              //             right: 0,
              //           ),
              //           Positioned(
              //             left: 14,
              //             child: Container(
              //               decoration: BoxDecoration(
              //                   border:
              //                       Border.all(color: Colors.white, width: 2),
              //                   borderRadius: radius(100)),
              //               child: Image.asset(
              //                       'images/socialv/faces/face_2.png',
              //                       height: 24,
              //                       width: 24,
              //                       fit: BoxFit.cover)
              //                   .cornerRadiusWithClipRRect(100),
              //             ),
              //           ),
              //           Positioned(
              //             child: Container(
              //               decoration: BoxDecoration(
              //                   border:
              //                       Border.all(color: Colors.white, width: 2),
              //                   borderRadius: radius(100)),
              //               child: Image.asset(
              //                       'images/socialv/faces/face_3.png',
              //                       height: 24,
              //                       width: 24,
              //                       fit: BoxFit.cover)
              //                   .cornerRadiusWithClipRRect(100),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     10.width,
              //     RichText(
              //       text: TextSpan(
              //         text: 'Liked By ',
              //         style:
              //             secondaryTextStyle(color: svGetBodyColor(), size: 12),
              //         children: <TextSpan>[
              //           TextSpan(
              //               text: 'Ms.Mountain ',
              //               style: boldTextStyle(size: 12)),
              //           TextSpan(
              //               text: 'And ',
              //               style: secondaryTextStyle(
              //                   color: svGetBodyColor(), size: 12)),
              //           TextSpan(
              //               text: '1,10 Others ',
              //               style: boldTextStyle(size: 12)),
              //         ],
              //       ),
              //     )
              //   ],
              // )
            ],
          ),
        );
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
