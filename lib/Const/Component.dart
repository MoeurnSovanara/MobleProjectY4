import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/themeColor.dart';

class AppComponent {
  static final labelTextStyle = TextStyle(
    fontFamily: 'KantumruyPro',
    fontSize: 16,
    color: AdvertiseColor.textColor,
  );

  static final hintTextStyle = TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: 16,
    color: AdvertiseColor.textColor.withOpacity(0.5),
  );

  static final hintSearchStyle = TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: 16,
    color: AdvertiseColor.backgroundColor,
  );

  static final primaryThemeTextStyle = TextStyle(
    fontFamily: "KantumruyPro",
    fontSize: 16,
    color: AdvertiseColor.primaryColor,
  );

  static final appBarTitleTextStyle = TextStyle(
    fontSize: 20,
    color: AdvertiseColor.textColor.withOpacity(0.5),
    fontWeight: FontWeight.bold,
  );

  static final elevatedButtonTextStyle = TextStyle(
    fontFamily: 'KantumruyPro',
    fontSize: 18,
    color: AdvertiseColor.backgroundColor,
  );

  static final labelStyle = TextStyle(
    fontFamily: 'KantumruyPro',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: AdvertiseColor.textColor,
  );
  static final sublabelStyle = TextStyle(
    fontFamily: 'KantumruyPro',
    color: AdvertiseColor.textColor.withOpacity(0.5),
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static final detailTextStyle = TextStyle(
    fontFamily: 'KantumruyPro',
    fontSize: 14,
    color: AdvertiseColor.textColor,
  );

  static final boldTextStyle = TextStyle(
    fontSize: 24,
    fontFamily: 'KantumruyPro',
    fontWeight: FontWeight.w800,
  );

  static final elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AdvertiseColor.primaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  );
}
