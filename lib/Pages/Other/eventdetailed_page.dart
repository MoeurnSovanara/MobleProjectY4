import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/EventDto.dart';
import 'package:mobile_assignment/Pages/Other/bookticket_page.dart';
import 'package:mobile_assignment/services/Helper/HelperClass.dart';
import 'package:mobile_assignment/services/Helper/InteractionHelper.dart';
import 'package:mobile_assignment/services/Helper/PreloadImageHelper.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';

class EventdetailedPage extends StatefulWidget {
  final Eventdto eventdto;
  const EventdetailedPage({super.key, required this.eventdto});

  @override
  State<EventdetailedPage> createState() => _EventdetailedPageState();
}

class _EventdetailedPageState extends State<EventdetailedPage> {
  // State variables
  InteractionHelper? _interactionHelper;
  late int userId;
  final helperclass = Helperclass();
  PreloadImageHelper? _preloadImageHelper;
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  Future<void> firstJob() async {
    bool isLiked = false;
    bool isDisLiked = false;
    bool isBookMarked = false;
    int likeCount = 0;
    int dislikedCount = 0;
    int bookMarkedCount = 0;
    var userId = await usersharedpreferences.getUserId();
    if (userId != null) {
      for (var item in widget.eventdto.userEventEngagements) {
        if (item.isLiked == true) likeCount++;
        if (item.isDisliked == true) dislikedCount++;
        if (item.isBookMarked == true) bookMarkedCount;
        if (userId == item.eventId) {
          isBookMarked = item.isBookMarked == true;
          isDisLiked = item.isDisliked == true;
          isLiked = item.isLiked == true;
        }
      }
    }

    _interactionHelper = InteractionHelper(
      isBookMarked: isBookMarked,
      isLiked: isLiked,
      isDisliked: isDisLiked,
      likeCount: likeCount,
      dislikeCount: dislikedCount,
      bookmarkedCount: bookMarkedCount,
      userId: userId!,
      eventId: widget.eventdto.id,
      onUpdate: () => setState(() {}),
    );

    _preloadImageHelper = PreloadImageHelper(
      imageError: false,
      imageName: widget.eventdto.image,
      onUpdate: () => setState(() {}),
      mounted: mounted,
    );

    _preloadImageHelper!.preloadImage(headUrl);
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                      ? NetworkImage("${headUrl}img/${widget.eventdto.image}")
                      : const AssetImage("assets/img/other/errorImage.png")
                            as ImageProvider,
                  fit:
                      _preloadImageHelper != null &&
                          _preloadImageHelper!.hasValidImage
                      ? BoxFit.fitHeight
                      : BoxFit.fitWidth,
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
                      IconButton(
                        onPressed: _interactionHelper?.handleLike,
                        icon: Icon(
                          Icons.thumb_up_outlined,
                          color: _interactionHelper?.isLiked == true
                              ? AdvertiseColor.primaryColor
                              : AdvertiseColor.textColor,
                        ),
                      ),

                      Text(
                        " ${_interactionHelper?.likeCount} ",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'KantumruyPro',
                        ),
                      ),
                      SizedBox(width: 5),
                      IconButton(
                        onPressed: _interactionHelper?.handleDislike,
                        icon: Icon(
                          Icons.thumb_down_outlined,
                          color: _interactionHelper?.isDisliked == true
                              ? AdvertiseColor.dangerColor
                              : AdvertiseColor.textColor,
                        ),
                      ),
                      Text(
                        " ${_interactionHelper?.dislikeCount} ",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'KantumruyPro',
                        ),
                      ),
                      Spacer(),
                      Text(
                        ' ${_interactionHelper?.bookmarkedCount}',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'KantumruyPro',
                        ),
                      ),
                      IconButton(
                        onPressed: () => _interactionHelper!.handleBookMark(),
                        icon: Icon(
                          Icons.bookmark_outline,
                          color: _interactionHelper?.isBookMarked == true
                              ? AdvertiseColor.warningColor
                              : AdvertiseColor.textColor,
                        ),
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
                                    Text(
                                      'Time',
                                      style: AppComponent.labelStyle,
                                    ),
                                    Text(
                                      '${Helperclass.formatTime(widget.eventdto.eventStart)}-${Helperclass.formatTime(widget.eventdto.eventStart)}',
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
                              'Location: ${widget.eventdto.venues.venueLocation}',
                              style: AppComponent.hintTextStyle.copyWith(
                                color: AdvertiseColor.textColor,
                              ),
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 10),
                          Image.asset('assets/img/other/googlemap.png'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 65,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AdvertiseColor.primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Stage',
                                  style: AppComponent.boldTextStyle,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 65,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AdvertiseColor.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Zone A',
                                        style: AppComponent.boldTextStyle,
                                      ),
                                      Text(
                                        'VIP',
                                        style: AppComponent.sublabelStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 65,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AdvertiseColor.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Zone B',
                                        style: AppComponent.boldTextStyle,
                                      ),
                                      Text(
                                        'Premium',
                                        style: AppComponent.sublabelStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 65,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AdvertiseColor.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Zone C',
                                        style: AppComponent.boldTextStyle,
                                      ),
                                      Text(
                                        'Standard',
                                        style: AppComponent.sublabelStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 65,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AdvertiseColor.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Zone D',
                                        style: AppComponent.boldTextStyle,
                                      ),
                                      Text(
                                        'General',
                                        style: AppComponent.sublabelStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookticketPage(),
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
      ),
    );
  }

  @override
  void dispose() {
    // Clean up if needed
    super.dispose();
  }
}
