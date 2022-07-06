import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'utils/SVColors.dart';

//

const APP_BLACK = Color(0xff040301);
const APP_PRIMARY = APP_GREEN;
const APP_ACCENT = SVAppColorPrimary;
const LIGHT_DARK = Color(0xff222626);
const TILE_DARK = Color(0xff222831);
const Color LIGHT_BLUE = Color(0xff38DDFE);
const Color APP_GREEN = Color(0xff4AD393);
const Color APP_GREY = Color(0xff757575);
const Color DECENT_GREY = Color(0xffD0D0D0);
const Color REAL_WHITE = Color(0xffffffff);
const Color REAL_BLACK = Color(0xff000000);
const Color SCAFFOLD_BG = Color(0xfffafafa);
const Color SHIMMER_LIGHT = Color(0xffE4E6EB);
const Color SHIMMER_DARK = Color(0xffD8DADF);
const Color SHIMMER_BLUE_LIGHT = Color(0xff00F8FF);
const Color SHIMMER_BLUE_DARK = Color(0xff005B92);
const Color APP_RED = Color(0xffD83A43);
const Color APP_GOLD = Color(0xffFEBE01);
const Color APP_DARK = Color(0xff020A18);
const Color TITLE_COLOR = Color(0xffC3E3F2);

navigatePage(context, {required Widget className}) {
  return Navigator.of(context)
      .push(CupertinoPageRoute(builder: (context) => className));
}

const TextStyle normalTextStyle = TextStyle(
    fontSize: 16,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w500,
    color: APP_ACCENT);

const TextStyle titleTextStyle = TextStyle(
    fontSize: 19,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w600,
    color: APP_ACCENT);

Container normalButton(
    {required double v16,
    required Color bgColor,
    bool isBold = false,
    Color textColor = REAL_WHITE,
    required String title}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: v16, horizontal: v16 * 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: bgColor,
    ),
    child: Center(
        child: Text(
      title,
      style: normalTextStyle.copyWith(
          color: textColor,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
    )),
  );
}

Container outlineButton(
    {required double v16,
    Border? border,
    required Color textColor,
    required String title}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: v16, horizontal: v16 * 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.transparent,
      border: border ?? Border.all(color: textColor, width: 1.4),
    ),
    child: Center(
        child: Text(
      title,
      style: normalTextStyle.copyWith(color: textColor),
    )),
  );
}

// ranges from 0.0 to 1.0
Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

const testImage =
    'https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';

const faceImage =
    "https://images.pexels.com/photos/1882309/pexels-photo-1882309.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";

const flagImage = 'https://cdn.countryflags.com/thumbs/uganda/flag-400.png';

const testImage1 =
    "https://images.pexels.com/photos/1440727/pexels-photo-1440727.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";

const testImage2 =
    "https://images.pexels.com/photos/7745561/pexels-photo-7745561.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";

const testImage3 =
    "https://images.pexels.com/photos/850360/pexels-photo-850360.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";

const testImage4 =
    "https://images.pexels.com/photos/1042143/pexels-photo-1042143.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";

const testToken =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5M2FjNjM0Ni1kYjk2LTQ2YmEtODcxMS1iOWViMjkxOWU1NmIiLCJqdGkiOiJjZTQ1NjE4ZGVhMjU0MzVjOWY3OWIzYmNmMThhNWY2OTQyNTk3MjE1OGU0YjA1YjBiMjgxNDc4MzJlZjFkNjY3YTkwODdiODAxMjRkZWI3YSIsImlhdCI6MTYyMzk5NjY4NiwibmJmIjoxNjIzOTk2Njg2LCJleHAiOjE2NTU1MzI2ODYsInN1YiI6ImMzNDI2NzhhLTZlNmMtNDVjNy04NDk4LTlmYzFiYWNjODZkMyIsInNjb3BlcyI6W119.lkyboRL-_L9bMFirSSm0LkQK1lMIi9m_1njwqF9qzw0hu3g_Ci1c-yu9lPiJ0eUEns1oY4M4BJnPt7mA-hK4xeTGI6aV554fIN7-tVlfMnvcs0zM_cyEFfBlrLyWWTdqsnR3ea5ldC2aLRIKTrGOLS8oFfoX5Hv2qN7qG_mRjYlor_sokW6XEM0G_hRmZsTN-MIsHuplEOyp6jLgohYfMlTXygqoOrO5E-czW46VCRFWHa0r3j6epv3wo3q6urmtJ4Ehjz6mAjvhcNHd7bLCuugGch0DEmyklTzcH39-LB6YGSZVwvsAuCeX1OcpqZi8AhwG0dKYq7F2Gd8t22fi7vVUFSAno3rojYubZGsH1bpNlmTNejvU_f-8pM54FvAP41WvS6lLvriglhdfzUhbKMGMV3ABBFCZTTVbGkHg61lyo_DyCrQpN7HK33QkawZUbnCGzI9OC9ECxHLe3h8MKk9ZT_86Fdd7WLc1IvzV5eoThLTn5Zb5OgmHp6kc5wg5qy8s3MgECDA8xYm4ptxSgitOgSWxLu4Lc53lZ2mZ5XbffLphnFD1yXpllyKKgP1dZpHMggKlV2RyWytK53DXef2CKBgIfzbtVtppQz8H8WAPPeeZpAUayp1tRRgy7D-c07u5V2yCKNrW7617n7rrLJ5_Zfm9B5kkLZoiE26R6so";

const String lorem =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
