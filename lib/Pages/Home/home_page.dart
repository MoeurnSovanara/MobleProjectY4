import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/carouselWidget.dart';
import 'package:mobile_assignment/Const/widget/eventWidget.dart';
import 'package:mobile_assignment/Const/widget/videoCardWidget.dart';
import 'package:mobile_assignment/Pages/Home/other/notification_page.dart';
import 'package:mobile_assignment/Pages/Other/seeall_page.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _searchFieldContorller = TextEditingController();
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();

  final items = [
    {
      'thumb': 'assets/img/sample/event.png',
      'video': 'assets/videos/promo1.mp4',
    },
    {
      'thumb': 'assets/img/sample/heart.png',
      'video': 'assets/videos/promo1.mp4',
    },
    {
      'thumb': 'assets/img/sample/upcoming2.png',
      'video': 'assets/videos/promo1.mp4',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content - add your page content here
        Container(
          margin: EdgeInsets.only(top: 180), // Adjust based on appbar height
          color: AdvertiseColor.backgroundColor,
          child: SingleChildScrollView(
            // Your page content goes here
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Upcoming Events",
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
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: false,

                          itemBuilder: (BuildContext context, int index) {
                            return EventWidget();
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Performing arts', style: AppComponent.labelStyle),
                      SizedBox(height: 10),
                      carouselWidget(),
                      SizedBox(height: 10),
                      Text(
                        "Exploring the heart of Phnom Penh",
                        style: AppComponent.labelStyle,
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 240,
                        margin: EdgeInsets.only(left: 5),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(15),
                                    child: Image.asset(
                                      'assets/img/sample/heart.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Video highlights', style: AppComponent.labelStyle),
                      SizedBox(height: 10),
                      Container(
                        height: 240,
                        margin: EdgeInsets.only(left: 5),

                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (_, i) => AssetVideoCard(
                            thumbnailAsset: items[i]['thumb']!,
                            videoAsset: items[i]['video']!,
                          ),
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
          height: 180,
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
                Spacer(),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchFieldContorller,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            icon: Icon(
                              Icons.search,
                              color: AdvertiseColor.backgroundColor,
                            ),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            hintText: "Search ...",
                            hintStyle: AppComponent.hintSearchStyle,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            AdvertiseColor.primaryColor,
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.playlist_add_circle_outlined,
                              color: AdvertiseColor.backgroundColor,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Filters',
                              style: TextStyle(
                                color: AdvertiseColor.backgroundColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
