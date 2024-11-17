import 'package:flutter/material.dart';

class TColor {
  static Color get primaryColor1 => const Color(0xFF2D5523);
  static Color get primaryColor2 => const Color(0xFF76C893);

  static Color get secondaryColor1 => const Color(0xFF16423C);
  static Color get secondaryColor2 => const Color(0xFF6A9C89);


  static List<Color> get primaryG => [ primaryColor2, primaryColor1 ];
  static List<Color> get secondaryG => [secondaryColor2, secondaryColor1];

  static Color get black => const Color(0xFF6A9C89);
  static Color get gray => const Color(0xFFC4DAD2);
  static Color get white => Colors.white;
  static Color get lightGray => const Color(0xffF7F8F8);



}