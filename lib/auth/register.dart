import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:brokerstreet/http/controllers/userController.dart';
import 'package:brokerstreet/screens/SVDashboardScreen.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brokerstreet/toast.dart';

import '../custom_colors.dart';
import '../main.dart';
import '../screens/EASelectHashtagScreen.dart';

class Register extends StatefulWidget {
  const Register({Key? key, this.verify = false}) : super(key: key);
  final bool verify;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late PageController _pageController;
  bool _obscure = true, _obscure2 = true, _isLoading2 = false;
  TextEditingController _pswdController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _confirmPswdController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  // TextEditingController _phoneController = TextEditingController();

  int _verifyPage = 2;

  var _box, _tokenBox;
  bool _isLoading = false;
  bool registerLoading = false;
  bool verifyLoading = false;
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

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: widget.verify ? _verifyPage : 0);
  }

  _pageAnimate(int pageIndex) {
    _pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 700), curve: Curves.easeIn);
  }

  _validateEmailAndPassword() {
    //
    String _pswd = _pswdController.text.trim();
    String _pswd2 = _confirmPswdController.text.trim();
    String _eml = _emailController.text.trim();
    FocusScope.of(context).unfocus();

    if (_pswd != _pswd2) {
      showErrorToast("Passwords don't match", context);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_pswd.length < 7) {
      showErrorToast("Password should be atleast 8 characters", context);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (!_eml.contains('@')) {
      showErrorToast("Enter a valid email", context);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    _pageAnimate(1);
  }

  _registerUser() async {
    setState(() {
      _isLoading = true;
    });
    String _pswd = _pswdController.text.trim();
    String _eml = _emailController.text.trim();
    String _name = _nameController.text.trim();
    FocusScope.of(context).unfocus();

    if (_name.length < 2) {
      showErrorToast("Name is too short", context);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _eml, password: _pswd);
      User? user = FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showErrorToast("The password provided is too weak", context);
        setState(() {
          _isLoading = false;
        });
        return;
      } else if (e.code == 'email-already-in-use') {
        showErrorToast("The account already exists for that email", context);
        setState(() {
          _isLoading = false;
        });
        return;
      }
    } catch (e) {
      print(e);
      showErrorToast(
          "Problem creating account, check your connection", context);
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
                email: _emailController.text,
                username: _nameController.text,
                type: type)
            .then((value) => route(value, "Check your connection & try again"));
        // if (!user.emailVerified) {
        //   // await user.sendEmailVerification();
        //   // print('email sent');
        //   // box.put("verifyPage", true);
        //   // Provider.of<SplashProvider>(context, listen: false).setVerify();

        //   _pageController.animateToPage(
        //     _verifyPage,
        //     duration: Duration(milliseconds: 700),
        //     curve: Curves.easeIn,
        //   );
        // } else {
        //   showToast("Please login instead", context);
        //   setState(() {
        //     _isLoading = false;
        //   });
        //   return;
        // }
      }
    });
  }

  onVerifiedComplete(User user) async {
    // setState(() {
    //   verifyLoading = true;
    // });

    // String _phoneText = _phoneController.text.trim();
    // String _phoneNumber = _countryDialCode + _phoneText;

    // register.fName = _nameController.text.trim();
    // register.lName = "_";
    // register.email = user.email;
    // register.password = '_';
  }

  route(bool isRoute, String errorMessage) async {
    if (isRoute) {
      navigatePage(context, className: EASelectHashtagScreen());
    } else {
      showErrorToast(errorMessage, context);
      setState(() {
        verifyLoading = false;
      });
    }
  }

  sendLink() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.sendEmailVerification();
    showToast("Link sent, check your email", context);
    return;
  }

  checkVerified() async {
    setState(() {
      _isLoading2 = true;
    });
    User? user1 = FirebaseAuth.instance.currentUser;
    await user1!.reload();
    User? user = FirebaseAuth.instance.currentUser;
    await user!.reload();

    if (user.emailVerified) {
      showSuccessToast("Email Verified", context);
      // Provider.of<SplashProvider>(context, listen: false)
      // .showVerify()

      // onVerifiedComplete(user);
      saveVerified(true);
      navigatePage(context, className: SVDashboardScreen());
      // Navigator.push(context,
      //     CupertinoPageRoute(builder: (context) => LocationSelectCountry()));
    } else {
      showErrorToast("Double tap, verified", context);
      setState(() {
        _isLoading2 = false;
      });
      return;
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
            //       'assets/images/bg/sneakers.png',
            //       width: v16 * 7,
            //     ),
            //   ),
            // ),
            PageView(
              controller: _pageController,
              children: [
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
                      margin: EdgeInsets.only(top: v16 * 1.5),
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
                    Container(
                      margin: EdgeInsets.only(top: v16 * 1.5),
                      child: TextField(
                        autofocus: false,
                        controller: _pswdController,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300],
                          hintText: "Password",
                          hintStyle: TextStyle(color: APP_GREY),
                          focusColor: APP_PRIMARY,
                          border: outlineInputBorder,
                          focusedBorder: outlineInputBorder,
                          enabledBorder: outlineInputBorder,
                          errorBorder: outlineInputBorder,
                          disabledBorder: outlineInputBorder,
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 8),
                              child: _obscure
                                  ? Icon(
                                      Icons.visibility,
                                      // size: 22,
                                      // color: DARK_GREY,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      // size: 22,
                                      // color: DARK_GREY,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: v16 * 1.5),
                      child: TextField(
                        autofocus: false,
                        controller: _confirmPswdController,
                        obscureText: _obscure2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300],
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(color: APP_GREY),
                          focusColor: APP_PRIMARY,
                          border: outlineInputBorder,
                          focusedBorder: outlineInputBorder,
                          enabledBorder: outlineInputBorder,
                          errorBorder: outlineInputBorder,
                          disabledBorder: outlineInputBorder,
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscure2 = !_obscure2;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 8),
                              child: _obscure2
                                  ? Icon(
                                      Icons.visibility,
                                      // size: 22,
                                      // color: DARK_GREY,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      // size: 22,
                                      // color: DARK_GREY,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _validateEmailAndPassword(),
                      child: Container(
                        margin:
                            EdgeInsets.only(top: v16 * 1.5, right: v16 * 2.4),
                        child: normalButton(
                          v16: v16,
                          title: "Next",
                          bgColor: APP_ACCENT,
                          // callback: null,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: v16 * 1.5, bottom: v16 * 2),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
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

                // SECOND PAGE
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
                          left: v16 / 2,
                          right: v16 / 2,
                          bottom: v16 / 2,
                          top: v16 / 2),
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
                        margin:
                            EdgeInsets.only(top: v16 * 1.5, right: v16 * 2.4),
                        child: normalButton(
                          v16: v16,
                          title: _isLoading ? "loading..." : "Create Account",
                          bgColor: _isLoading ? APP_GREY : APP_ACCENT,
                          // callback: null,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: v16 * 1.5, bottom: v16 * 2),
                      child: InkWell(
                        onTap: () => _isLoading ? null : _pageAnimate(0),
                        child: Text(
                          "back",
                          style: normalTextStyle.copyWith(
                            color: LIGHT_BLUE,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  padding: EdgeInsets.all(v16),
                  children: <Widget>[
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
                      margin: EdgeInsets.only(top: v16, bottom: v16),
                      child: Text(
                        "Click below to receive an email verification link",
                        style: normalTextStyle,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => sendLink(),
                      child: Container(
                        margin: EdgeInsets.only(right: v16 * 1.8),
                        child: outlineButton(
                          v16: v16,
                          textColor: APP_ACCENT,
                          title: "Send link",
                          border: Border.all(color: APP_ACCENT, width: 1.2),
                          // callback: null,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: v16 * 2, bottom: v16),
                      child: Text(
                        "Click below after verification",
                        style: normalTextStyle,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => checkVerified(),
                      child: Container(
                        margin: EdgeInsets.only(right: v16 * 3),
                        child: normalButton(
                          v16: v16,
                          title: _isLoading2 ? "loading..." : "I have Verified",
                          bgColor: _isLoading2 ? APP_GREY : APP_ACCENT,
                          // callback: null,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            verifyLoading
                ? Positioned.fill(
                    child: FadeInRight(
                      duration: Duration(milliseconds: 400),
                      child: Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                          color: REAL_BLACK.withOpacity(0.7),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(v16 * 0.8),
                                decoration: BoxDecoration(
                                    color: REAL_WHITE,
                                    borderRadius: BorderRadius.circular(12)),
                                child: CircularProgressIndicator(
                                    color: APP_ACCENT)),
                            Padding(
                              padding: EdgeInsets.only(top: v16),
                              child: Text(
                                "Creating Account",
                                style: normalTextStyle.copyWith(
                                  color: REAL_WHITE,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
