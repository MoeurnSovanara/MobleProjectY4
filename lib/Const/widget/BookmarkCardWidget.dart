import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/NotGetUserEventEngagementDto.dart';
import 'package:mobile_assignment/services/Helper/HelperClass.dart';
import 'package:mobile_assignment/services/Helper/InteractionHelper.dart';
import 'package:mobile_assignment/services/Helper/TimeHelperClass.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';

class Bookmarkcardwidget extends StatefulWidget {
  final Notgetusereventengagementdto data;
  final VoidCallback? onBookmarkremoved;
  const Bookmarkcardwidget({
    super.key,
    required this.data,
    required this.onBookmarkremoved,
  });

  @override
  State<Bookmarkcardwidget> createState() => _BookmarkcardwidgetState();
}

class _BookmarkcardwidgetState extends State<Bookmarkcardwidget> {
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  InteractionHelper? interactionHelper;
  Helperclass helperclass = Helperclass();
  Timehelperclass timehelperclass = Timehelperclass();
  bool _isProcessing = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeHelper();
  }

  @override
  void didUpdateWidget(covariant Bookmarkcardwidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the data has changed (like isBookMarked status)
    if (oldWidget.data.eventId != widget.data.eventId ||
        oldWidget.data.isBookMarked != widget.data.isBookMarked) {
      _isInitialized = false;
      _initializeHelper();
    }
  }

  Future<void> _initializeHelper() async {
    var uId = await usersharedpreferences.getUserId();
    if (!mounted) return;
    if (uId != null) {
      setState(() {
        interactionHelper = InteractionHelper(
          isLiked: widget.data.isLiked,
          isDisliked: widget.data.isDisliked,
          isBookMarked: widget.data.isBookMarked,
          likeCount: 0,
          dislikeCount: 0,
          userId: uId,
          eventId: widget.data.eventId,
          onUpdate: _handleHelperUpdate,
        );
        _isInitialized = true;
      });
    }
  }

  void _handleHelperUpdate(Usereventengagementdto) {
    // Don't update local state, just trigger parent refresh
    if (widget.onBookmarkremoved != null) {
      widget.onBookmarkremoved!();
    }
  }

  Future<void> _handleBookmarkTap() async {
    if (_isProcessing || interactionHelper == null || !_isInitialized) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Store the current bookmark state before toggling
      bool wasBookMarked = interactionHelper!.isBookMarked;

      // Call the bookmark handler and await it
      await interactionHelper!.handleBookMark();

      // If this was a removal (was bookmarked and now it's not), trigger parent refresh
      if (wasBookMarked) {
        if (widget.onBookmarkremoved != null) {
          widget.onBookmarkremoved!();
        }
      } else {
        // If it was adding a bookmark, still refresh parent to keep in sync
        if (widget.onBookmarkremoved != null) {
          widget.onBookmarkremoved!();
        }
      }
    } catch (e) {
      print('Error handling bookmark: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update bookmark'),
            backgroundColor: AdvertiseColor.dangerColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    // Show a loading indicator while initializing
    if (!_isInitialized) {
      return Container(
        height: screenWidth <= 402 ? 140 : 160,
        decoration: BoxDecoration(
          border: Border.all(color: AdvertiseColor.textColor.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Container(
      height: screenWidth <= 402 ? 140 : 160,
      decoration: BoxDecoration(
        border: Border.all(color: AdvertiseColor.textColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                '${headUrl}lib/img/event/${widget.data.events.image}',
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  "assets/img/other/errorImage.png",
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.events.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppComponent.labelStyle.copyWith(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${helperclass.formatDate(widget.data.events.eventStart)} - ${timehelperclass.formatTimeAMPM(widget.data.events.startTime)}',
                    style: AppComponent.detailTextStyle,
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.data.events.venues.venueLocation,
                          style: AppComponent.detailTextStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _isProcessing ? null : _handleBookmarkTap,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: _isProcessing
                      ? Colors.grey.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _isProcessing
                    ? Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : Icon(
                        Icons.bookmark,
                        color: AdvertiseColor.warningColor,
                        size: 24,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
