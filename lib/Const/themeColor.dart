import 'package:flutter/material.dart';

class AdvertiseColor {
  // Light mode colors
  static const Color lightPrimaryColor = Color(0xFF953AFB);
  static const Color lightBackgroundColor = Color(0xFFF5F9FF);
  static const Color lightInputFieldColor = Color(0xFFFFFFFF);
  static const Color lightTextColor = Color(0xFF000000);
  static const Color lightDangerColor = Color(0xFFF44336);
  static const Color lightWarningColor = Color(0xFFFFD740);
  static const Color lightBlueColor = Color(0xFF448AFF);

  // Dark mode colors
  static const Color darkPrimaryColor = Color(0xFFB77AFB);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkInputFieldColor = Color(0xFF2C2C2C);
  static const Color darkTextColor = Color(0xFFFFFFFF);
  static const Color darkDangerColor = Color(0xFFCF6679);
  static const Color darkWarningColor = Color(0xFFFFB74D);
  static const Color darkBlueColor = Color(0xFF81A9FE);

  // Current theme mode (will be set by provider)
  static bool isDarkMode = false;

  // Getters that return colors based on current mode
  static Color get primaryColor =>
      isDarkMode ? darkPrimaryColor : lightPrimaryColor;
  static Color get backgroundColor =>
      isDarkMode ? darkBackgroundColor : lightBackgroundColor;
  static Color get inputFieldColor =>
      isDarkMode ? darkInputFieldColor : lightInputFieldColor;
  static Color get textColor => isDarkMode ? darkTextColor : lightTextColor;
  static Color get dangerColor =>
      isDarkMode ? darkDangerColor : lightDangerColor;
  static Color get warningColor =>
      isDarkMode ? darkWarningColor : lightWarningColor;
  static Color get blueColor => isDarkMode ? darkBlueColor : lightBlueColor;
}
