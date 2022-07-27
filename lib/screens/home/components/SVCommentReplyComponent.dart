// ignore_for_file: prefer_const_constructors, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:brokerstreet/http/controllers/commentsController.dart';
import 'package:brokerstreet/toast.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/utils/SVColors.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

class SVCommentReplyComponent extends StatefulWidget {
  const SVCommentReplyComponent(this.postOrCommentId, this.isPost, {Key? key})
      : super(key: key);
  final String postOrCommentId;
  final bool isPost;

  @override
  State<SVCommentReplyComponent> createState() =>
      _SVCommentReplyComponentState();
}

class _SVCommentReplyComponentState extends State<SVCommentReplyComponent> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 12),
      color: svGetScaffoldColor(),
      width: context.width(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Divider(indent: 16, endIndent: 16, height: 20),
          Container(
            padding: EdgeInsets.only(
              bottom: 8,
              top: 4,
              left: 16,
            ),
            child: Text("Reply to comment"),
          ),
          Row(
            children: [
              // 16.width,
              // Image.asset('images/socialv/faces/face_5.png',
              //         height: 48, width: 48, fit: BoxFit.cover)
              //     .cornerRadiusWithClipRRect(8),
              // 10.width,
              Expanded(
                child: Container(
                  // width: context.width() * 0.6,
                  padding: EdgeInsets.only(left: 16),
                  child: AppTextField(
                    textFieldType: TextFieldType.OTHER,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Write A Comment',
                      hintStyle: secondaryTextStyle(color: svGetBodyColor()),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    if (_controller.text.isEmpty) {
                      showToast("Type something", context);
                      return;
                    }

                    commentCreate(
                            text: _controller.text,
                            postId:
                                widget.isPost ? widget.postOrCommentId : null,
                            commentId:
                                widget.isPost ? null : widget.postOrCommentId)
                        .then((value) => null);
                    _controller.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Reply',
                      style: secondaryTextStyle(color: SVAppColorPrimary)))
            ],
          ),
        ],
      ),
    );
  }
}
