import 'package:brokerstreet/screens/SVDashboardScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../custom_colors.dart';

Color primaryColor1 = APP_ACCENT;
Color primaryColor2 = SHIMMER_BLUE_DARK;

class EASelectHashtagScreen extends StatefulWidget {
  final String? name;
  final bool backButton;
  EASelectHashtagScreen({this.name = 'Kampala', this.backButton = false});

  @override
  _EASelectHashtagScreenState createState() => _EASelectHashtagScreenState();
}

class _EASelectHashtagScreenState extends State<EASelectHashtagScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Select Interests",
          backWidget:
              widget.backButton ? BackButton(color: white) : Offstage()),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 80),
            child: Wrap(
              runSpacing: 12,
              spacing: 16,
              children: List.generate(
                hashtagList.length,
                (index) {
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            commonCachedNetworkImage(hashtagList[index].image!,
                                    height: 250,
                                    width: context.width() * 0.43,
                                    fit: BoxFit.cover)
                                .cornerRadiusWithClipRRect(16),
                            Container(
                              height: 250,
                              width: context.width() * 0.43,
                              decoration: boxDecorationWithRoundedCorners(
                                borderRadius: radius(16),
                                gradient: hashtagList[index].selectHash == true
                                    ? LinearGradient(colors: [
                                        primaryColor1.withOpacity(0.4),
                                        primaryColor2.withOpacity(0.4)
                                      ])
                                    : LinearGradient(colors: [
                                        transparentColor,
                                        transparentColor
                                      ]),
                              ),
                            ),
                            Icon(Icons.check_circle_outline,
                                size: 30,
                                color: hashtagList[index].selectHash == true
                                    ? white
                                    : transparentColor)
                          ],
                        ),
                        10.height,
                        Text(hashtagList[index].name!, style: boldTextStyle())
                            .paddingLeft(8),
                        Text(hashtagList[index].subtitle!,
                                style: secondaryTextStyle())
                            .paddingLeft(8),
                      ],
                    ),
                  ).onTap(() {
                    hashtagList[index].selectHash =
                        !hashtagList[index].selectHash!;
                    setState(() {});
                  });
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 4,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              width: context.width(),
              height: 50,
              decoration: boxDecorationWithShadow(
                  borderRadius: radius(24),
                  gradient:
                      LinearGradient(colors: [primaryColor1, primaryColor2])),
              child: Text("Let's start!".toUpperCase(),
                  style: boldTextStyle(color: white, size: 18)),
            ).onTap(() {
              // DTSignInScreen(name: widget.name).launch(context);
              navigatePage(context, className: SVDashboardScreen());
            }),
          ),
        ],
      ),
    );
  }
}

AppBar getAppBar(String title,
    {List<Widget>? actions,
    PreferredSizeWidget? bottom,
    bool center = true,
    Widget? titleWidget,
    double? elevation,
    Widget? backWidget}) {
  return AppBar(
    title: titleWidget ??
        Text(title, style: boldTextStyle(color: whiteColor, size: 18)),
    flexibleSpace: AppBarGradientWidget(),
    actions: actions,
    centerTitle: center,
    leading: backWidget,
    bottom: bottom,
    automaticallyImplyLeading: false,
    brightness: Brightness.dark,
    elevation: elevation,
  );
}

Widget commonCachedNetworkImage(
  String? url, {
  double? height,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
  double? radius,
  Color? color,
}) {
  if (url!.validate().isEmpty) {
    return placeHolderWidget(
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
    );
  } else {
    return Image.asset(url,
            height: height,
            width: width,
            fit: fit,
            alignment: alignment ?? Alignment.center)
        .cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget(
    {double? height,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    double? radius}) {
  return Image.asset('images/placeholder.jpg',
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          alignment: alignment ?? Alignment.center)
      .cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

class AppBarGradientWidget extends StatelessWidget {
  final Widget? child;

  AppBarGradientWidget({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor1,
            primaryColor2,
          ],
        ),
      ),
      child: child,
    );
  }
}

List<EACityModel> hashtagList = [
  EACityModel(
      name: "Music",
      subtitle: "New Music",
      image: "images/intro2.jpg",
      selectHash: false),
  EACityModel(
      name: "Bars",
      subtitle: "Alcohol & Parties",
      image: "images/intro1.jpg",
      selectHash: false),
  EACityModel(
      name: "Concerts",
      subtitle: "Music concerts",
      image: "images/concert.jpg",
      selectHash: false),
  EACityModel(
      name: "Sports",
      subtitle: "Events & posts",
      image: "images/intro6.jpg",
      selectHash: false),
  EACityModel(
      name: "Parties",
      subtitle: "House Parties",
      image: "images/intro3.jpg",
      selectHash: false),
  EACityModel(
      name: "Cinema",
      subtitle: "Movies and Cinema",
      image: "images/cinema.jpg",
      selectHash: false),
];

class EACityModel {
  String? name;
  String? subtitle;
  String? image;
  bool? selectHash;
  bool isSelected;

  EACityModel(
      {this.name,
      this.subtitle,
      this.image,
      this.selectHash = false,
      this.isSelected = false});
}
