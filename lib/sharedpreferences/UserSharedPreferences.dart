import 'package:shared_preferences/shared_preferences.dart';

class Usersharedpreferences {
  static String userEmailKey = "USEREMAILKEY";
  static String userOrganizerKey = "ORGANIZERKEY";
  static String userNameKey = "USERNAMEKEY";

  Future<bool> saveUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userEmailKey, email);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<bool> saveUserOrganizer(bool isOrganizer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(userOrganizerKey, isOrganizer);
  }

  Future<bool?> getUserOrganizer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userOrganizerKey);
  }

  Future<bool> saveUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userNameKey, name);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userEmailKey);
    await prefs.remove(userOrganizerKey);
    await prefs.remove(userNameKey);
  }
}
