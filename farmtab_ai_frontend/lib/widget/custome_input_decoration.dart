// Add this to a utility file like 'input_decoration.dart'

import 'package:flutter/material.dart';

import '../theme/color_extension.dart';

class CustomInputDecoration {
  /// Creates a consistent InputDecoration with the app's styling
  ///
  /// [label] The label and hint placeholder text
  /// [prefixIcon] Optional icon to display at the start of the input
  static InputDecoration build({
    required String label,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      label: Text(
        label,
        style: TextStyle(
          color: TColor.primaryColor1,
          fontFamily: 'Poppins',
        ),
      ),
      hintText: 'Enter $label',
      hintStyle: TextStyle(
        color: TColor.gray,
        fontFamily: 'Poppins',
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: TColor.primaryColor1),
        borderRadius: BorderRadius.circular(6),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: TColor.primaryColor1),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: TColor.primaryColor1,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      prefixIcon: prefixIcon != null
          ? Icon(
        prefixIcon,
        color: TColor.gray,
      )
          : null,
    );
  }
}