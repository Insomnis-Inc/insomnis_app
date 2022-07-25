import 'package:brokerstreet/toast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../custom_colors.dart';
import '../http/controllers/userController.dart';
import '../screens/EASelectHashtagScreen.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen(this.email, {Key? key}) : super(key: key);
  final String email;

  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  TextEditingController _nameController = TextEditingController();

  // TextEditingController _phoneController = TextEditingController();

  int _verifyPage = 2;

  var _box, _tokenBox;
  bool _isLoading = false;
  bool registerLoading = false;
  String _countryDialCode = "+256";
  // RegisterModel register = RegisterModel();

  String type = 'User';

  final List<String> items = [
    'Bar',
    'User',
    'Restaurant',
    'Hotel',
    'Apartment'
  ];

  _registerUser() async {
    setState(() {
      _isLoading = true;
    });
    String _name = _nameController.text.trim();
    FocusScope.of(context).unfocus();

    if (_name.length < 3) {
      showErrorToast("Name is too short", context);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        // print('User is currently signed out!');
        // return;
      } else {
        print('User is signed in!');
        //box.put('name', _username);  follow up
        // box.put('email', user.email);
        await userSignUp(
                email: widget.email, username: _nameController.text, type: type)
            .then((value) => route(value, "Check your connection & try again"));
      }
    });
  }

  route(bool isRoute, String errorMessage) async {
    if (isRoute) {
      navigatePage(context, className: EASelectHashtagScreen());
    } else {
      showErrorToast(errorMessage, context);
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
        child: ListView(
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
              margin: EdgeInsets.only(top: v16 * 1.5),
              child: TextField(
                controller: _nameController,
                autofocus: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: "Set username",
                  hintStyle: TextStyle(color: APP_GREY),
                  focusColor: APP_PRIMARY,
                  border: outlineInputBorder,
                  focusedBorder: outlineInputBorder,
                  enabledBorder: outlineInputBorder,
                  errorBorder: outlineInputBorder,
                  disabledBorder: outlineInputBorder,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: v16 * 1.5),
              padding: EdgeInsets.only(
                  left: v16 / 2, right: v16 / 2, bottom: v16 / 2, top: v16 / 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: SHIMMER_DARK),
                  color: Colors.grey[300]),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: SHIMMER_DARK),
                  ),
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
            ),
            // Container(
            //   margin: EdgeInsets.only(top: v16 * 1.5),
            //   child: Row(
            //     children: [
            //       CodePickerWidget(
            //         onChanged: (CountryCode countryCode) {
            //           _countryDialCode = countryCode.dialCode;
            //         },
            //         initialSelection: _countryDialCode,
            //         favorite: [_countryDialCode],
            //         showDropDownButton: true,
            //         padding: EdgeInsets.zero,
            //         showFlagMain: true,
            //         textStyle: normalTextStyle,
            //       ),
            //       Expanded(
            //         child: Container(
            //           child: TextField(
            //             controller: _phoneController,
            //             autofocus: false,
            //             keyboardType: TextInputType.number,
            //             decoration: InputDecoration(
            //               filled: true,
            //               fillColor: Colors.grey[300],
            //               hintText: "Phone",
            //               hintStyle: TextStyle(color: APP_GREY),
            //               focusColor: APP_PRIMARY,
            //               border: outlineInputBorder,
            //               focusedBorder: outlineInputBorder,
            //               enabledBorder: outlineInputBorder,
            //               errorBorder: outlineInputBorder,
            //               disabledBorder: outlineInputBorder,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            GestureDetector(
              onTap: () => _isLoading ? null : _registerUser(),
              child: Container(
                margin: EdgeInsets.only(top: v16 * 1.5, right: v16 * 2.4),
                child: normalButton(
                  v16: v16,
                  title: _isLoading ? "loading..." : "Create Account",
                  bgColor: _isLoading ? APP_GREY : APP_ACCENT,
                  // callback: null,
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(top: v16 * 1.5, bottom: v16 * 2),
            //   child: InkWell(
            //     onTap: () => _isLoading ? null : _pageAnimate(0),
            //     child: Text(
            //       "back",
            //       style: normalTextStyle.copyWith(
            //         color: LIGHT_BLUE,
            //         decoration: TextDecoration.underline,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
