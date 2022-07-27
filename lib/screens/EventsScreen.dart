import 'package:animate_do/animate_do.dart';
import 'package:brokerstreet/screens/fragments/SVAddPostFragment.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/http/models/Post.dart';
import 'package:brokerstreet/main.dart';
import 'package:brokerstreet/utils/SVColors.dart';
import 'package:brokerstreet/utils/SVCommon.dart';
import 'package:nb_utils/nb_utils.dart';

import '../http/controllers/eventController.dart';
import 'home/components/SVPostComponent.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late Future<List<Post?>> _posts;
  late List<String> _types;
  late String myId;

  final PageController _controller = PageController(initialPage: 0);
  Future<void> _onRefresh() async {
    var res = events();
    setState(() {
      _posts = res;
    });
  }

  init() async {
    myId = await retrieveId();
  }

  @override
  void initState() {
    _posts = events();
    _types = getEvents();
    init();
    afterBuildCreated(() {
      setStatusBarColor(svGetScaffoldColor());
    });
    super.initState();
  }

  int selectedTab = 0;
  _gotoPage(int page) {
    _controller.animateToPage(page,
        duration: Duration(milliseconds: 400), curve: Curves.linear);
  }

  getTabContainer() {
    return PageView(
      scrollDirection: Axis.horizontal,
      onPageChanged: (i) {
        setState(() {
          selectedTab = i;
        });
      },
      controller: _controller,
      children: <Widget>[
        EventFuture(_types[0]),
        EventFuture(_types[1]),
        EventFuture(_types[2]),
        EventFuture(_types[3]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var v16 = width / 20;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: svGetScaffoldColor(),
        title: Text('Events', style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: context.iconColor),
      ),
      body: Container(
        child: Column(
          children: [
            Stack(
              children: [
                HorizontalList(
                  spacing: 0,
                  padding: EdgeInsets.all(16),
                  itemCount: _types.length,
                  itemBuilder: (context, index) {
                    return AppButton(
                      margin: EdgeInsets.only(right: v16),
                      shapeBorder:
                          RoundedRectangleBorder(borderRadius: radius(8)),
                      text: _types[index],
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
                Positioned(
                    left: 20,
                    top: 24,
                    child: FadeInLeft(
                      child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              color: APP_ACCENT,
                              borderRadius: BorderRadius.circular(16)),
                          child: Icon(
                            EvaIcons.arrowIosBackOutline,
                            color: REAL_WHITE,
                            size: 22,
                          )).onTap(() {
                        selectedTab = 0;
                        setState(() {});
                        _gotoPage(0);
                      }),
                    )).visible(selectedTab == 3),
                Positioned(
                    right: 20,
                    top: 24,
                    child: FadeInRight(
                      child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              color: APP_ACCENT,
                              borderRadius: BorderRadius.circular(16)),
                          child: Icon(
                            EvaIcons.arrowIosForwardOutline,
                            color: REAL_WHITE,
                            size: 22,
                          )).onTap(() {
                        selectedTab = 3;
                        setState(() {});
                        _gotoPage(3);
                      }),
                    )).visible(selectedTab == 0),
              ],
            ),
            Expanded(child: getTabContainer())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: APP_ACCENT,
          onPressed: () => navigatePage(context,
              className: SVAddPostFragment(isEvent: true)),
          child: Icon(EvaIcons.editOutline, color: REAL_WHITE)),
    );
  }
}

class EventFuture extends StatefulWidget {
  const EventFuture(this.type, {Key? key}) : super(key: key);
  final String type;

  @override
  State<EventFuture> createState() => _EventFutureState();
}

class _EventFutureState extends State<EventFuture> {
  late Future<List<Post?>> _posts;
  late String myId;

  Future<void> _onRefresh() async {
    var res = eventsType(widget.type);
    setState(() {
      _posts = res;
    });
  }

  init() async {
    myId = await retrieveId();
  }

  @override
  void initState() {
    _posts = eventsType(widget.type);

    init();
    afterBuildCreated(() {
      setStatusBarColor(svGetScaffoldColor());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var v16 = width / 20;
    return FutureBuilder<List<Post?>>(
      future: _posts,
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
                    onTap: () => _onRefresh(),
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
}
