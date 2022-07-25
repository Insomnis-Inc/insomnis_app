// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:brokerstreet/auth/AuthScreen.dart';
import 'package:brokerstreet/auth/intro.dart';
import 'package:brokerstreet/auth/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/store/AppStore.dart';
import 'package:brokerstreet/utils/AppTheme.dart';
import 'lab.dart';
import 'screens/SVDashboardScreen.dart';

AppStore appStore = AppStore();
// for registration details
const UserRegBox = 'userReg';
// box for everything else including country, currency, token
const TokenBox = "token";
const TutorialKey = 'isNewForTutorial';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await initialize();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox(UserRegBox);
  await Hive.openBox(TokenBox);
  appStore.toggleDarkMode(value: await retrieveDarkMode());

  bool status = await retrieveSignedIn();
  bool isVerified = await retrieveVerified();

  runApp(MyApp(status: status, isVerified: isVerified));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.status, required this.isVerified, Key? key})
      : super(key: key);
  final bool status;
  final bool isVerified;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Observer(
      builder: (_) => MaterialApp(
        scrollBehavior: SBehavior(),
        navigatorKey: navigatorKey,
        title: 'Insomnis',
        debugShowCheckedModeBanner: true,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        // home: GroupLab()
        home: status
            ? (isVerified ? SVDashboardScreen() : Register(verify: true))
            : IntroPage(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// Future<String> retrieveToken() async {
//   var box = Hive.box(TokenBox);
//   // print(box.get("id"));
//   return "${box.get("token")}";
// }

// saveToken(String token) {
//   // print(token);
//   var box = Hive.box(TokenBox);
//   box.put("token", token);
//   box.put("signedIn", true);
// }

Future<String> retrieveId() async {
  var box = Hive.box(TokenBox);
  print(box.get("id"));
  return "${box.get("id")}";
  // return '96caac87-00e5-4e08-9742-01bbfece6093';
}

saveId(String id) {
  // print(token);
  saveSignedIn(true);
  var box = Hive.box(TokenBox);
  box.put("id", id);
}

saveDarkMode(bool darkMode) {
  // print(token);
  var box = Hive.box(TokenBox);
  box.put("darkMode", darkMode);
}

Future<bool> retrieveDarkMode() async {
  var box = Hive.box(TokenBox);
  return box.get("darkMode") ?? false;
}

saveSignedIn(bool signedIn) {
  var box = Hive.box(TokenBox);
  box.put("signedIn", signedIn);
}

Future<bool> retrieveSignedIn() async {
  var box = Hive.box(TokenBox);
  return box.get("signedIn") ?? false;
}

saveVerified(bool verified) {
  var box = Hive.box(TokenBox);
  box.put("isVerified", verified);
}

Future<bool> retrieveVerified() async {
  var box = Hive.box(TokenBox);
  return box.get("isVerified") ?? false;
}

saveEmail(String email) {
  var box = Hive.box(TokenBox);
  box.put("email", email);
}

Future<String> retrieveEmail() async {
  var box = Hive.box(TokenBox);
  return box.get("email") ?? '';
}

// Future<String> retrieveServerKey() async {
//   var box = Hive.box(TokenBox);
//   // print(box.get("id"));
//   return "${box.get("serverKey")}";
// }

// saveServerKey(String serverKey) {
//   // print(token);
//   var box = Hive.box(TokenBox);
//   box.put("serverKey", serverKey);
// }

// testToken() {
//   var box = Hive.box(TokenBox);
//   box.put("token",
//       "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5NDczMzEzMS0zMWRiLTQxYjItYWRkYy0yMzI1YTNhNWMxYzAiLCJqdGkiOiI2MjZjYjc2YmM2ODliMmY0Mzk3M2E0YmY3NzQzYTgzNmYyZGRmNTUxOTJkYmUxNmI1NjUzN2I3ZDA0ODI3YWZmYzVkZjg0NjEzOGI2NmExMyIsImlhdCI6MTYzMzU2MzkxMSwibmJmIjoxNjMzNTYzOTExLCJleHAiOjE2NjUwOTk5MTEsInN1YiI6IjQ4ZDY4Y2Y4LTgxN2MtNDNjOC04MDBmLTc1MTU2YmYyOTFlOSIsInNjb3BlcyI6W119.pfU9IAviY03cjHuFEhLyLWUZk3183HMDx4E2DgI2-T8-FSiFI2TED9E6fNZGqk8FaN-pM-5m57O59NwchZI6cA151fYLAeIdwg2AGw0SPAF9T0YOSk7YPg19f6zcPsTC-8nyjyX4VzX7jGO4B5bwvWtFC7adgdc927oX8dS_H7PtpP0MU-yT76u4KYhgTb2x9KXO26QWhrdLqxidySNh2bF6sFQ5mkUrhN5y7Phxm4ltKy6G3xfwtQU626c4giB63uvq-JnIemw3OmnxKOCZyFKMXMdWKdmr2E4Z1r0KUpc1KxIS6PX7sNL2DOoRk44YFHlP9kunr5i_dAV44VlT-4WfKAbgidAVOnYDMnJa73fIJQzj5u1Cqrz3mBTrex1zZWG1ZhhXT88k8A5xS8WZz1gctnY-O9PHfnTi95Z5bgetFc1-2VADVc0ux35f-Ib7enosMSW6XZECFdGEvhE69g-Cnfiw5-Gzu03T9_UcWcHQrK59NGv_9AGLqMTPREAeZDCop2uPvQ2V33usSmn2EWh8xaXynGahCrOKBzUeT2TbxHmdpQYvnReRGv6WK-ujYSMkkv-weCY5XQgWbUK41uI6uf35vMhZexSqlN29RXhYAODrbGz7Y5mRltlOLxW2iFDP5WMw_nUHsNZLGTvz30mcOuPYWhDSxuPTfI01LCw");
//   box.put("id", "48d68cf8-817c-43c8-800f-75156bf291e9");
// }

logOutCustom(context) async {
  var box = Hive.box(TokenBox);
  await box.clear();
  // var _box = Hive.box(UserRegBox);
  // _box.clear();
  // var boxD = Hive.box(DownloadBox);
  // boxD.clear();
  // var boxC = Hive.box(CoinsBox);
  // boxC.clear();

  // // sign out
  // await fAuth.FirebaseAuth.instance.signOut();
  // // google sign out
  // GoogleSignIn googleSignIn = new GoogleSignIn();
  // await googleSignIn.signOut();

  // navigatePage(context, className: SVSplashScreen());

  ///
  /// todo
  ///
}
