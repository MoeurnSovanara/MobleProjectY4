// theme_provider.dart
import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'is_dark_mode';
  bool _isDarkMode = false;
  late SharedPreferences _prefs;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool(_themeKey) ?? false;
    AdvertiseColor.isDarkMode = _isDarkMode; // Update static variable
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    AdvertiseColor.isDarkMode = _isDarkMode; // Update static variable
    await _prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }
}
