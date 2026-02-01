import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Other/eventdetailed_page.dart';

class eventWidget extends StatelessWidget {
  const eventWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventdetailedPage()),
      ),
      child: Container(
        width: 220,
        height: 500,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        margin: EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img/sample/upcoming2.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 65,
                    decoration: BoxDecoration(
                      color: AdvertiseColor.backgroundColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '12',
                          style: TextStyle(
                            fontFamily: 'KantumruyPro',
                            color: AdvertiseColor.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          'DEC',
                          style: TextStyle(
                            fontFamily: 'KantumruyPro',
                            color: AdvertiseColor.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 30,
                    height: 35,
                    decoration: BoxDecoration(
                      color: AdvertiseColor.backgroundColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.bookmark_outline),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "Performance art: Happ...",
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
                      Icon(
                        Icons.thumb_up_outlined,
                        color: AdvertiseColor.primaryColor,
                      ),
                      SizedBox(width: 5),
                      Text('809 k'),
                      SizedBox(width: 5),
                      Icon(
                        Icons.thumb_down_outlined,
                        color: AdvertiseColor.textColor.withOpacity(0.5),
                      ),
                      SizedBox(width: 5),
                      Text('0'),
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
                      Icon(
                        Icons.location_on,
                        color: AdvertiseColor.textColor.withOpacity(0.5),
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
      ),
    );
  }
}
