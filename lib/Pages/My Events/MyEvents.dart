import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/My%20Events/other/OwnEvents.dart';
import 'package:mobile_assignment/Pages/Profile/other/bookmark_page.dart';

class Myevents extends StatefulWidget {
  const Myevents({super.key});

  @override
  State<Myevents> createState() => _MyeventsState();
}

class _MyeventsState extends State<Myevents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/img/other/logo2.png'),
        centerTitle: true,
        backgroundColor: AdvertiseColor.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        color: AdvertiseColor.backgroundColor,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Ownevents()),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.5),
                  ),
                ),
                height: 70,
                width: double.infinity,
                child: Row(
                  children: [
                    Icon(Icons.wallet, color: AdvertiseColor.primaryColor),
                    SizedBox(width: 5),
                    Text('My Events', style: AppComponent.labelTextStyle),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AdvertiseColor.textColor.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkPage()),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.5),
                  ),
                ),
                height: 70,
                width: double.infinity,
                child: Row(
                  children: [
                    Icon(Icons.bookmark, color: AdvertiseColor.primaryColor),
                    SizedBox(width: 5),
                    Text('My Bookmark', style: AppComponent.labelTextStyle),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AdvertiseColor.textColor.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
