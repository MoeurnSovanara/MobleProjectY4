import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/themeColor.dart';

class AppComponent {
  // Text Styles - These are getters so they'll recompute when theme changes
  static TextStyle get labelTextStyle => TextStyle(
    fontFamily: 'KantumruyPro',
    fontSize: 16,
    color: AdvertiseColor.textColor,
  );

  static TextStyle get hintTextStyle => TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: 16,
    color: AdvertiseColor.textColor.withOpacity(0.5),
  );

  static TextStyle get hintSearchStyle => TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: 16,
    color: AdvertiseColor.backgroundColor,
  );

  static TextStyle get primaryThemeTextStyle => TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: 16,
    color: AdvertiseColor.primaryColor,
  );

  static TextStyle get appBarTitleTextStyle => TextStyle(
    fontSize: 20,
    color: AdvertiseColor.textColor.withOpacity(0.5),
    fontWeight: FontWeight.bold,
  );

  static TextStyle get elevatedButtonTextStyle => TextStyle(
    fontFamily: 'KantumruyPro',
    fontSize: 18,
    color: AdvertiseColor.backgroundColor,
  );

  static TextStyle get labelStyle => TextStyle(
    fontFamily: 'KantumruyPro',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: AdvertiseColor.textColor,
  );

  static TextStyle get sublabelStyle => TextStyle(
    fontFamily: 'KantumruyPro',
    color: AdvertiseColor.textColor.withOpacity(0.5),
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get detailTextStyle => TextStyle(
    fontFamily: 'KantumruyPro',
    fontSize: 14,
    color: AdvertiseColor.textColor,
  );

  static TextStyle get boldTextStyle => TextStyle(
    fontSize: 24,
    fontFamily: 'KantumruyPro',
    fontWeight: FontWeight.w800,
    color: AdvertiseColor.textColor, // Add color here
  );

  // Button Styles - These need to be methods or getters
  static ButtonStyle get elevatedButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AdvertiseColor.primaryColor,
    foregroundColor: AdvertiseColor.backgroundColor, // Add foreground color
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  );

  // Alternative: As a method if you need to pass parameters
  static ButtonStyle elevatedButtonStyleWithPadding({
    double horizontal = 50,
    double vertical = 15,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: AdvertiseColor.primaryColor,
      foregroundColor: AdvertiseColor.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
    );
  }

  // Add outlined button style
  static ButtonStyle get outlinedButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: AdvertiseColor.primaryColor,
    side: BorderSide(color: AdvertiseColor.primaryColor),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  );

  // Add text button style
  static ButtonStyle get textButtonStyle => TextButton.styleFrom(
    foregroundColor: AdvertiseColor.primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );

  // Container decoration styles
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: AdvertiseColor.inputFieldColor,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: AdvertiseColor.textColor.withOpacity(0.2)),
  );

  static BoxDecoration get primaryDecoration => BoxDecoration(
    color: AdvertiseColor.primaryColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: AdvertiseColor.primaryColor.withOpacity(0.3)),
  );

  // Input decoration theme
  static InputDecoration inputDecoration({
    required String hintText,
    Icon? prefixIcon,
    Icon? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: hintTextStyle,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AdvertiseColor.inputFieldColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: AdvertiseColor.textColor.withOpacity(0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AdvertiseColor.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AdvertiseColor.dangerColor),
      ),
    );
  }
}
