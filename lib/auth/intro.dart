import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:brokerstreet/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../custom_colors.dart';
import 'login.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double v16 = width / 20;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          width: width,
          height: height,
          child: PageView(
            controller: _pageController,
            children: [
              introSlide(
                  height: height,
                  pageIndex: 0,
                  text: "A little joy & party doesn't hurt",
                  imageNumber: 2,
                  width: width,
                  v16: v16,
                  textAlign: TextAlign.end),
              introSlide(
                  height: height,
                  text: "To beer, or not to beer, that is a silly question.",
                  pageIndex: 1,
                  imageNumber: 3,
                  width: width,
                  v16: v16,
                  textAlign: TextAlign.center),
              introSlide(
                  height: height,
                  text: "Join the Community",
                  imageNumber: 1,
                  width: width,
                  pageIndex: 2,
                  v16: v16,
                  isLast: true,
                  textAlign: TextAlign.start),
            ],
          ),
        ),
      ),
    );
  }

  Stack introSlide(
      {required double height,
      required double width,
      required TextAlign textAlign,
      required int imageNumber,
      required int pageIndex,
      required String text,
      bool isLast = false,
      required double v16}) {
    return Stack(
      alignment:
          textAlign == TextAlign.center ? Alignment.center : Alignment.topLeft,
      children: [
        //
        Positioned.fill(
            child: Image.asset(
          'assets/images/intro/intro$imageNumber.jpg',
          fit: BoxFit.cover,
        )),

        Positioned(
            right: textAlign == TextAlign.end ? 0 : null,
            left: textAlign == TextAlign.start ? 0 : null,
            child: FadeInRight(
              delay: Duration(milliseconds: 180),
              duration: Duration(milliseconds: 1000),
              child: Container(
                height: height,
                width: width * 0.44,
                child: new ClipRect(
                  child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: new Container(
                      width: width * 0.54,
                      height: height,
                      decoration: new BoxDecoration(
                          color: Colors.grey.shade200.withOpacity(0.3)),
                    ),
                  ),
                ),
              ),
            )),

        Positioned.fill(
          child: FadeInLeft(
            delay: Duration(milliseconds: 180),
            duration: Duration(milliseconds: 1000),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: v16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: textAlign == TextAlign.end
                    ? CrossAxisAlignment.end
                    : textAlign == TextAlign.start
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                children: [
                  //
                  Image.asset(
                    'assets/images/intro/logo.png',
                    width: v16 * 1.8,
                  ),
                  Container(
                    width: width * 0.7,
                    padding: EdgeInsets.only(bottom: v16 * 0.5),
                    child: Text(
                      text,
                      textAlign: textAlign,
                      style: titleTextStyle.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 24,
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: REAL_WHITE),
                    ),
                  ),
                  if (!isLast)
                    IconButton(
                        onPressed: () {
                          _pageController.animateToPage(pageIndex + 1,
                              duration: Duration(milliseconds: 700),
                              curve: Curves.easeIn);
                        },
                        icon: Icon(Icons.arrow_forward_rounded,
                            color: REAL_WHITE)),

                  if (isLast) ...[
                    //
                    Container(
                      width: width * 0.7,
                      child: InkWell(
                        onTap: () => navigatePage(context, className: Login()),
                        child: normalIntroButton(
                            v16: v16, bgColor: APP_ACCENT, title: 'Login '),
                      ),
                    ),

                    Container(
                      width: width * 0.7,
                      child: InkWell(
                        onTap: () =>
                            navigatePage(context, className: Register()),
                        child: outlineIntroButton(
                            v16: v16, textColor: REAL_WHITE, title: "Sign Up"),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container normalIntroButton(
      {required double v16, required Color bgColor, required String title}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: v16 * 0.8, horizontal: v16 * 2),
      margin: EdgeInsets.only(right: v16, bottom: v16, top: v16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: bgColor,
      ),
      child: Center(
          child: Text(
        title,
        style: normalTextStyle.copyWith(color: REAL_WHITE, fontSize: 15),
      )),
    );
  }

  Container outlineIntroButton(
      {required double v16,
      Border? border,
      required Color textColor,
      required String title}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: v16 * 0.76, horizontal: v16 * 2),
      margin: EdgeInsets.only(
        right: v16 * 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
        border: border ?? Border.all(color: textColor, width: 1.4),
      ),
      child: Center(
          child: Text(
        title,
        style: normalTextStyle.copyWith(color: textColor, fontSize: 15),
      )),
    );
  }
}
