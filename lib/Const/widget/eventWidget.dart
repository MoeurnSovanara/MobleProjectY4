import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/EventDto.dart';
import 'package:mobile_assignment/Pages/Other/eventdetailed_page.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';

class EventWidget extends StatefulWidget {
  final Eventdto data;
  const EventWidget({super.key, required this.data});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  // State variables
  bool isLiked = false;
  bool isDisliked = false;
  bool isBookmarked = false;
  int likeCount = 0;
  int dislikeCount = 0;
  late int userId;
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  bool _imageError = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _preloadImage();
  }

  Future<void> _initializeData() async {
    firstLaunch();
  }

  void firstLaunch() async {
    var storedUserId = await usersharedpreferences.getUserId();

    if (storedUserId != null) {
      userId = storedUserId;

      // Calculate counts from all engagements first
      int totalLikes = 0;
      int totalDislikes = 0;

      for (var item in widget.data.userEventEngagements) {
        if (item.isLiked == true) totalLikes++;
        if (item.isDisliked == true) totalDislikes++;

        // Set current user's interaction
        if (item.userId.toString() == userId) {
          setState(() {
            isLiked = item.isLiked == true;
            isDisliked = item.isDisliked == true;
            isBookmarked = item.isBookMarked == true;
          });
        }
      }

      setState(() {
        likeCount = totalLikes;
        dislikeCount = totalDislikes;
      });
    } else {
      // If no user logged in, just show the counts from engagements
      int totalLikes = 0;
      int totalDislikes = 0;

      for (var item in widget.data.userEventEngagements) {
        if (item.isLiked == true) totalLikes++;
        if (item.isDisliked == true) totalDislikes++;
      }

      setState(() {
        likeCount = totalLikes;
        dislikeCount = totalDislikes;
      });
    }
  }

  // Like action
  void _handleLike() {
    setState(() {
      if (isLiked) {
        // If already liked, unlike it
        isLiked = false;
        likeCount--;
      } else {
        // If not liked, like it
        isLiked = true;
        likeCount++;

        // If disliked, remove dislike
        if (isDisliked) {
          isDisliked = false;
          dislikeCount--;
        }
      }
    });

    // TODO: Call API to update like status
  }

  // Dislike action
  void _handleDislike() {
    setState(() {
      if (isDisliked) {
        // If already disliked, remove dislike
        isDisliked = false;
        dislikeCount--;
      } else {
        // If not disliked, dislike it
        isDisliked = true;
        dislikeCount++;

        // If liked, remove like
        if (isLiked) {
          isLiked = false;
          likeCount--;
        }
      }
    });

    // TODO: Call API to update dislike status
  }

  // Bookmark action
  void _handleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });

    // Show snackbar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isBookmarked ? 'Event bookmarked!' : 'Bookmark removed',
          style: const TextStyle(fontFamily: 'KantumruyPro'),
        ),
        duration: const Duration(milliseconds: 1500),
      ),
    );

    // TODO: Call API to update bookmark status
  }

  // Share action using Flutter's built-in share
  void _handleShare() async {
    final String shareText =
        'Check out this event: ${widget.data.title}\n'
        'Date: ${_formatDate(widget.data.eventStart)}\n'
        'Location: ${widget.data.venues?.venueLocation ?? 'Location TBA'}\n'
        '${isLiked ? 'I liked this event!' : ''}';

    try {
      // For web platform
      if (Platform.isAndroid || Platform.isIOS) {
        // Use the share_plus package if you need cross-platform sharing
        // For now, show a dialog with copy option
        _showShareDialog(shareText);
      } else {
        // For other platforms, show dialog
        _showShareDialog(shareText);
      }
    } catch (e) {
      print('Share error: $e');
      _showShareDialog(shareText);
    }
  }

  // Format date to show day and month
  String _formatDate(DateTime? date) {
    if (date == null) return 'Date TBA';

    // You can customize this based on your date format
    return '${date.day} ${_getMonthAbbreviation(date.month)}';
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[month - 1];
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

  // For native sharing (Android/iOS)
  void _showNativeShare(String text) {
    // This would require the share_plus package
    // For now, we'll show a message
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

  // Helper function to format large numbers
  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  // Preload image to check if it loads successfully
  void _preloadImage() {
    if (widget.data.image == null || widget.data.image!.isEmpty) {
      setState(() {
        _imageError = true;
      });
      return;
    }

    final Image image = Image.network(
      "${headUrl}img/${widget.data.image}",
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
        MaterialPageRoute(builder: (context) => EventdetailedPage()),
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
                color: Colors.grey[200], // Fallback color
                image:
                    !_imageError &&
                        widget.data.image != null &&
                        widget.data.image!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(
                          "${headUrl}img/${widget.data.image}",
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
              // Date and bookmark row - always show regardless of image error
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
                          widget.data.eventStart != null
                              ? '${widget.data.eventStart!.day}'
                              : '12',
                          style: TextStyle(
                            fontFamily: 'KantumruyPro',
                            color: AdvertiseColor.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          widget.data.eventStart != null
                              ? _getMonthAbbreviation(
                                  widget.data.eventStart!.month,
                                )
                              : 'DEC',
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
                    onTap: _handleBookmark,
                    child: Container(
                      width: 30,
                      height: 35,
                      decoration: BoxDecoration(
                        color: AdvertiseColor.backgroundColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                        color: isBookmarked
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
                    widget.data.title ?? 'Untitled Event',
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
                        onTap: _handleLike,
                        child: Row(
                          children: [
                            Icon(
                              isLiked
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                              color: isLiked
                                  ? AdvertiseColor.primaryColor
                                  : AdvertiseColor.textColor.withOpacity(0.5),
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _formatNumber(likeCount),
                              style: TextStyle(
                                fontFamily: 'KantumruyPro',
                                color: isLiked
                                    ? AdvertiseColor.primaryColor
                                    : Colors.black,
                                fontWeight: isLiked
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
                        onTap: _handleDislike,
                        child: Row(
                          children: [
                            Icon(
                              isDisliked
                                  ? Icons.thumb_down
                                  : Icons.thumb_down_outlined,
                              color: isDisliked
                                  ? AdvertiseColor.textColor
                                  : AdvertiseColor.textColor.withOpacity(0.5),
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _formatNumber(dislikeCount),
                              style: TextStyle(
                                fontFamily: 'KantumruyPro',
                                color: isDisliked
                                    ? AdvertiseColor.textColor
                                    : Colors.black,
                                fontWeight: isDisliked
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
                          widget.data.venues?.venueLocation ?? 'Location TBA',
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
