import 'dart:io';

import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/http/controllers/userController.dart';
import 'package:brokerstreet/screens/SVDashboardScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/EASelectHashtagScreen.dart';
import '../toast.dart';
import 'forgot_password.dart';
import 'google_signin.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscure = true;
  TextEditingController _pswdController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _loading = false, _loading2 = false, _loginError = false;
  bool registerLoading = false;
  // RegisterModel register = RegisterModel();

  @override
  void initState() {
    super.initState();
    // _emailController.text =
    //     Provider.of<AuthProvider>(context, listen: false).getUserEmail() ??
    //         null;
    // _pswdController.text =
    //     Provider.of<AuthProvider>(context, listen: false).getUserPassword() ??
    //         null;
  }

  _googleSignIn() async {
    setState(() {
      _loading2 = true;
    });
    try {
      UserCredential _userCredential = await signInWithGoogle();
    } catch (e) {
      print('########### GSIGN: ${e.toString()} ##############');
      showErrorToast(
          "Problem signing in with Google, check your connection", context);
      setState(() {
        _loading2 = false;
      });
      return;
    }
    //todo go ahead check if account exists then show him so he can be a seller
    User? user = FirebaseAuth.instance.currentUser;
    // await Provider.of<AuthProvider>(context, listen: false)
    //     .login(user.email, route);
    // userLogIn();
    await userLogIn(user!.email!)
        .then((value) => route(value, "Check your connection & try again"));
    if (_loginError) {
      // if (result.contains('404')) {
      // new user
      // register.fName = user.displayName;
      // register.lName = "_";
      // register.email = user.email;
      // register.phone = user.phoneNumber ?? '_';
      // register.password = '_';
      // await Provider.of<AuthProvider>(context, listen: false)
      //     .newRegistration(register, route);
    }
  }

  _signIn() async {
    setState(() {
      _loading = true;
    });

    String _email = _emailController.text.trim();
    String _password = _pswdController.text.trim();
    if (!_email.contains('@')) {
      showErrorToast("Enter a valid email", context);
      setState(() {
        _loading = false;
      });
      return;
    }
    FocusScope.of(context).unfocus();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);

      User? user = userCredential.user;
      // User user = FirebaseAuth.instance.currentUser;
      bool _verified = await _verify(user!);
      print("After verify check");
      if (_verified) {
        // Provider.of<AuthProvider>(context, listen: false)
        //     .saveUserEmail(_email, _password);
        // await Provider.of<AuthProvider>(context, listen: false)
        //     .login(_email, route);
        print("to server check");
        await userLogIn(_email)
            .then((value) => route(value, "Check your connection & try again"));
      } else {
        // go to your email and come back
        // leave this empty
      }
    } on FirebaseAuthException catch (e) {
      // print(e.toString());
      if (e.code == 'user-not-found') {
        showErrorToast("User not found for that email", context);
        setState(() {
          _loading = false;
        });
        return;
      } else if (e.code == 'wrong-password') {
        showErrorToast("Wrong password for that email", context);
        setState(() {
          _loading = false;
        });
        return;
      }
    }
  }

  route(bool isRoute, String errorMessage) async {
    if (isRoute) {
      // await Provider.of<ProfileProvider>(context, listen: false)
      //     .getUserInfo(context);
      navigatePage(context, className: EASelectHashtagScreen());
    } else {
      // showErrorToast(errorMessage, context);
      setState(() {
        _loginError = true;
      });
    }
  }

  _verify(User user) async {
    user.reload();
    if (user.emailVerified) {
      return true;
    }
    try {
      await user.sendEmailVerification();
      showToast("Check your email to verify", context);
      return false;
    } catch (e) {
      showErrorToast("Error verifying email", context);
      return false;
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
                  margin: EdgeInsets.only(top: v16),
                  child: GestureDetector(
                    // onTap: () => _loading2
                    //     ? null
                    //     : Platform.isIOS
                    //         ? _appleSignIn()
                    //         : _googleSignIn(),
                    onTap: () => _loading2 ? null : _googleSignIn(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: v16, vertical: v16 * 0.8),
                      margin: EdgeInsets.only(right: v16 * 1.4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // color: darken(Colors.white, 0.08),
                        color: _loading2
                            ? APP_GREY.withOpacity(0.7)
                            : Platform.isIOS
                                ? REAL_BLACK
                                : Color(0xffDD4B39).withOpacity(0.7),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _loading2
                                ? CircularProgressIndicator(color: APP_ACCENT)
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
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: v16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        width: v16 * 4,
                        height: 1,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2)),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: v16),
                        child: Text("or log in with", style: normalTextStyle),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        width: v16 * 4,
                        height: 1,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2)),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(top: v16),
                //   child: Text("Email", style: normalTextStyle),
                // ),
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
                      prefixIcon: Icon(Icons.email_outlined),
                      border: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                      enabledBorder: outlineInputBorder,
                      errorBorder: outlineInputBorder,
                      disabledBorder: outlineInputBorder,
                    ),
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.only(top: v16),
                //   child: Text("Password", style: normalTextStyle),
                // ),
                Container(
                  margin: EdgeInsets.only(top: v16),
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
                      prefixIcon: Icon(Icons.lock_outline),
                      border: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                      enabledBorder: outlineInputBorder,
                      errorBorder: outlineInputBorder,
                      disabledBorder: outlineInputBorder,
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
                GestureDetector(
                  onTap: () =>
                      navigatePage(context, className: ForgotPassword()),
                  child: Container(
                    padding: EdgeInsets.only(top: v16),
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password?",
                      style: normalTextStyle.copyWith(color: APP_PRIMARY),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _loading ? null : _signIn(),
                  child: Container(
                    margin: EdgeInsets.only(top: v16, right: v16 * 2.4),
                    child: normalButton(
                      v16: v16,
                      title: _loading ? "loading..." : "Log In",
                      bgColor: _loading ? APP_GREY : APP_ACCENT,
                      // callback: null,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: v16 * 1.5, bottom: v16 * 2),
                  child: InkWell(
                    onTap: () => navigatePage(context, className: Register()),
                    child: Text(
                      "Create Account",
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
