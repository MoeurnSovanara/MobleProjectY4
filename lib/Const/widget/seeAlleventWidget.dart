import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/EventDto.dart';
import 'package:mobile_assignment/Pages/Other/eventdetailed_page.dart';
import 'package:mobile_assignment/services/Helper/HelperClass.dart';
import 'package:mobile_assignment/services/Helper/InteractionHelper.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';
import 'dart:io';

class Seealleventwidget extends StatefulWidget {
  final Eventdto eventData;
  const Seealleventwidget({super.key, required this.eventData});

  @override
  State<Seealleventwidget> createState() => _SeealleventwidgetState();
}

class _SeealleventwidgetState extends State<Seealleventwidget> {
  bool _imageError = false;
  final Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  final helper = Helperclass();
  InteractionHelper interactiveHelper = InteractionHelper();

  @override
  void initState() {
    super.initState();
    _initializeData();
    _preloadImage();
  }

  Future<void> _initializeData() async {
    await firstLaunch();
  }

  Future<void> firstLaunch() async {
    late int userId;
    var storedUserId = await usersharedpreferences.getUserId();

    if (storedUserId != null) {
      userId = storedUserId;

      // Calculate counts from all engagements first
      bool isLiked = false;
      bool isDisliked = false;
      bool isBookmarked = false;
      int likeCount = 0;
      int dislikeCount = 0;

      for (var item in widget.eventData.userEventEngagements) {
        if (item.isLiked == true) likeCount++;
        if (item.isDisliked == true) dislikeCount++;

        // Set current user's interaction
        if (item.userId.toString() == userId.toString()) {
          isLiked = item.isLiked == true;
          isDisliked = item.isDisliked == true;
          isBookmarked = item.isBookMarked == true;
        }
      }

      interactiveHelper = InteractionHelper(
        isBookMarked: isBookmarked,
        isDisliked: isDisliked,
        isLiked: isLiked,
        likeCount: likeCount,
        dislikeCount: dislikeCount,
        onUpdate: () => setState(() {}),
      );
    } else {
      // If no user logged in, just show the counts from engagements
      int totalLikes = 0;
      int totalDislikes = 0;

      for (var item in widget.eventData.userEventEngagements) {
        if (item.isLiked == true) totalLikes++;
        if (item.isDisliked == true) totalDislikes++;
      }

      interactiveHelper = InteractionHelper(
        likeCount: totalLikes,
        dislikeCount: totalDislikes,
      );
    }
  }

  // Share action
  void _handleShare() async {
    final String shareText =
        'Check out this event: ${widget.eventData.title}\n'
        'Date: ${helper.formatDate(widget.eventData.eventStart)}\n'
        'Location: ${widget.eventData.venues.venueLocation}\n'
        '${interactiveHelper.isLiked ? 'I liked this event!' : ''}';

    try {
      _showShareDialog(shareText);
    } catch (e) {
      print('Share error: $e');
      _showShareDialog(shareText);
    }
  }

  // Show share dialog with options
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

  // Copy to clipboard
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

  // For native sharing
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

  // Preload image to check if it loads successfully
  void _preloadImage() {
    if (widget.eventData.image.isEmpty) {
      setState(() {
        _imageError = true;
      });
      return;
    }

    final Image image = Image.network(
      "${headUrl}img/${widget.eventData.image}",
      fit: BoxFit.fitHeight,
    );

    image.image
        .resolve(ImageConfiguration())
        .addListener(
          ImageStreamListener(
            (info, call) {
              if (mounted) {
                setState(() {
                  _imageError = false;
                });
              }
            },
            onError: (exception, stackTrace) {
              if (mounted) {
                setState(() {
                  _imageError = true;
                });
              }
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventdetailedPage(eventdto: widget.eventData),
        ),
      ),
      child: Container(
        width: 220,
        height: 300,
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
        margin: const EdgeInsets.only(bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container with error handling
            Container(
              height: 150,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200], // Fallback color
                image: !_imageError && widget.eventData.image.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(
                          "${headUrl}img/${widget.eventData.image}",
                        ),
                        fit: BoxFit.fitHeight,
                        onError: (exception, stackTrace) {
                          setState(() {
                            _imageError = true;
                          });
                        },
                      )
                    : const DecorationImage(
                        image: AssetImage("assets/img/other/errorImage.png"),
                        fit: BoxFit.fitWidth,
                      ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date container
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
                          '${widget.eventData.eventStart.day}',
                          style: const TextStyle(
                            fontFamily: 'KantumruyPro',
                            color: AdvertiseColor.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          helper.getMonthAbbreviation(
                            widget.eventData.eventStart.month,
                          ),
                          style: const TextStyle(
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
                  // Bookmark button
                  GestureDetector(
                    onTap: interactiveHelper.handleBookMark,
                    child: Container(
                      width: 30,
                      height: 35,
                      decoration: BoxDecoration(
                        color: AdvertiseColor.backgroundColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        interactiveHelper.isBookMarked
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        color: interactiveHelper.isBookMarked
                            ? AdvertiseColor.primaryColor
                            : Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Event details section
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event title
                  Text(
                    widget.eventData.title,
                    style: const TextStyle(
                      fontFamily: 'KantumruyPro',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AdvertiseColor.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),

                  // Likes and shares row
                  Row(
                    children: [
                      // Like button
                      GestureDetector(
                        onTap: interactiveHelper.handleLike,
                        child: Row(
                          children: [
                            Icon(
                              interactiveHelper.isLiked
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                              color: interactiveHelper.isLiked
                                  ? AdvertiseColor.primaryColor
                                  : AdvertiseColor.textColor.withOpacity(0.5),
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              helper.formatNumber(interactiveHelper.likeCount),
                              style: TextStyle(
                                fontFamily: 'KantumruyPro',
                                color: interactiveHelper.isLiked
                                    ? AdvertiseColor.primaryColor
                                    : Colors.black,
                                fontWeight: interactiveHelper.isLiked
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
                        onTap: interactiveHelper.handleDislike,
                        child: Row(
                          children: [
                            Icon(
                              interactiveHelper.isDisliked
                                  ? Icons.thumb_down
                                  : Icons.thumb_down_outlined,
                              color: interactiveHelper.isDisliked
                                  ? AdvertiseColor.textColor
                                  : AdvertiseColor.textColor.withOpacity(0.5),
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              helper.formatNumber(
                                interactiveHelper.dislikeCount,
                              ),
                              style: TextStyle(
                                fontFamily: 'KantumruyPro',
                                color: interactiveHelper.isDisliked
                                    ? AdvertiseColor.textColor
                                    : Colors.black,
                                fontWeight: interactiveHelper.isDisliked
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

                  // Location row
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
                          widget.eventData.venues.venueLocation,
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
}
