// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_is_empty, sized_box_for_whitespace, prefer_final_fields

import 'dart:io';

import 'dart:convert';
import 'dart:typed_data';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/http/controllers/homeController.dart';
import 'package:brokerstreet/http/controllers/searchController.dart';
import 'package:brokerstreet/http/models/Post.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:brokerstreet/main.dart';
import 'package:brokerstreet/toast.dart';
import 'package:brokerstreet/utils/SVColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/screens/home/components/SVHomeDrawerComponent.dart';
import 'package:brokerstreet/screens/home/components/SVPostComponent.dart';
import 'package:brokerstreet/screens/home/components/SVStoryComponent.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

import '../search/components/SVSearchCardComponent.dart';
import 'SVProfileFragment.dart';

class SVHomeFragment extends StatefulWidget {
  @override
  State<SVHomeFragment> createState() => _SVHomeFragmentState();
}

class _SVHomeFragmentState extends State<SVHomeFragment>
    with AutomaticKeepAliveClientMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<UserApi?>>? _users;
  // Future<List<Post?>>? _posts;
  TextEditingController _controller = TextEditingController();

  File? image;
  late String id;

  List<String> tabList = ['For you', 'Bars', 'Restaurants'];
  final PageController _pageController = PageController(initialPage: 0);

  int selectedTab = 0;
  String searchText = '';
  bool _clearText = false;

  Future<void> _onRefresh() async {
    var res = search(searchText);
    setState(() {
      _users = res;
      // _posts = res['posts'];
    });
  }

  Widget getTabContainer() {
    return PageView(
      scrollDirection: Axis.horizontal,
      onPageChanged: (i) {
        setState(() {
          selectedTab = i;
        });
      },
      controller: _pageController,
      children: <Widget>[
        PostFuture(1),
        PostFuture(2),
        PostFuture(3),
      ],
    );
    // if (selectedTab == 0) {
    //   // return SVForumTopicComponent(isFavTab: false);
    //   return PostFuture(1);
    // } else if (selectedTab == 1) {
    //   // return SVForumRepliesComponent();
    //   return PostFuture(2);
    // } else if (selectedTab == 2) {
    //   // return Offstage();
    //   return PostFuture(3);
    // } else
    //   // return SVForumTopicComponent(isFavTab: true);
    //   return PostFuture(1);
  }

  initId() async {
    id = await retrieveId();
    print('IDDDD: $id');
  }

  _gotoPage(int page) {
    _pageController.animateToPage(page,
        duration: Duration(milliseconds: 400), curve: Curves.linear);
  }

  @override
  void initState() {
    afterBuildCreated(() {
      setStatusBarColor(svGetScaffoldColor());
    });
    initId();
    super.initState();
  }

  submitText() {
    if (_controller.text.length < 2) {
      showToast("Type something", context);
      return;
    }
    _users = search(_controller.text);

    setState(() {
      searchText = _controller.text;
      _clearText = !_clearText;
    });
  }

  clearText() {
    setState(() {
      searchText = '';
      _controller.clear();
      _clearText = !_clearText;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double v16 = width / 20;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: svGetScaffoldColor(),
      appBar: AppBar(
        backgroundColor: svGetScaffoldColor(),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'images/socialv/icons/ic_More.png',
            width: 18,
            height: 18,
            fit: BoxFit.cover,
            color: context.iconColor,
          ),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text('Insomnis', style: boldTextStyle(size: 18)),
        actions: [
          IconButton(
            icon: Image.asset(
              'images/socialv/icons/ic_User.png',
              height: 24,
              width: 24,
              fit: BoxFit.cover,
            ),
            onPressed: () async {
              SVProfileFragment(
                id,
                mine: true,
              ).launch(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        // backgroundColor: context.cardColor,
        child: SVHomeDrawerComponent(),
      ),
      // body: SafeArea(
      //   child: Container(
      //     width: width,
      //     height: height,
      //     padding: EdgeInsets.only(
      //       top: v16,
      //     ),
      //     child: InAppWebView(
      //       initialUrlRequest: URLRequest(
      //           url: Uri.parse(
      //               "https://kordgram.com/api/set-browser-cookie?access_token=99398b9712c94bd6dc167099368164abb8a0e222edb317a80bbf538cee88660d14a5ae309468781291a575b38c7c4526decc579655a2a49c"),
      //           method: 'POST',
      //           body: Uint8List.fromList(utf8.encode("server_key=ad8e72a4670a5a4e023881c127df289a")),
      //           headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      //       onWebViewCreated: (controller) {},
      //     ),
      //   ),
      // ),
      body: Column(
        children: [
          // 16.height,
          // SVStoryComponent(),
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: context.cardColor, borderRadius: radius(8)),
            child: AppTextField(
              textFieldType: TextFieldType.NAME,
              controller: _controller,
              onFieldSubmitted: (_) => submitText(),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefix: SizedBox(
                  width: 8,
                ),
                hintText: 'Search Here',
                hintStyle: secondaryTextStyle(color: svGetBodyColor())
                    .copyWith(fontSize: 16),
                suffixIcon: Icon(
                        !_clearText ? EvaIcons.searchOutline : Icons.close,
                        size: 24,
                        color: svGetBodyColor())
                    .paddingAll(8)
                    .onTap(() => _clearText ? clearText() : submitText()),
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: context.width(),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Search bars, users & hangout places',
                                style: boldTextStyle(weight: FontWeight.normal))
                            .paddingAll(16),
                        FutureBuilder<List<UserApi?>>(
                          future: _users,
                          builder: (context,
                              AsyncSnapshot<List<UserApi?>> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.none ||
                                snapshot.connectionState ==
                                    ConnectionState.waiting) {
                              return Container(
                                height: height * 0.3,
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
                                height: height * 0.4,
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

                            return ListView.separated(
                              padding: EdgeInsets.all(16),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return SVSearchCardComponent(
                                        snapshot.data![index]!)
                                    .onTap(() {
                                  SVProfileFragment(snapshot.data![index]!.id)
                                      .launch(context);
                                });
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider(height: 20);
                              },
                              itemCount: snapshot.data!.length,
                            );
                          },
                        ),
                      ],
                    ),
                  ).visible(searchText.isNotEmpty),
                  Positioned.fill(
                    child: Column(
                      children: [
                        HorizontalList(
                          spacing: 0,
                          padding: EdgeInsets.all(16),
                          itemCount: tabList.length,
                          itemBuilder: (context, index) {
                            return AppButton(
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: radius(8)),
                              text: tabList[index],
                              textStyle: boldTextStyle(
                                  color: selectedTab == index
                                      ? Colors.white
                                      : svGetBodyColor(),
                                  size: 14),
                              onTap: () {
                                selectedTab = index;
                                setState(() {});
                                _gotoPage(index);
                              },
                              elevation: 0,
                              color: selectedTab == index
                                  ? SVAppColorPrimary
                                  : svGetScaffoldColor(),
                            );
                          },
                        ),
                        Expanded(
                          child:
                              Container(width: width, child: getTabContainer()),
                        ),
                      ],
                    ),
                  ).visible(searchText.isEmpty),
                ],
              ),
            ),
          ),
          // 4.height,
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PostFuture extends StatefulWidget {
  const PostFuture(this.type, {Key? key}) : super(key: key);
  final int type;

  @override
  State<PostFuture> createState() => _PostFutureState();
}

