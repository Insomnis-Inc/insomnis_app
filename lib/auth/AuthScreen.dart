import 'dart:io';

import 'package:brokerstreet/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with AutomaticKeepAliveClientMixin {
  bool _loginWithGoogle = false, _signUpWithGoogle = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double v16 = width / 20;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: context.cardColor,
        body: Container(
          width: width,
          height: height,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                color: APP_ACCENT,
                height: height * 0.5,
                padding: EdgeInsets.only(top: v16, bottom: height * 0.18),
                child: Center(
                  child: Image.asset(
                    'assets/images/intro/logo.png',
                    width: v16 * 4,
                    // color: REAL_BLACK,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: height * 0.7,
                  width: width,
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(v16 * 1.5),
                      topRight: Radius.circular(v16 * 1.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: v16 * 3,
                        child: TabBar(
                          isScrollable: true,
                          labelColor: APP_ACCENT,
                          unselectedLabelColor: APP_GREY,
                          tabs: [
                            Tab(
                              text: "Log In",
                            ),
                            Tab(
                              text: "Create Account",
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: v16, vertical: v16 * 0.8),
                                  margin: EdgeInsets.only(
                                      right: v16 * 2, left: v16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    // color: darken(Colors.white, 0.08),
                                    color: _loginWithGoogle
                                        ? APP_GREY.withOpacity(0.7)
                                        : Platform.isIOS
                                            ? REAL_BLACK
                                            : Color(0xffDD4B39)
                                                .withOpacity(0.7),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _loginWithGoogle
                                            ? CircularProgressIndicator(
                                                color: APP_ACCENT)
                                            : Image.asset(
                                                Platform.isIOS
                                                    ? 'assets/images/apple.png'
                                                    : 'assets/images/google.png',
                                                color: REAL_WHITE,
                                                width: v16 * 1.5,
                                              ),
                                      ],
                                    ),
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(
                                      top: v16 * 2, left: v16, right: v16 * 2),
                                  child: normalButton(
                                    v16: v16,
                                    title: "Log In With Email/Password",
                                    bgColor: APP_ACCENT,
                                    // callback: null,
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(
                                      top: v16 * 2, left: v16, right: v16 * 2),
                                  child: outlineButton(
                                    v16: v16,
                                    title: "Log In With Phone Number",
                                    textColor: APP_ACCENT,
                                    // callback: null,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: v16, vertical: v16 * 0.8),
                                  margin: EdgeInsets.only(
                                      right: v16 * 2, left: v16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    // color: darken(Colors.white, 0.08),
                                    color: _signUpWithGoogle
                                        ? APP_GREY.withOpacity(0.7)
                                        : Platform.isIOS
                                            ? REAL_BLACK
                                            : Color(0xffDD4B39)
                                                .withOpacity(0.7),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _signUpWithGoogle
                                            ? CircularProgressIndicator(
                                                color: APP_ACCENT)
                                            : Image.asset(
                                                Platform.isIOS
                                                    ? 'assets/images/apple.png'
                                                    : 'assets/images/google.png',
                                                color: REAL_WHITE,
                                                width: v16 * 1.5,
                                              ),
                                      ],
                                    ),
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(
                                      top: v16 * 2, left: v16, right: v16 * 2),
                                  child: normalButton(
                                    v16: v16,
                                    title: "Sign Up With Email/Password",
                                    bgColor: APP_ACCENT,
                                    // callback: null,
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(
                                      top: v16 * 2, left: v16, right: v16 * 2),
                                  child: outlineButton(
                                    v16: v16,
                                    title: "Sign Up With Phone Number",
                                    textColor: APP_ACCENT,
                                    // callback: null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
