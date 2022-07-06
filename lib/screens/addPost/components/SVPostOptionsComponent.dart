// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brokerstreet/custom_colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/utils/SVCommon.dart';
import 'package:brokerstreet/utils/SVConstants.dart';

class SVPostOptionsComponent extends StatefulWidget {
  final ImagePicker picker;
  SVPostOptionsComponent(this.picker);
  @override
  State<SVPostOptionsComponent> createState() => _SVPostOptionsComponentState();
}

class _SVPostOptionsComponentState extends State<SVPostOptionsComponent> {
  List<String> list = [
    'images/socialv/posts/post_one.png',
    'images/socialv/posts/post_two.png',
    'images/socialv/posts/post_three.png',
    'images/socialv/postImage.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: svGetScaffoldColor(),
        borderRadius: radiusOnly(
            topRight: SVAppContainerRadius, topLeft: SVAppContainerRadius),
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    // Capture a photo
                    final XFile? photo = await widget.picker
                        .pickImage(source: ImageSource.camera);
                    File(photo!.path);
                  },
                  child: Container(
                    // height: 62,
                    // width: 52,
                    // color: context.cardColor,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: CircleAvatar(
                      radius: 24,
                      // backgroundColor: ,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 24,
                        color: REAL_WHITE,
                      ),
                    ),
                    // child: ,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await svGetImageSource();
                  },
                  child: Container(
                    // height: 62,
                    // width: 52,
                    // color: context.cardColor,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: CircleAvatar(
                      radius: 24,
                      // backgroundColor: ,
                      child: Icon(
                        EvaIcons.imageOutline,
                        size: 24,
                        color: REAL_WHITE,
                      ),
                    ),
                    // child: ,
                  ),
                ),

                InkWell(
                  onTap: () async {
                    await svGetImageSource();
                  },
                  child: Container(
                    // height: 62,
                    // width: 52,
                    // color: context.cardColor,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: CircleAvatar(
                      radius: 24,
                      // backgroundColor: ,
                      child: Icon(
                        EvaIcons.videoOutline,
                        size: 24,
                        color: REAL_WHITE,
                      ),
                    ),
                    // child: ,
                  ),
                ),
                // HorizontalList(
                //   itemCount: list.length,
                //   itemBuilder: (context, index) {
                //     return Image.asset(list[index],
                //         height: 62, width: 52, fit: BoxFit.cover);
                //   },
                // )
              ],
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Image.asset('images/socialv/icons/ic_Video.png',
          //         height: 32, width: 32, fit: BoxFit.cover),
          //     //Image.asset('images/socialv/icons/ic_CameraPost.png', height: 32, width: 32, fit: BoxFit.cover),
          //     Image.asset('images/socialv/icons/ic_Voice.png',
          //         height: 32, width: 32, fit: BoxFit.cover),
          //     Image.asset('images/socialv/icons/ic_Location.png',
          //         height: 32, width: 32, fit: BoxFit.cover),
          //     Image.asset('images/socialv/icons/ic_Paper.png',
          //         height: 32, width: 32, fit: BoxFit.cover),
          //   ],
          // ),
        ],
      ),
    );
  }
}
