// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/utils/SVCommon.dart';
import 'package:brokerstreet/utils/SVConstants.dart';

class SVPostTextComponent extends StatelessWidget {
  const SVPostTextComponent(this.controller, {Key? key}) : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: svGetScaffoldColor(), borderRadius: radius(SVAppCommonRadius)),
      child: TextField(
        controller: controller,
        autofocus: false,
        maxLines: 12,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Whats On Your Mind',
          hintStyle: secondaryTextStyle(size: 14, color: svGetBodyColor()),
        ),
      ),
    );
  }
}
