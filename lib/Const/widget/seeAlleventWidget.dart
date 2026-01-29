import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/bookmark_button.dart';
import 'package:mobile_assignment/Const/widget/like_dislike_row.dart';

class Seealleventwidget extends StatelessWidget {
  const Seealleventwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 300,

      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/sample/upcoming2.png'),
                fit: BoxFit.fitWidth,
              ),
              borderRadius: BorderRadiusDirectional.circular(15),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.35),
                        AdvertiseColor.backgroundColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Text(
                            '12',
                            style: TextStyle(
                              fontFamily: 'KantumruyPro',
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2.2
                                ..color = AdvertiseColor.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            '12',
                            style: TextStyle(
                              fontFamily: 'KantumruyPro',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Stack(
                        children: [
                          Text(
                            'DEC',
                            style: TextStyle(
                              fontFamily: 'KantumruyPro',
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 1.5
                                ..color = AdvertiseColor.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'DEC',
                            style: TextStyle(
                              fontFamily: 'KantumruyPro',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AdvertiseColor.backgroundColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: const BookmarkButton(
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  "Performance art: Happy Celebration of Modern Creativity, Culture",
                  style: TextStyle(
                    fontFamily: 'KantumruyPro',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AdvertiseColor.textColor,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    const LikeDislikeRow(
                      likes: 809000,
                      dislikes: 0,
                    ),
                    Spacer(),
                    Icon(
                      Icons.share_rounded,
                      color: AdvertiseColor.textColor.withOpacity(0.5),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Image.asset(
                      'assets/img/Icon/location.png',
                      width: 22,
                      height: 22,
                    ),
                    SizedBox(width: 5),
                    Text(
                      '222 Street Tul kork, PP',
                      style: TextStyle(
                        color: AdvertiseColor.textColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
