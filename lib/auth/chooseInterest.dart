import 'package:brokerstreet/http/models/Interest.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../custom_colors.dart';

class ChooseInterests extends StatefulWidget {
  const ChooseInterests({Key? key}) : super(key: key);

  @override
  _ChooseInterestsState createState() => _ChooseInterestsState();
}

class _ChooseInterestsState extends State<ChooseInterests>
    with AutomaticKeepAliveClientMixin {
  // Future<void> _onRefresh() async {
  //   var res = userPosts(user.id);
  //   setState(() {
  //     _posts = res;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double v16 = width / 20;
    return Scaffold(
        body: GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Image.network(
                  testImage,
                  fit: BoxFit.cover,
                  width: width / 3,
                ),
              ),
            ),
            Text("data")
          ],
        );
      },
    )

        // Container(
        //   width: width,
        //   height: height,
        //   child: FutureBuilder<List<Interest?>>(
        //     future: _posts,
        //     builder: (context, AsyncSnapshot<List<Interest?>> snapshot) {
        //       if (snapshot.connectionState == ConnectionState.none ||
        //           snapshot.connectionState == ConnectionState.waiting) {
        //         return Container(
        //           height: height * 0.7,
        //           width: width,
        //           child: Center(
        //               child: Padding(
        //             padding: EdgeInsets.all(v16),
        //             child: CircularProgressIndicator(
        //               color: APP_ACCENT,
        //             ),
        //           )),
        //         );
        //       }

        //       if (snapshot.data == null || snapshot.data?.length == 0) {
        //         return Container(
        //           height: height * 0.8,
        //           width: width,
        //           child: RefreshIndicator(
        //             triggerMode: RefreshIndicatorTriggerMode.anywhere,
        //             color: APP_ACCENT,
        //             onRefresh: () => _onRefresh(),
        //             child: Center(
        //                 child: InkWell(
        //                     onTap: () => _onRefresh(),
        //                     child: Container(
        //                       height: 64,
        //                       margin: EdgeInsets.symmetric(horizontal: v16 * 4),
        //                       child: normalButton(
        //                           v16: v16,
        //                           bgColor: APP_ACCENT,
        //                           title: "refresh"),
        //                     ))),
        //           ),
        //         );
        //       }

        //       return GridView.builder(
        //         itemCount: snapshot.data!.length,
        //         shrinkWrap: true,
        //         physics: NeverScrollableScrollPhysics(),
        //         itemBuilder: (BuildContext context, int index) {
        //           return Image.asset(snapshot.data![index]!.image,
        //                   height: 100, fit: BoxFit.cover)
        //               .cornerRadiusWithClipRRect(8);
        //         },
        //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //           crossAxisCount: 3,
        //           crossAxisSpacing: 16,
        //           mainAxisSpacing: 16,
        //           childAspectRatio: 1,
        //         ),
        //       );
        //     },
        //   ),
        // ),
        );
  }

  @override
  bool get wantKeepAlive => true;
}
