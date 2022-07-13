import 'package:flutter/material.dart';
import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/http/controllers/userController.dart';
import 'package:brokerstreet/toast.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/screens/SVDashboardScreen.dart';
import 'package:brokerstreet/screens/auth/screens/SVForgetPasswordScreen.dart';
import 'package:brokerstreet/utils/SVColors.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

class SVLoginInComponent extends StatefulWidget {
  final VoidCallback? callback;

  SVLoginInComponent({this.callback});

  @override
  State<SVLoginInComponent> createState() => _SVLoginInComponentState();
}

class _SVLoginInComponentState extends State<SVLoginInComponent> {
  bool doRemember = false;
  late final TextEditingController _emailController, _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      color: context.cardColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            Text('Welcome back!', style: boldTextStyle(size: 24))
                .paddingSymmetric(horizontal: 16),
            8.height,
            Text('You Have Been Missed For Long Time',
                    style: secondaryTextStyle(
                        weight: FontWeight.w500, color: svGetBodyColor()))
                .paddingSymmetric(horizontal: 16),
            Container(
              child: Column(
                children: [
                  30.height,
                  AppTextField(
                    controller: _emailController,
                    textFieldType: TextFieldType.EMAIL,
                    textStyle: boldTextStyle(),
                    decoration: svInputDecoration(
                      context,
                      label: 'Email',
                      labelStyle: secondaryTextStyle(
                          weight: FontWeight.w600, color: svGetBodyColor()),
                    ),
                  ).paddingSymmetric(horizontal: 16),
                  16.height,
                  AppTextField(
                    controller: _passwordController,
                    textFieldType: TextFieldType.PASSWORD,
                    textStyle: boldTextStyle(),
                    suffixIconColor: svGetBodyColor(),
                    // suffixPasswordInvisibleWidget: Image.asset(
                    //         'images/socialv/icons/ic_Hide.png',
                    //         height: 16,
                    //         width: 16,
                    //         fit: BoxFit.fill)
                    //     .paddingSymmetric(vertical: 16, horizontal: 14),
                    // suffixPasswordVisibleWidget:
                    //     svRobotoText(text: 'Show', color: SVAppColorPrimary)
                    //         .paddingOnly(top: 20),
                    decoration: svInputDecoration(
                      context,
                      label: 'Password',
                      contentPadding: EdgeInsets.all(0),
                      labelStyle: secondaryTextStyle(
                          weight: FontWeight.w600, color: svGetBodyColor()),
                    ),
                  ).paddingSymmetric(horizontal: 16),
                  12.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Row(
                      //   children: [
                      //     Checkbox(
                      //       shape:
                      //           RoundedRectangleBorder(borderRadius: radius(2)),
                      //       activeColor: SVAppColorPrimary,
                      //       value: doRemember,
                      //       onChanged: (val) {
                      //         doRemember = val.validate();
                      //         setState(() {});
                      //       },
                      //     ),
                      //     svRobotoText(text: 'Remember Me'),
                      //   ],
                      // ),
                      svRobotoText(
                        text: 'Forget Password?',
                        color: SVAppColorPrimary,
                        fontStyle: FontStyle.italic,
                        onTap: () {
                          SVForgetPasswordScreen().launch(context);
                        },
                      ).paddingSymmetric(horizontal: 16),
                    ],
                  ),
                  32.height,
                  svAppButton(
                    context: context,
                    text: 'LOGIN',
                    onTap: () async {
                      showToast("Please wait", context);
                      // print(_usernameController.text);
                      var value = await userLogIn(_emailController.text);
                      // then((value) async {
                      if (value) {
                        showSuccessToast("Login sucess", context);
                        navigatePage(context, className: SVDashboardScreen());
                      } else {
                        showToast("check your email", context);
                      }
                      // });
                    },
                  ),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      svRobotoText(text: 'Don’t Have An Account?'),
                      4.width,
                      Text(
                        'Sign Up',
                        style: secondaryTextStyle(
                            color: SVAppColorPrimary,
                            decoration: TextDecoration.underline),
                      ).onTap(() {
                        widget.callback?.call();
                      },
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent)
                    ],
                  ),
                  50.height,
                  svRobotoText(text: 'OR Continue With'),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/socialv/icons/ic_Google.png',
                          height: 36, width: 36, fit: BoxFit.cover),
                      8.width,
                      Image.asset('images/socialv/icons/ic_Facebook.png',
                          height: 36, width: 36, fit: BoxFit.cover),
                      8.width,
                      Image.asset('images/socialv/icons/ic_Twitter.png',
                          height: 36, width: 36, fit: BoxFit.cover),
                    ],
                  ),
                  50.height,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
