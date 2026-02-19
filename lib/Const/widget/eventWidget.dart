import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/EventDto.dart';
import 'package:mobile_assignment/Pages/Other/eventdetailed_page.dart';
import 'package:mobile_assignment/services/Helper/HelperClass.dart';
import 'package:mobile_assignment/services/Helper/InteractionHelper.dart';
import 'package:mobile_assignment/services/Helper/PreloadImageHelper.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';

class EventWidget extends StatefulWidget {
  final Eventdto data;
  const EventWidget({super.key, required this.data});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  // State variables
  InteractionHelper? _interactionHelper;
  late int userId;
  final helperclass = Helperclass();
  PreloadImageHelper? _preloadImageHelper;
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update mounted state in helper when dependencies change
    if (_preloadImageHelper != null) {
      _preloadImageHelper!.mounted = mounted;
    }
  }

  Future<void> _initializeData() async {
    await firstLaunch();
  }

  Future<void> firstLaunch() async {
    var storedUserId = await usersharedpreferences.getUserId();

    if (storedUserId != null) {
      userId = storedUserId;

      // Calculate counts from all engagements first
      int totalLikes = 0;
      int totalDislikes = 0;
      bool currentUserLiked = false;
      bool currentUserDisliked = false;
      bool currentUserBookMarked = false;

      for (var item in widget.data.userEventEngagements) {
        if (item.isLiked == true) totalLikes++;
        if (item.isDisliked == true) totalDislikes++;

        // Set current user's interaction
        if (item.userId == userId) {
          currentUserLiked = item.isLiked == true;
          currentUserDisliked = item.isDisliked == true;
          currentUserBookMarked = item.isBookMarked == true;
        }
      }

      // Initialize the helper with the calculated values
      _interactionHelper = InteractionHelper(
        isLiked: currentUserLiked,
        isDisliked: currentUserDisliked,
        isBookMarked: currentUserBookMarked,
        likeCount: totalLikes,
        dislikeCount: totalDislikes,
        userId: userId,
        eventId: widget.data.id,
        onUpdate: () => setState(() {}),
      );

      // Initialize image preloader
      _preloadImageHelper = PreloadImageHelper(
        imageError: false,
        imageName: widget.data.image,
        mounted: mounted,
        onUpdate: () => setState(() {}),
      );

      // Preload the image
      _preloadImageHelper!.preloadImage(headUrl);
    } else {
      // If no user logged in, just show the counts from engagements
      int totalLikes = 0;
      int totalDislikes = 0;

      for (var item in widget.data.userEventEngagements) {
        if (item.isLiked == true) totalLikes++;
        if (item.isDisliked == true) totalDislikes++;
      }

      // Initialize helper with default values
      _interactionHelper = InteractionHelper(
        likeCount: totalLikes,
        dislikeCount: totalDislikes,
        onUpdate: () => setState(() {}),
      );

      // Initialize image preloader even for non-logged users
      _preloadImageHelper = PreloadImageHelper(
        imageError: false,
        imageName: widget.data.image,
        mounted: mounted,
        onUpdate: () => setState(() {}),
      );

      // Preload the image
      _preloadImageHelper!.preloadImage(headUrl);
    }
  }

  // Share action
  void _handleShare() async {
    final String shareText =
        'Check out this event: ${widget.data.title}\n'
        'Date: ${helperclass.formatDate(widget.data.eventStart)}\n'
        'Location: ${widget.data.venues.venueLocation}\n'
        '${_interactionHelper?.isLiked == true ? 'I liked this event!' : ''}';

    _showShareDialog(shareText);
  }

  void _showShareDialog(String text) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Event',
              style: TextStyle(
                fontFamily: 'KantumruyPro',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AdvertiseColor.textColor,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(
                Icons.content_copy,
                color: AdvertiseColor.primaryColor,
              ),
              title: Text(
                'Copy Link',
                style: TextStyle(
                  fontFamily: 'KantumruyPro',
                  color: AdvertiseColor.textColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _copyToClipboard(text);
              },
            ),
            if (Platform.isAndroid || Platform.isIOS) ...[
              ListTile(
                leading: Icon(Icons.share, color: AdvertiseColor.primaryColor),
                title: Text(
                  'Share via...',
                  style: TextStyle(
                    fontFamily: 'KantumruyPro',
                    color: AdvertiseColor.textColor,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showNativeShare(text);
                },
              ),
            ],
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'KantumruyPro',
                  color: AdvertiseColor.textColor.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Copied to clipboard!',
          style: TextStyle(fontFamily: 'KantumruyPro'),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showNativeShare(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sharing: $text',
          style: const TextStyle(fontFamily: 'KantumruyPro'),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure helpers are initialized
    if (_interactionHelper == null || _preloadImageHelper == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventdetailedPage(eventdto: widget.data),
        ),
      ),
      child: Container(
        width: 220,
        height: 500,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container with error handling
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                image: DecorationImage(
                  image: _preloadImageHelper!.hasValidImage
                      ? NetworkImage("${headUrl}img/${widget.data.image}")
                      : const AssetImage("assets/img/other/errorImage.png")
                            as ImageProvider,
                  fit: _preloadImageHelper!.hasValidImage
                      ? BoxFit.fitHeight
                      : BoxFit.fitWidth,
                ),
                borderRadius: BorderRadius.circular(8),
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
                          '${widget.data.eventStart.day}',
                          style: TextStyle(
                            fontFamily: 'KantumruyPro',
                            color: AdvertiseColor.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          helperclass.getMonthAbbreviation(
                            widget.data.eventStart.month,
                          ),
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
                  const Spacer(),
                  GestureDetector(
                    onTap: _interactionHelper!.handleBookMark,
                    child: Container(
                      width: 30,
                      height: 35,
                      decoration: BoxDecoration(
                        color: AdvertiseColor.backgroundColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _interactionHelper!.isBookMarked
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        color: _interactionHelper!.isBookMarked
                            ? AdvertiseColor.primaryColor
                            : Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.title,
                    style: TextStyle(
                      fontFamily: 'KantumruyPro',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AdvertiseColor.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      // Like button
                      GestureDetector(
                        onTap: _interactionHelper!.handleLike,
                        child: Row(
                          children: [
                            Icon(
                              _interactionHelper!.isLiked
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                              color: _interactionHelper!.isLiked
                                  ? AdvertiseColor.primaryColor
                                  : AdvertiseColor.textColor.withOpacity(0.5),
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              helperclass.formatNumber(
                                _interactionHelper!.likeCount,
                              ),
                              style: TextStyle(
                                fontFamily: 'KantumruyPro',
                                color: _interactionHelper!.isLiked
                                    ? AdvertiseColor.primaryColor
                                    : Colors.black,
                                fontWeight: _interactionHelper!.isLiked
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Dislike button
                      GestureDetector(
                        onTap: _interactionHelper!.handleDislike,
                        child: Row(
                          children: [
                            Icon(
                              _interactionHelper!.isDisliked
                                  ? Icons.thumb_down
                                  : Icons.thumb_down_outlined,
                              color: _interactionHelper!.isDisliked
                                  ? AdvertiseColor.textColor
                                  : AdvertiseColor.textColor.withOpacity(0.5),
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              helperclass.formatNumber(
                                _interactionHelper!.dislikeCount,
                              ),
                              style: TextStyle(
                                fontFamily: 'KantumruyPro',
                                color: _interactionHelper!.isDisliked
                                    ? AdvertiseColor.textColor
                                    : Colors.black,
                                fontWeight: _interactionHelper!.isDisliked
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),

                      // Share button
                      GestureDetector(
                        onTap: _handleShare,
                        child: Icon(
                          Icons.share_rounded,
                          color: AdvertiseColor.textColor.withOpacity(0.5),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AdvertiseColor.textColor.withOpacity(0.5),
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.data.venues.venueLocation,
                          style: TextStyle(
                            fontFamily: 'KantumruyPro',
                            color: AdvertiseColor.textColor.withOpacity(0.5),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
