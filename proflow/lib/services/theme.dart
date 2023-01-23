// ignore_for_file: constant_identifier_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proflow/shared.dart';

themeNames currentTheme = themeNames.proflow;

enum themeNames {
  proflow,
  purple_haze,
  swiss_chalet,
  cherry_blossom,
  avatar;

  String get text => name;

  String get refineText =>
      name.split('_').map((word) => capitalize(word)).join(' ');
}

enum colorType {
  gradient,
  button,
  shadow,
  foreground;

  String get text => name;
}

const Map<String, Map<String, dynamic>> themes = {
  "proflow": {
    "gradient": [
      Color(0xFF1C1B22),
      Color(0xFF2A2A2E),
    ],
    "button": Color.fromARGB(255, 175, 174, 174),
    "shadow": Color.fromARGB(255, 243, 237, 237),
    "foreground": Color(0xFFf2f0ec),
  },
  "purple_haze": {
    "gradient": [Color(0xFF210535), Color(0xFF430d4b)],
    "button": Color(0xFF7b337d),
    "shadow": Color(0xFFc874b2),
    "foreground": Color(0xFFf5d5e0),
  },
  "swiss_chalet": {
    "gradient": [Color.fromARGB(255, 38, 38, 38), Color(0xFF41474a)],
    "button": Color(0xFF81847d),
    "shadow": Color(0xFFb9c1b9),
    "foreground": Color(0xFFf2f0ec),
  },
  "cherry_blossom": {
    "gradient": [Color(0xFFbc244a), Color(0xFFf25477)],
    "button": Color(0xFFffa7a6),
    "shadow": Color(0xFFffdcdc),
    "foreground": Color.fromARGB(255, 239, 240, 243),
  },
  "avatar": {
    "gradient": [Color(0xFF0F2347), Color(0xFF1C3F6E), Color(0xFF2E67A0)],
    "button": Color(0xFF5AACCF),
    "shadow": Color(0xFFEFFC93),
    "foreground": Color(0xFFC0E1B8),
  }
};

Map<String, dynamic> proflowTheme = themes[themeNames.proflow.text]!;
final ThemeData proflow = ThemeData(
  tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
          color: lighten(proflowTheme[colorType.gradient.text][1]),
          borderRadius: BorderRadius.circular(5)),
      textStyle: TextStyle(
          color: proflowTheme[colorType.foreground.text], fontSize: 12),
      margin: const EdgeInsets.only(top: 5)),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    shape: const MaterialStatePropertyAll(CircleBorder()),
    shadowColor: MaterialStatePropertyAll(proflowTheme[colorType.shadow.text]),
    animationDuration: const Duration(milliseconds: 300),
    padding: const MaterialStatePropertyAll(EdgeInsets.all(20)),
    elevation: const MaterialStatePropertyAll(5),
    backgroundColor:
        MaterialStatePropertyAll(proflowTheme[colorType.button.text]),
  )),
  fontFamily: GoogleFonts.poppins().fontFamily,
  colorScheme: ColorScheme.dark(
    primary: proflowTheme[colorType.gradient.text][0],
    secondary: proflowTheme[colorType.gradient.text][1],
  ),
);
