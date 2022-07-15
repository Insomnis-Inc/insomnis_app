import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brokerstreet/toast.dart';

import '../custom_colors.dart';
import 'register.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();

  // bool _verified = false;
  var _box, _tokenBox;
  bool _loading = false;
  bool registerLoading = false;

  Future<void> resetPassword() async {
    String email = _emailController.text;
    setState(() {
      _loading = true;
    });
    if (!email.trim().contains("@")) {
      showErrorToast("Enter valid email", context);
      return;
    }

    _emailController.clear();
    FocusScope.of(context).unfocus();
    var mAuth = FirebaseAuth.instance;

    try {
      await mAuth.sendPasswordResetEmail(email: email).then((value) {
        showSuccessToast("Check your Email", context);
        setState(() {
          _loading = false;
        });
        Navigator.pop(context);
      });
    } catch (e) {
      showErrorToast('Problem Resetting Password', context);
      setState(() {
        _loading = false;
      });
      return;
      // print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double v16 = width / 20;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            // Positioned(
            //   bottom: v16 * 0.5,
            //   right: v16 * 2,
            //   child: Transform.scale(
            //     scale: 1.7,
            //     child: Image.asset(
            //       'assets/images/bg/heel1.png',
            //       width: v16 * 4,
            //       color: REAL_BLACK.withAlpha(65),
            //     ),
            //   ),
            // ),
            ListView(
              padding: EdgeInsets.all(v16),
              children: [
                Container(
                  margin: EdgeInsets.only(top: v16 * 3),
                  child: Center(
                    child: Image.asset(
                      'assets/images/intro/logo.png',
                      width: v16 * 4,
                      // color: REAL_BLACK,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: v16, bottom: v16 * 0.5),
                  child: Text(
                    "Enter email for password reset instructions",
                    style: normalTextStyle,
                  ),
                ),
                Container(
                  child: TextField(
                    controller: _emailController,
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: "Email",
                      hintStyle: TextStyle(color: APP_GREY),
                      focusColor: APP_PRIMARY,
                      border: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                      enabledBorder: outlineInputBorder,
                      errorBorder: outlineInputBorder,
                      disabledBorder: outlineInputBorder,
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => resetPassword(),
                  child: Container(
                    margin: EdgeInsets.only(top: v16, right: v16 * 2.4),
                    child: normalButton(
                      v16: v16,
                      title: _loading ? "loading..." : "Reset",
                      bgColor: _loading ? APP_GREY : APP_ACCENT,
                      // callback: null,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: EdgeInsets.only(top: v16 * 1.5, bottom: v16 * 2),
                    child: Text(
                      "Login",
                      style: normalTextStyle.copyWith(
                        color: LIGHT_BLUE,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