class _PostFutureState extends State<PostFuture>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Post?>> _posts;
  late Future<List<Post?>> _barPosts;
  late Future<List<Post?>> _resPosts;
  late String myId;

  Future<void> _onRefresh() async {
    var res = timelinePosts();
    setState(() {
      _posts = res;
    });
  }

  Future<void> _onRefresh2() async {
    var res = barPosts();
    setState(() {
      _barPosts = res;
    });
  }

  Future<void> _onRefresh3() async {
    var res = resPosts();
    setState(() {
      _resPosts = res;
    });
  }

  init() async {
    myId = await retrieveId();
  }

  @override
  void initState() {
    _posts = timelinePosts();
    _barPosts = barPosts();
    _resPosts = resPosts();
    init();
    afterBuildCreated(() {
      setStatusBarColor(svGetScaffoldColor());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var v16 = width / 20;
    return FutureBuilder<List<Post?>>(
      future: widget.type == 1
          ? _posts
          : widget.type == 2
              ? _barPosts
              : _resPosts,
      builder: (context, AsyncSnapshot<List<Post?>> snapshot) {
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
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Nothing to show',
                  style: TextStyle(fontSize: 16, color: APP_ACCENT),
                ).paddingOnly(bottom: 8),
                InkWell(
                    onTap: () => widget.type == 1
                        ? _onRefresh()
                        : widget.type == 2
                            ? _onRefresh2()
                            : _onRefresh3(),
                    child: Container(
                      height: 64,
                      margin: EdgeInsets.symmetric(horizontal: v16 * 4),
                      child: normalButton(
                          v16: v16 * 0.7,
                          bgColor: APP_ACCENT,
                          title: "refresh"),
                    )),
              ],
            )),
          );
        }

        return ListView(
          children: [
            SVPostComponent(snapshot.data!, myId),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
