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
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../../../http/controllers/SavedPostController.dart';

class SVPostComponent extends StatefulWidget {
  final List<Post?> posts;
  final String myId;
  const SVPostComponent(this.posts, this.myId, {Key? key});
  @override
  State<SVPostComponent> createState() => _SVPostComponentState();
}

class _SVPostComponentState extends State<SVPostComponent>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: widget.posts.length,
      padding: EdgeInsets.only(bottom: 48),
      itemBuilder: (context, index) {
        bool mine = widget.posts[index]!.creator.id == widget.myId;
        if (widget.posts[index]!.type == 'video') {
          return VideoComponent(widget.posts[index]!, mine);
        }
        return ImageComponent(widget.posts[index]!, mine);
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ImageComponent extends StatefulWidget {
  const ImageComponent(this.posts, this.mine, {Key? key}) : super(key: key);
  final Post posts;
  final bool mine;
  @override
  State<ImageComponent> createState() => _ImageComponentState();
}

class _ImageComponentState extends State<ImageComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: radius(SVAppCommonRadius), color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.posts.creator.avatar,
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
                    if (!widget.mine) {
                      SVProfileFragment(widget.posts.creator.id)
                          .launch(context);
                    }
                  }),
                  12.width,
                  Text(widget.mine ? 'You' : widget.posts.creator.displayname,
                          style: boldTextStyle())
                      .onTap(() {
                    if (!widget.mine) {
                      SVProfileFragment(widget.posts.creator.id)
                          .launch(context);
                    }
                  }),
                  4.width,
                  if (widget.posts.creator.verified)
                    Image.asset('images/socialv/icons/ic_TickSquare.png',
                            height: 14, width: 14, fit: BoxFit.cover)
                        .onTap(() {
                      if (!widget.mine) {
                        SVProfileFragment(widget.posts.creator.id)
                            .launch(context);
                      }
                    }),
                ],
              ).paddingSymmetric(horizontal: 16),
              Row(
                children: [
                  Text(widget.posts.createdAt,
                      style: secondaryTextStyle(
                          color: svGetBodyColor(), size: 12)),
                  IconButton(
                      onPressed: () {
                        if (widget.posts.saved) {
                          setState(() {
                            widget.posts.saved = !widget.posts.saved;
                          });
                          unsavePost(widget.posts.id);
                        } else {
                          setState(() {
                            widget.posts.saved = !widget.posts.saved;
                          });
                          savePost(widget.posts.id);
                        }
                      },
                      icon: Icon(widget.posts.saved
                          ? Icons.bookmark
                          : Icons.bookmark_border_outlined))
                ],
              ).paddingSymmetric(horizontal: 8),
            ],
          ),
          16.height,
          widget.posts.text.isNotEmpty
              ? svRobotoText(
                      text: widget.posts.text, textAlign: TextAlign.start)
                  .paddingSymmetric(horizontal: 16)
              : Offstage(),
          widget.posts.text.isNotEmpty ? 16.height : Offstage(),
          if (widget.posts.type == 'image')
            Image.network(
              widget.posts.attached,
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
                    SVCommentScreen(widget.posts.id).launch(context);
                  },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent),
                  IconButton(
                    icon: widget.posts.liked.validate()
                        ? Image.asset('images/socialv/icons/ic_HeartFilled.png',
                            height: 20, width: 22, fit: BoxFit.fill)
                        : Image.asset(
                            'images/socialv/icons/ic_Heart.png',
                            height: 22,
                            width: 22,
                            fit: BoxFit.cover,
                            color: context.iconColor,
                          ),
                    onPressed: () async {
                      bool isliked = widget.posts.liked.validate();
                      widget.posts.liked = !widget.posts.liked.validate();
                      setState(() {});
                      if (!isliked) {
                        await postLike(widget.posts.id);
                      } else {
                        await postDislike(widget.posts.id);
                      }
                    },
                  ),
                ],
              ),
              Text('${widget.posts.comments.validate()} comments',
                      style: secondaryTextStyle(color: svGetBodyColor()))
                  .onTap(() {
                SVCommentScreen(widget.posts.id).launch(context);
              }),
            ],
          ).paddingSymmetric(horizontal: 16),
        ],
      ),
    );
  }
}

