import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/EventDto.dart';
import 'package:mobile_assignment/Pages/Other/bookticket_page.dart';
import 'package:mobile_assignment/services/Helper/HelperClass.dart';
import 'package:mobile_assignment/services/Helper/PreloadImageHelper.dart';
import 'package:mobile_assignment/services/Helper/TimeHelperClass.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EventdetailedPage extends StatefulWidget {
  final Eventdto eventdto;
  const EventdetailedPage({super.key, required this.eventdto});

  @override
  State<EventdetailedPage> createState() => _EventdetailedPageState();
}

class _EventdetailedPageState extends State<EventdetailedPage> {
  late int userId;
  final helperclass = Helperclass();
  PreloadImageHelper? _preloadImageHelper;
  bool _isLoading = true;
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  final timeHelperClass = Timehelperclass();
  int likeCount = 0;
  int dislikeCount = 0;
  int bookmarkCount = 0;

  Future<void> firstJob() async {
    setState(() => _isLoading = true);
    int lCount = 0;
    int dCount = 0;
    int bCount = 0;
    try {
      for (var data in widget.eventdto.eventEngagement) {
        data.isLiked == true ? lCount++ : null;
        data.isDisliked == true ? dCount++ : null;
        data.isBookMarked == true ? bCount++ : null;
      }
      _preloadImageHelper = PreloadImageHelper(
        imageError: false,
        imageName: widget.eventdto.image,
        onUpdate: () => setState(() {}),
        mounted: mounted,
      );

      _preloadImageHelper!.preloadImage(headUrl);
      setState(() {
        likeCount = lCount;
        dislikeCount = dCount;
        bookmarkCount = bCount;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> firstTask() async {
    await firstJob();
  }

  @override
  void initState() {
    super.initState();
    firstTask();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update mounted state in helper when dependencies change
    if (_preloadImageHelper != null) {
      _preloadImageHelper!.mounted = mounted;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              image: DecorationImage(
                image:
                    _preloadImageHelper != null &&
                        _preloadImageHelper!.hasValidImage
                    ? NetworkImage(
                        "${headUrl}lib/img/Event/${widget.eventdto.image}",
                      )
                    : const AssetImage("assets/img/other/errorImage.png")
                          as ImageProvider,
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: AdvertiseColor.backgroundColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up_outlined,
                      color: AdvertiseColor.primaryColor,
                    ),
                    Text(
                      " $likeCount ",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'KantumruyPro',
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.thumb_down_outlined,
                      color: AdvertiseColor.dangerColor,
                    ),
                    Text(
                      " $dislikeCount ",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'KantumruyPro',
                      ),
                    ),
                    Spacer(),
                    Text(
                      ' $bookmarkCount ',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'KantumruyPro',
                      ),
                    ),
                    Icon(
                      Icons.bookmark_outline,
                      color: AdvertiseColor.warningColor,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  widget.eventdto.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'KantumruyPro',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AdvertiseColor.primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.eventdto.description,
                  style: AppComponent.detailTextStyle,
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month_outlined),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Start Date',
                                    style: AppComponent.labelStyle,
                                  ),
                                  Text(
                                    Helperclass.formatFullDate(
                                      widget.eventdto.eventStart,
                                    ),
                                    style: AppComponent.hintTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Icon(Icons.calendar_month_outlined),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'End Date',
                                    style: AppComponent.labelStyle,
                                  ),
                                  Text(
                                    Helperclass.formatFullDate(
                                      widget.eventdto.eventEnd,
                                    ),
                                    style: AppComponent.hintTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // FIXED: Time display with proper formatting
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.timer_outlined),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Time', style: AppComponent.labelStyle),
                                  Text(
                                    timeHelperClass.formatTimeRange(
                                      widget.eventdto.startTime,
                                      widget.eventdto.endTime,
                                    ),
                                    style: AppComponent.hintTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            'Location: ${widget.eventdto.venues.venueInfo}',
                            style: AppComponent.hintTextStyle.copyWith(
                              color: AdvertiseColor.textColor,
                            ),
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse(
                              widget.eventdto.venues.venueLocation,
                            );
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                          child: Image.asset('assets/img/other/googlemap.png'),
                        ),
                      ],
                    ),
                    // Column(
                    //   children: [
                    //     Container(
                    //       width: double.infinity,
                    //       height: 65,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: AdvertiseColor.primaryColor,
                    //         ),
                    //         borderRadius: BorderRadius.circular(15),
                    //       ),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             'Stage',
                    //             style: AppComponent.boldTextStyle,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     SizedBox(height: 10),
                    //     Row(
                    //       children: [
                    //         Expanded(
                    //           child: Container(
                    //             height: 65,
                    //             decoration: BoxDecoration(
                    //               border: Border.all(
                    //                 color: AdvertiseColor.primaryColor,
                    //               ),
                    //               borderRadius: BorderRadius.circular(15),
                    //             ),
                    //             child: Column(
                    //               children: [
                    //                 Text(
                    //                   'Zone A',
                    //                   style: AppComponent.boldTextStyle,
                    //                 ),
                    //                 Text(
                    //                   'VIP',
                    //                   style: AppComponent.sublabelStyle,
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(width: 10),
                    //         Expanded(
                    //           child: Container(
                    //             height: 65,
                    //             decoration: BoxDecoration(
                    //               border: Border.all(
                    //                 color: AdvertiseColor.primaryColor,
                    //               ),
                    //               borderRadius: BorderRadius.circular(15),
                    //             ),
                    //             child: Column(
                    //               children: [
                    //                 Text(
                    //                   'Zone B',
                    //                   style: AppComponent.boldTextStyle,
                    //                 ),
                    //                 Text(
                    //                   'Premium',
                    //                   style: AppComponent.sublabelStyle,
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     SizedBox(height: 10),
                    //     Row(
                    //       children: [
                    //         Expanded(
                    //           child: Container(
                    //             height: 65,
                    //             decoration: BoxDecoration(
                    //               border: Border.all(
                    //                 color: AdvertiseColor.primaryColor,
                    //               ),
                    //               borderRadius: BorderRadius.circular(15),
                    //             ),
                    //             child: Column(
                    //               children: [
                    //                 Text(
                    //                   'Zone C',
                    //                   style: AppComponent.boldTextStyle,
                    //                 ),
                    //                 Text(
                    //                   'Standard',
                    //                   style: AppComponent.sublabelStyle,
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(width: 10),
                    //         Expanded(
                    //           child: Container(
                    //             height: 65,
                    //             decoration: BoxDecoration(
                    //               border: Border.all(
                    //                 color: AdvertiseColor.primaryColor,
                    //               ),
                    //               borderRadius: BorderRadius.circular(15),
                    //             ),
                    //             child: Column(
                    //               children: [
                    //                 Text(
                    //                   'Zone D',
                    //                   style: AppComponent.boldTextStyle,
                    //                 ),
                    //                 Text(
                    //                   'General',
                    //                   style: AppComponent.sublabelStyle,
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: MediaQuery.of(context).size.height / 8),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookticketPage(eventdto: widget.eventdto),
                        ),
                      ),
                      style: AppComponent.elevatedButtonStyle,
                      child: Text(
                        'Booking Ticket',
                        style: AppComponent.elevatedButtonTextStyle,
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
