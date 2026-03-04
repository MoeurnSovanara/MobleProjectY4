import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/carouselWidget.dart';
import 'package:mobile_assignment/Const/widget/eventWidget.dart';
import 'package:mobile_assignment/Models/DTO/CategoryDto.dart';
import 'package:mobile_assignment/Models/DTO/EventDto.dart'; // Add this import
import 'package:mobile_assignment/Models/DTO/UserEventEngagementDto.dart';
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

      // Check if widget is still mounted before any setState
      if (!mounted) return;

      if (data != null && data.isNotEmpty) {
        setState(() {
          category = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Check mounted before showing SnackBar
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _updateEventWithEngagement(Usereventengagementdto updatedEngagement) {
    setState(() {
      if (category == null) return;

      for (int catIndex = 0; catIndex < category!.length; catIndex++) {
        for (
          int eventIndex = 0;
          eventIndex < category![catIndex].events.length;
          eventIndex++
        ) {
          Eventdto event = category![catIndex].events[eventIndex];

          if (event.id == updatedEngagement.eventId) {
            // Update the engagement in the event
            List<Usereventengagementdto> updatedEngagements = List.from(
              event.eventEngagement,
            );

            int engIndex = updatedEngagements.indexWhere(
              (e) => e.userId == updatedEngagement.userId,
            );

            if (engIndex != -1) {
              updatedEngagements[engIndex] = updatedEngagement;
            } else {
              updatedEngagements.add(updatedEngagement);
            }

            // Create updated event
            Eventdto updatedEvent = Eventdto(
              id: event.id,
              title: event.title,
              description: event.description,
              image: event.image,
              eventStart: event.eventStart,
              eventEnd: event.eventEnd,
              venues: event.venues,
              eventEngagement: updatedEngagements,
              capacityTicketd: event.capacityTicketd,
              category: event.category,
              categoryId: event.categoryId,
              createdAt: event.createdAt,
              ticketTypes: event.ticketTypes,
              updatedAt: event.updatedAt,
              userId: event.userId,
              venuesId: event.venuesId,
              endTime: event.endTime,
              startTime: event.startTime,
            );

            category![catIndex].events[eventIndex] = updatedEvent;
            return;
          }
        }
      }
    });
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
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('On trend', style: AppComponent.labelStyle),
                        carouselWidget(),
                        if (category != null && category!.isNotEmpty)
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
                                              category![index].categoryName,
                                              style: AppComponent.labelStyle,
                                            ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () async {
                                                bool? shouldRefresh =
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SeeallPage(
                                                              data:
                                                                  category![index]
                                                                      .events,
                                                            ),
                                                      ),
                                                    );
                                                if (shouldRefresh == true) {
                                                  getAllEvents();
                                                }
                                              },
                                              child: Text(
                                                'See All >',
                                                style:
                                                    AppComponent.sublabelStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          height: 270,
                                          child: ListView.builder(
                                            itemCount:
                                                category![index].events.length,
                                            shrinkWrap: false,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder:
                                                (
                                                  BuildContext context,
                                                  int eventIndex,
                                                ) {
                                                  return EventWidget(
                                                    data: category![index]
                                                        .events[eventIndex],
                                                    // Choose which update method to use:
                                                    onEventUpdated:
                                                        _updateEventWithEngagement, // Using Method 1
                                                    // onEventUpdated: _updateEventWithEngagement, // Or Method 2
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
