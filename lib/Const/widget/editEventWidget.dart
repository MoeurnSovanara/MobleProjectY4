import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/EventDto.dart';
import 'package:mobile_assignment/Pages/Dashboard/CreateEvent/editEventPage.dart';
import 'package:mobile_assignment/services/Helper/HelperClass.dart';
import 'package:mobile_assignment/services/Helper/InteractionHelper.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';

class Editeventwidget extends StatefulWidget {
  final Eventdto eventData;
  final VoidCallback? update;
  const Editeventwidget({super.key, required this.eventData, this.update});

  @override
  State<Editeventwidget> createState() => _EditeventwidgetState();
}

class _EditeventwidgetState extends State<Editeventwidget> {
  InteractionHelper? _interactionHelper;
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  Helperclass helperclass = Helperclass();

  @override
  void initState() {
    super.initState();
    interactionData();
  }

  Future<void> interactionData() async {
    var userId = await usersharedpreferences.getUserId();
    if (userId != null) {
      int totalLikes = 0;
      int totalDislikes = 0;
      int totalBookmarks = 0; // Add this if you need bookmark count
      bool currentUserLiked = false;
      bool currentUserDisliked = false;
      bool currentUserBookMarked = false;

      for (var item in widget.eventData.eventEngagement) {
        if (item.isLiked == true) totalLikes++;
        if (item.isDisliked == true) totalDislikes++;
        if (item.isBookMarked == true) totalBookmarks++; // Add this if needed

        if (item.userId == userId) {
          currentUserLiked = item.isLiked == true;
          currentUserDisliked = item.isDisliked == true;
          currentUserBookMarked = item.isBookMarked == true;
        }
      }

      // Create helper once after the loop
      _interactionHelper = InteractionHelper(
        isLiked: currentUserLiked,
        isDisliked: currentUserDisliked,
        isBookMarked: currentUserBookMarked,
        likeCount: totalLikes,
        dislikeCount: totalDislikes,
        bookmarkedCount: totalBookmarks,
        userId: userId,
        eventId: widget.eventData.id,
        onUpdate: (updatedEvent) {
          // Handle update if needed
          setState(() {
            // Update counts or refresh data
          });
        },
      );

      setState(() {}); // Trigger rebuild with the new helper
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 320,

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
                  height: 65,
                  decoration: BoxDecoration(
                    color: AdvertiseColor.backgroundColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    Helperclass.formatFullDate(widget.eventData.eventStart),
                    style: TextStyle(
                      fontFamily: 'KantumruyPro',
                      color: AdvertiseColor.textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                    ),
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
                  widget.eventData.title,
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
                    Text(
                      _interactionHelper?.likeCount.toString() ?? '0',
                    ), // Safe null check
                    SizedBox(width: 5),
                    Icon(
                      Icons.thumb_down_outlined,
                      color: AdvertiseColor.textColor.withOpacity(0.5),
                    ),
                    SizedBox(width: 5),
                    Text(
                      _interactionHelper?.dislikeCount.toString() ?? '0',
                    ), // Safe null check
                    SizedBox(width: 5),
                    Icon(
                      Icons.bookmark_outline,
                      color: AdvertiseColor.textColor.withOpacity(0.5),
                    ),
                    SizedBox(width: 5),
                    Text(
                      _interactionHelper?.bookmarkedCount.toString() ?? '0',
                    ), // Safe null check
                    Spacer(),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        bool? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Editeventpage(eventData: widget.eventData),
                          ),
                        );
                        if (result == true) {
                          widget.update!();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdvertiseColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                      ),
                      child: Text(
                        'Edit',
                        style: AppComponent.elevatedButtonTextStyle,
                      ),
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
                    Flexible(
                      child: Text(
                        widget.eventData.venues.venueInfo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AdvertiseColor.textColor.withOpacity(0.5),
                        ),
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
