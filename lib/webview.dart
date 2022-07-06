// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_local_variable

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:brokerstreet/toast.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}
// flutter_inappwebview: ^5.4.3+7

class _NewsFeedState extends State<NewsFeed> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double v16 = width / 20;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.only(top: v16),
          child: InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse(
                    "https://kordgram.com/api/set-browser-cookie?access_token=99398b9712c94bd6dc167099368164abb8a0e222edb317a80bbf538cee88660d14a5ae309468781291a575b38c7c4526decc579655a2a49c"),
                method: 'POST',
                body: Uint8List.fromList(utf8.encode("server_key=ad8e72a4670a5a4e023881c127df289a")),
                headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
            onWebViewCreated: (controller) {
              showToast("msg", context);
            },
          ),
        ),
      ),
    );
  }
}
