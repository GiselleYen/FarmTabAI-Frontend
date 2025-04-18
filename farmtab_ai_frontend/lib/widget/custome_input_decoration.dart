import 'package:flutter/material.dart';

import '../theme/color_extension.dart';

class CustomInputDecoration {
  /// Creates a consistent InputDecoration with the app's styling
  ///
  /// [label] The label and hint placeholder text
  /// [prefixIcon] Optional icon to display at the start of the input
  /// [suffixIcon] Optional icon to display at the end of the input
  static InputDecoration build({
    required String label,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      label: Text(
        label,
        style: TextStyle(
          color: TColor.primaryColor1.withOpacity(0.7),
          fontFamily: 'Poppins',
        ),
      ),
      hintText: 'Enter $label',
      hintStyle: TextStyle(
        color: TColor.primaryColor1.withOpacity(0.3),
        fontFamily: 'Poppins',
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: TColor.primaryColor1.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(6),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: TColor.primaryColor1.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: TColor.primaryColor1,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      prefixIcon: prefixIcon != null
          ? Icon(
        prefixIcon,
        color: TColor.primaryColor1,
      )
          : null,
      suffixIcon: suffixIcon ,
    );
  }
}
