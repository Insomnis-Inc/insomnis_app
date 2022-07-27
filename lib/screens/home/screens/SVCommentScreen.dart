// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_is_empty

import 'package:brokerstreet/getx/getxCommentController.dart';
import 'package:flutter/material.dart';
import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/http/controllers/commentsController.dart';
import 'package:brokerstreet/http/models/Comment.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/models/SVCommentModel.dart';
import 'package:brokerstreet/screens/home/components/SVCommentComponent.dart';
import 'package:brokerstreet/screens/home/components/SVCommentReplyComponent.dart';
import 'package:brokerstreet/utils/SVColors.dart';

import '../../../../../main.dart';

class SVCommentScreen extends StatefulWidget {
  const SVCommentScreen(this.postId, {Key? key}) : super(key: key);
  final String postId;
  @override
  State<SVCommentScreen> createState() => _SVCommentScreenState();
}

class _SVCommentScreenState extends State<SVCommentScreen>
    with AutomaticKeepAliveClientMixin {
  // List<SVCommentModel> commentList = [];
  late Future<List<Comment?>> _comments;

  @override
  void initState() {
    final GetxCommentController c = Get.put(GetxCommentController());
    c.resetCommentReply();
    // commentList = getComments();
    _comments = postComments(widget.postId);
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(context.cardColor);
    });
  }

  @override
  void dispose() {
    setStatusBarColor(
        appStore.isDarkMode ? appBackgroundColorDark : SVAppLayoutBackground);
    super.dispose();
  }

  Future<void> _onRefresh() async {
    var res = postComments(widget.postId);
    setState(() {
      _comments = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var v16 = width / 20;
    return Scaffold(
      backgroundColor: context.cardColor,
      appBar: AppBar(
        backgroundColor: context.cardColor,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color!),
        title: Text('Comments', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => _onRefresh(),
              icon: Icon(Icons.refresh_outlined)),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          // alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: FutureBuilder<List<Comment?>>(
                future: _comments,
                builder: (context, AsyncSnapshot<List<Comment?>> snapshot) {
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
                      child: RefreshIndicator(
                        triggerMode: RefreshIndicatorTriggerMode.anywhere,
                        color: APP_ACCENT,
                        onRefresh: () => _onRefresh(),
                        child: Center(
                            child: InkWell(
                                onTap: () => _onRefresh(),
                                child: Container(
                                  height: 64,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: v16 * 4),
                                  child: normalButton(
                                      v16: v16,
                                      bgColor: APP_ACCENT,
                                      title: "refresh"),
                                ))),
                      ),
                    );
                  }

                  return Column(
                      children: snapshot.data!.map((e) {
                    return SVCommentComponent(e!);
                  }).toList());
                },
              ),
              //    Column(
              //   children: commentList.map((e) {
              //     return SVCommentComponent(comment: e);
              //   }).toList(),
              // ),
            ),
            Positioned(
                bottom: 0, child: SVCommentReplyComponent(widget.postId, true)),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
