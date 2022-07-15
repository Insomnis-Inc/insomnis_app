// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:brokerstreet/toast.dart';

// class ForgotPassword extends StatefulWidget {
//   @override
//   _ForgotPasswordState createState() => _ForgotPasswordState();
// }

// class _ForgotPasswordState extends State<ForgotPassword> {
//   bool _obscure = true;
//   TextEditingController _emailController = TextEditingController();

//   Future<void> resetPassword() async {
//     String email = _emailController.text;
//     if (!email.trim().contains("@")) {
//       showErrorToast("Enter valid email", context);
//       return;
//     }

//     _emailController.clear();
//     FocusScope.of(context).unfocus();
//     var mAuth = FirebaseAuth.instance;

//     try {
//       await mAuth.sendPasswordResetEmail(email: email).then((value) {
//         showToast("Check your Email", context);
//       });
//     } catch (e) {
//       showErrorToast('Problem Resetting Password', context);
//       return;
//       // print(e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     double v16 = width / 20;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         backgroundColor: REAL_WHITE,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Icon(
//             Icons.arrow_back_ios,
//             color: APP_ACCENT,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 2,
//         title: Text(
//           "Reset Password",
//           style: TextStyle(color: APP_ACCENT, fontWeight: FontWeight.w500),
//         ),
//       ),
//       body: Container(
//         width: width,
//         height: height,
//         child: ListView(
//           padding: EdgeInsets.all(v16),
//           children: [
//             Container(
//               child: Text(
//                 "Enter email for password reset instructions",
//                 style: normalTextStyle,
//               ),
//             ),
//             Container(
//               child: TextField(
//                 autofocus: false,
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                     focusColor: APP_PRIMARY,
//                     prefixIcon: Icon(Icons.email_outlined),
//                     border: OutlineInputBorder(
//                       gapPadding: 2,
//                       borderSide: BorderSide(color: Colors.black, width: 2),
//                     )),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(top: v16),
//               child: InkWell(
//                 onTap: () => resetPassword(),
//                 child: normalButton(
//                   v16: v16,
//                   title: "Reset",
//                   bgColor: APP_ACCENT,
//                   // callback: null,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
