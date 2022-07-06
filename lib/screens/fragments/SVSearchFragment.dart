// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_final_fields, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/http/controllers/homeController.dart';
import 'package:brokerstreet/http/controllers/searchController.dart';
import 'package:brokerstreet/http/models/Post.dart';
import 'package:brokerstreet/http/models/UserApi.dart';
import 'package:brokerstreet/main.dart';
import 'package:brokerstreet/toast.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/models/SVSearchModel.dart';
import 'package:brokerstreet/screens/fragments/SVProfileFragment.dart';
import 'package:brokerstreet/screens/search/components/SVSearchCardComponent.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

import '../home/components/SVPostComponent.dart';

class SVSearchFragment extends StatefulWidget {
  @override
  State<SVSearchFragment> createState() => _SVSearchFragmentState();
}

class _SVSearchFragmentState extends State<SVSearchFragment> {
  List<SVSearchModel> list = [];
  List<SVSearchModel> tags = [];
  late Future<List<Post?>> _posts;
  TextEditingController _controller = TextEditingController();
  Future<List<UserApi?>>? _users;
  String searchText = '';
  late String myId;

  @override
  void initState() {
    list = getRecentList();
    _posts = trendingPosts();
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
    var res = search(searchText);
    setState(() {
      _users = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var v16 = width / 20;
    return Scaffold(
      backgroundColor: svGetScaffoldColor(),
      appBar: AppBar(
        backgroundColor: svGetScaffoldColor(),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: context.iconColor),
        leadingWidth: 30,
        title: Container(
          decoration:
              BoxDecoration(color: context.cardColor, borderRadius: radius(8)),
          child: AppTextField(
            textFieldType: TextFieldType.NAME,
            controller: _controller,
            onFieldSubmitted: (_) {
              if (_controller.text.length < 2) {
                showToast("Type something", context);
                return;
              }
              _users = search(_controller.text);

              setState(() {
                searchText = _controller.text;
              });
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search bars & hangouts',
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
                _users = search(_controller.text);

                setState(() {
                  searchText = _controller.text;
                });
              }),
            ),
          ),
        ),
        elevation: 0,
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
                    Text('Search bars, users & hangout places',
                            style: boldTextStyle(weight: FontWeight.normal))
                        .paddingAll(16),
                    FutureBuilder<List<UserApi?>>(
                      future: _users,
                      builder:
                          (context, AsyncSnapshot<List<UserApi?>> snapshot) {
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
                          child: ListView.separated(
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
                    Text('Trending Posts',
                            style: boldTextStyle(weight: FontWeight.normal))
                        .paddingAll(16),
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
                            padding: EdgeInsets.only(bottom: 24),
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
    );
  }
}
