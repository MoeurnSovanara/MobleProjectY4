import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/carouselWidget.dart';
import 'package:mobile_assignment/Const/widget/eventWidget.dart';
import 'package:mobile_assignment/Pages/Home/other/notification_page.dart';
import 'package:mobile_assignment/Pages/Other/seeall_page.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content - add your page content here
        Container(
          margin: EdgeInsets.only(top: 120), // Adjust based on appbar height
          color: AdvertiseColor.backgroundColor,
          child: SingleChildScrollView(
            // Your page content goes here
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('On trend', style: AppComponent.labelStyle),
                  carouselWidget(),
                  Column(
                    children: [
                      for (var category in [
                        'Business',
                        'Technology',
                        'Entertainment',
                      ])
                        Container(
                          height: 330,
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    category, // Use category name
                                    style: AppComponent.labelStyle,
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SeeallPage(),
                                      ),
                                    ),
                                    child: Text(
                                      'See All >',
                                      style: AppComponent.sublabelStyle,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 270,
                                child: ListView.builder(
                                  itemCount: 3,
                                  shrinkWrap: false,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                        return eventWidget();
                                      },
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Fixed AppBar
        Container(
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/other/header_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(height: 30),
                Row(
                  children: [
                    Image.asset('assets/img/other/logo2.png'),
                    Spacer(),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationPage(),
                        ),
                      ),
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: AdvertiseColor.backgroundColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
