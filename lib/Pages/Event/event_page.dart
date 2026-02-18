import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/carouselWidget.dart';
import 'package:mobile_assignment/Const/widget/eventWidget.dart';
import 'package:mobile_assignment/Models/DTO/CategoryDto.dart';
import 'package:mobile_assignment/Pages/Home/other/notification_page.dart';
import 'package:mobile_assignment/Pages/Other/seeall_page.dart';
import 'package:mobile_assignment/services/API/CategoryApi.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Categoryapi categoryapi = Categoryapi();
  List<Categorydto>? category = [];
  bool isLoading = false;

  void getAllEvents() async {
    try {
      setState(() {
        isLoading = true;
      });
      final data = await categoryapi.getAllCategory();
      if (!mounted) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      if (data!.isNotEmpty) {
        setState(() {
          category = data;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  void initState() {
    super.initState();
    getAllEvents();
  }

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
                  if (category!.isNotEmpty && category != null)
                    ...List.generate(
                      category!.length,
                      (index) => category![index].events.isNotEmpty
                          ? SizedBox(
                              height: 330,
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        category![index]
                                            .categoryName, // Use category name
                                        style: AppComponent.labelStyle,
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SeeallPage(
                                              data: category![index].events,
                                            ),
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
                                  SizedBox(
                                    height: 270,
                                    child: ListView.builder(
                                      itemCount: category![index].events.length,
                                      shrinkWrap: false,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                            return EventWidget(
                                              data: category![index]
                                                  .events[index],
                                            );
                                          },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
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
