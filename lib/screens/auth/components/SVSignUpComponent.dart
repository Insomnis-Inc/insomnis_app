// ignore_for_file: prefer_final_fields

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/http/controllers/userController.dart';
import 'package:brokerstreet/toast.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/screens/SVDashboardScreen.dart';
import 'package:brokerstreet/utils/SVColors.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

class SVSignUpComponent extends StatefulWidget {
  final VoidCallback? callback;

  SVSignUpComponent({this.callback});

  @override
  State<SVSignUpComponent> createState() => _SVSignUpComponentState();
}

class _SVSignUpComponentState extends State<SVSignUpComponent> {
  TextEditingController _usernameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _emailController = TextEditingController();
  String type = 'User';

  final List<String> items = [
    'Bar',
    'User',
    'Restaurant',
    'Hotel',
    'Apartment'
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      color: context.cardColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.height,
            Text('Hello User', style: boldTextStyle(size: 24))
                .paddingSymmetric(horizontal: 16),
            8.height,
            Text('Create Your Account For Better Experience',
                    style: secondaryTextStyle(
                        weight: FontWeight.w500, color: svGetBodyColor()))
                .paddingSymmetric(horizontal: 16),
            Container(
              child: Column(
                children: [
                  16.height,
                  AppTextField(
                    controller: _usernameController,
                    textFieldType: TextFieldType.NAME,
                    textStyle: boldTextStyle(),
                    decoration: svInputDecoration(
                      context,
                      label: 'Username',
                      labelStyle: secondaryTextStyle(
                          weight: FontWeight.w600, color: svGetBodyColor()),
                    ),
                  ).paddingSymmetric(horizontal: 16),
                  8.height,
                  AppTextField(
                    controller: _emailController,
                    textFieldType: TextFieldType.EMAIL,
                    textStyle: boldTextStyle(),
                    decoration: svInputDecoration(
                      context,
                      label: 'Your Email',
                      labelStyle: secondaryTextStyle(
                          weight: FontWeight.w600, color: svGetBodyColor()),
                    ),
                  ).paddingSymmetric(horizontal: 16),
                  12.height,
                  AppTextField(
                    controller: _passwordController,
                    textFieldType: TextFieldType.PASSWORD,
                    textStyle: boldTextStyle(),
                    suffixIconColor: svGetBodyColor(),
                    suffixPasswordInvisibleWidget: Image.asset(
                            'images/socialv/icons/ic_Hide.png',
                            height: 16,
                            width: 16,
                            fit: BoxFit.fill)
                        .paddingSymmetric(vertical: 16, horizontal: 14),
                    suffixPasswordVisibleWidget:
                        svRobotoText(text: 'Show', color: SVAppColorPrimary)
                            .paddingOnly(top: 20),
                    decoration: svInputDecoration(
                      context,
                      label: 'Password',
                      contentPadding: EdgeInsets.all(0),
                      labelStyle: secondaryTextStyle(
                          weight: FontWeight.w600, color: svGetBodyColor()),
                    ),
                  ).paddingSymmetric(horizontal: 16),
                  8.height,
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: Text(
                        'Select Account type',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: type,
                      onChanged: (value) {
                        setState(() {
                          type = value as String;
                        });
                      },
                      // buttonHeight: 40,
                      // buttonWidth: 140,
                      itemHeight: 40,
                    ),
                  ),
                  // AppTextField(
                  //   textFieldType: TextFieldType.PHONE,
                  //   decoration: svInputDecoration(
                  //     context,
                  //     label: 'Contact Number',
                  //     prefix: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Text('+144', style: boldTextStyle(size: 14)),
                  //         6.width,
                  //         Icon(Icons.keyboard_arrow_down,
                  //             size: 16, color: svGetBodyColor()),
                  //       ],
                  //     ),
                  //     labelStyle: secondaryTextStyle(
                  //         weight: FontWeight.w600, color: svGetBodyColor()),
                  //   ),
                  // ).paddingSymmetric(horizontal: 16),
                  80.height,
                  svAppButton(
                    context: context,
                    text: 'SIGN UP',
                    onTap: () async {
                      showToast("Please wait", context);
                      var value = await userSignUp(
                        username: _usernameController.text,
                        type: type,
                        email: _emailController.text,
                      );
                      // .then((value) async {
                      if (value) {
                        // navigatePage(context, className: SVDashboardScreen());
                        showSuccessToast("Account created", context);
                        await Future.delayed(const Duration(seconds: 3));
                        navigatePage(context, className: SVDashboardScreen());
                      } else {
                        showToast("try again please", context);
                      }
                      // });
                    },
                  ),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      svRobotoText(text: 'Already Have An Account?'),
                      4.width,
                      Text(
                        'Sign In',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
