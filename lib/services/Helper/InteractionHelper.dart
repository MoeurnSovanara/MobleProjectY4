import 'dart:ui';

import 'package:mobile_assignment/Models/DTO/UserEventEngagementDto.dart';
import 'package:mobile_assignment/services/API/userevent_engagement_api.dart';

class InteractionHelper {
  bool isLiked;
  bool isDisliked;
  bool isBookMarked;
  int likeCount;
  int dislikeCount;
  int bookmarkedCount;
  int userId;
  int eventId;

  final VoidCallback? onUpdate;

  InteractionHelper({
    this.isLiked = false,
    this.isDisliked = false,
    this.isBookMarked = false,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.bookmarkedCount = 0,
    this.onUpdate,
    this.userId = 0,
    this.eventId = 0,
  });

  Future<void> handleLike() async {
    if (isLiked) {
      isLiked = false;
      likeCount--;
    } else {
      isLiked = true;
      likeCount++;

      if (isDisliked) {
        isDisliked = false;
        dislikeCount--;
      }
    }
    onUpdate?.call();
    await _callApi('like', isLiked);
  }

  Future<void> handleDislike() async {
    if (isDisliked) {
      isDisliked = false;
      dislikeCount--;
    } else {
      isDisliked = true;
      dislikeCount++;

      if (isLiked) {
        isLiked = false;
        likeCount--;
      }
    }
    onUpdate?.call();
    await _callApi('dislike', isDisliked);
  }

  Future<void> handleBookMark() async {
    if (isBookMarked) {
      isBookMarked = false;
      bookmarkedCount--;
    } else {
      isBookMarked = true;
      bookmarkedCount++;
    }
    onUpdate?.call();
    await _callApi('bookmarked', isBookMarked);
  }

  Future<void> _callApi(String action, bool value) async {
    UsereventEngagementApi usereventEngagementApi = UsereventEngagementApi();
    var isExisted = await usereventEngagementApi.findExistData(
      userId: userId,
      eventId: eventId,
    );
    if (isExisted) {
      var response = await usereventEngagementApi.updateEventEngagement(
        userId: userId,
        eventId: eventId,
        userEventEngagement: Usereventengagementdto(
          userId: userId,
          eventId: eventId,
          isBookMarked: isBookMarked,
          isLiked: isLiked,
          isDisliked: isDisliked,
        ),
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        print("Update Successfully");
      } else {
        print("Failed to Update");
      }
    } else {
      var response = await usereventEngagementApi.createEventEngagement(
        userEventEngagement: Usereventengagementdto(
          userId: userId,
          eventId: eventId,
          isBookMarked: isBookMarked,
          isLiked: isLiked,
          isDisliked: isDisliked,
        ),
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        print('Create Successfully');
      } else {
        print('Failed to create');
      }
    }
  }
}
