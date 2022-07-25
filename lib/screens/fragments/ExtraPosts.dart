// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_final_fields, sized_box_for_whitespace

import 'package:brokerstreet/http/controllers/extraController.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/http/models/Post.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:brokerstreet/main.dart';
import 'package:brokerstreet/toast.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/screens/fragments/SVProfileFragment.dart';
import 'package:brokerstreet/screens/search/components/SVSearchCardComponent.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

import '../../http/models/Extra.dart';
import '../home/components/SVPostComponent.dart';
import 'SVAddPostFragment.dart';

class ExtraPosts extends StatefulWidget {
  final String title;
  final String extraId;
  final bool canAdd;
  final String image;

  ExtraPosts(
      {required this.title,
      this.canAdd = false,
      required this.image,
      required this.extraId});
  @override
  State<ExtraPosts> createState() => _ExtraPostsState();
}

class _ExtraPostsState extends State<ExtraPosts>
    with AutomaticKeepAliveClientMixin {
  // List<SVSearchModel> list = [];
  // List<SVSearchModel> tags = [];
  late Future<List<Post?>> _posts;
  TextEditingController _controller = TextEditingController();
  Future<List<Post?>>? _postsSearch;
  String searchText = '';
  late String myId;

  @override
  void initState() {
    // list = getRecentList();
    _posts = extraPosts(widget.extraId);
    init();
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(svGetScaffoldColor());
    });
  }

  init() async {
    myId = await retrieveId();
  }

  Future<void> _onRefresh() async {
    var res = searchExtraPosts(term: searchText, extraId: widget.extraId);
    setState(() {
      _postsSearch = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var v16 = width / 20;
    return Scaffold(
      backgroundColor: svGetScaffoldColor(),
      appBar: AppBar(
        backgroundColor: svGetScaffoldColor(),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: context.iconColor),
        leadingWidth: 30,
        title: Text(widget.title, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size(width, 72),
          child: Container(
            margin: EdgeInsets.only(left: v16, right: v16),
            decoration: BoxDecoration(
                color: context.cardColor, borderRadius: radius(8)),
            child: AppTextField(
              textFieldType: TextFieldType.NAME,
              controller: _controller,
              onFieldSubmitted: (_) {
                if (_controller.text.length < 2) {
                  showToast("Type something", context);
                  return;
                }
                _postsSearch = searchExtraPosts(
                    term: _controller.text, extraId: widget.extraId);

                setState(() {
                  searchText = _controller.text;
                });
              },
              decoration: InputDecoration(
                border: outlineInputBorder,
                focusedBorder: outlineInputBorder,
                enabledBorder: outlineInputBorder,
                errorBorder: outlineInputBorder,
                disabledBorder: outlineInputBorder,
                hintText: 'Search ${widget.title} posts',
                hintStyle: secondaryTextStyle(color: svGetBodyColor()),
                prefixIcon: Image.asset('images/socialv/icons/ic_Search.png',
                        height: 16,
                        width: 16,
                        fit: BoxFit.cover,
                        color: svGetBodyColor())
                    .paddingAll(16)
                    .onTap(() {
                  if (_controller.text.length < 2) {
                    showToast("Type something", context);
                    return;
                  }
                  _postsSearch = searchExtraPosts(
                      term: _controller.text, extraId: widget.extraId);

                  setState(() {
                    searchText = _controller.text;
                  });
                }),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<List<Post?>>(
                      future: _postsSearch,
                      builder: (context, AsyncSnapshot<List<Post?>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
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

                        if (snapshot.data == null ||
                            snapshot.data?.length == 0) {
                          return Container(
                            height: height * 0.8,
                            width: width,
                            child: Center(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Nothing to show',
                                  style: TextStyle(
                                      fontSize: 16, color: APP_ACCENT),
                                ).paddingOnly(bottom: 8),
                                InkWell(
                                    onTap: () => _onRefresh(),
                                    child: Container(
                                      height: 64,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: v16 * 4),
                                      child: normalButton(
                                          v16: v16 * 0.7,
                                          bgColor: APP_ACCENT,
                                          title: "refresh"),
                                    )),
                              ],
                            )),
                          );
                        }

                        return Container(
                          height: height,
                          width: width,
                          child: ListView(
                            padding: EdgeInsets.only(bottom: 120),
                            children: [
                              SVPostComponent(snapshot.data!, myId),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ).visible(searchText.isNotEmpty),
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('Trending Posts',
                    //         style: boldTextStyle(weight: FontWeight.normal))
                    //     .paddingAll(16),
                    FutureBuilder<List<Post?>>(
                      future: _posts,
                      builder: (context, AsyncSnapshot<List<Post?>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
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

                        if (snapshot.data == null ||
                            snapshot.data?.length == 0) {
                          return Container(
                            height: height * 0.8,
                            width: width,
                            child: Center(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Nothing to show',
                                  style: TextStyle(
                                      fontSize: 16, color: APP_ACCENT),
                                ).paddingOnly(bottom: 8),
                                InkWell(
                                    onTap: () => _onRefresh(),
                                    child: Container(
                                      height: 64,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: v16 * 4),
                                      child: normalButton(
                                          v16: v16 * 0.7,
                                          bgColor: APP_ACCENT,
                                          title: "refresh"),
                                    )),
                              ],
                            )),
                          );
                        }

                        return Container(
                          height: height,
                          width: width,
                          child: ListView(
                            padding: EdgeInsets.only(bottom: 144),
                            children: [
                              SVPostComponent(snapshot.data!, myId),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ).visible(searchText.isEmpty),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.canAdd
          ? FloatingActionButton(
              backgroundColor: APP_ACCENT,
              onPressed: () => navigatePage(context,
                  className: SVAddPostFragment(
                      isExtra: true,
                      extra: Extra(
                          id: widget.extraId,
                          name: widget.title,
                          image: widget.image,
                          canAdd: widget.canAdd))),
              child: Icon(EvaIcons.editOutline, color: svGetScaffoldColor()))
          : Offstage(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