class VideoComponent extends StatefulWidget {
  const VideoComponent(this.posts, this.mine, {Key? key}) : super(key: key);
  final Post posts;
  final bool mine;
  @override
  State<VideoComponent> createState() => _VideoComponentState();
}

class _VideoComponentState extends State<VideoComponent> {
  // List<SVPostModel> postList = getPosts();
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.posts.attached);

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   initVideo(widget.posts.attached);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: radius(SVAppCommonRadius), color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.posts.creator.avatar,
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
                    if (!widget.mine) {
                      SVProfileFragment(widget.posts.creator.id)
                          .launch(context);
                    }
                  }),
                  12.width,
                  Text(widget.mine ? 'You' : widget.posts.creator.displayname,
                          style: boldTextStyle())
                      .onTap(() {
                    if (!widget.mine) {
                      SVProfileFragment(widget.posts.creator.id)
                          .launch(context);
                    }
                  }),
                  4.width,
                  if (widget.posts.creator.verified)
                    Image.asset('images/socialv/icons/ic_TickSquare.png',
                            height: 14, width: 14, fit: BoxFit.cover)
                        .onTap(() {
                      if (!widget.mine) {
                        SVProfileFragment(widget.posts.creator.id)
                            .launch(context);
                      }
                    }),
                ],
              ).paddingSymmetric(horizontal: 16),
              Row(
                children: [
                  Text(widget.posts.createdAt,
                      style: secondaryTextStyle(
                          color: svGetBodyColor(), size: 12)),
                  IconButton(
                      onPressed: () {
                        if (widget.posts.saved) {
                          setState(() {
                            widget.posts.saved = !widget.posts.saved;
                          });
                          unsavePost(widget.posts.id);
                        } else {
                          setState(() {
                            widget.posts.saved = !widget.posts.saved;
                          });
                          savePost(widget.posts.id);
                        }
                      },
                      icon: Icon(widget.posts.saved
                          ? Icons.bookmark
                          : Icons.bookmark_border_outlined))
                ],
              ).paddingSymmetric(horizontal: 8),
            ],
          ),
          16.height,
          widget.posts.text.isNotEmpty
              ? svRobotoText(
                      text: widget.posts.text, textAlign: TextAlign.start)
                  .paddingSymmetric(horizontal: 16)
              : Offstage(),
          widget.posts.text.isNotEmpty ? 16.height : Offstage(),
          if (widget.posts.type == 'video')
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  _ControlsOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ).cornerRadiusWithClipRRect(SVAppCommonRadius).center(),
          // chewieController != null &&
          //         chewieController!.videoPlayerController.value.isInitialized
          //     ? Chewie(
          //         controller: chewieController!,
          //       ).cornerRadiusWithClipRRect(SVAppCommonRadius).center()
          //     : Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: const [
          //           CircularProgressIndicator(),
          //           SizedBox(height: 20),
          //           // Text('Loading'),
          //         ],
          //       ).center(),
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
                    SVCommentScreen(widget.posts.id).launch(context);
                  },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent),
                  IconButton(
                    icon: widget.posts.liked.validate()
                        ? Image.asset('images/socialv/icons/ic_HeartFilled.png',
                            height: 20, width: 22, fit: BoxFit.fill)
                        : Image.asset(
                            'images/socialv/icons/ic_Heart.png',
                            height: 22,
                            width: 22,
                            fit: BoxFit.cover,
                            color: context.iconColor,
                          ),
                    onPressed: () async {
                      bool isliked = widget.posts.liked.validate();
                      widget.posts.liked = !widget.posts.liked.validate();
                      setState(() {});
                      if (!isliked) {
                        await postLike(widget.posts.id);
                      } else {
                        await postDislike(widget.posts.id);
                      }
                    },
                  ),
                ],
              ),
              Text('${widget.posts.comments.validate()} comments',
                      style: secondaryTextStyle(color: svGetBodyColor()))
                  .onTap(() {
                SVCommentScreen(widget.posts.id).launch(context);
              }),
            ],
          ).paddingSymmetric(horizontal: 16),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration(milliseconds: 0),
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
