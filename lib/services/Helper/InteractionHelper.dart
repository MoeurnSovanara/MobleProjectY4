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

  void handleLike() {
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
    _callApi('like', isLiked);
  }

  void handleDislike() {
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
    _callApi('dislike', isDisliked);
  }

  void handleBookMark() {
    if (isBookMarked) {
      isBookMarked = false;
      bookmarkedCount--;
    } else {
      isBookMarked = true;
      bookmarkedCount++;
    }
    onUpdate?.call();
    _callApi('bookmarked', isBookMarked);
  }

  Future<void> _callApi(String action, bool value) async {
    UsereventEngagementApi usereventEngagementApi = UsereventEngagementApi();
    switch (action) {
      case 'bookmared':
        var isExisted = await usereventEngagementApi.findExistData(
          userId: userId,
          eventId: eventId,
        );
        if (isExisted) {
          print('Data Exist: $isExisted');
        }
      case 'like':
        var isExisted = await usereventEngagementApi.findExistData(
          userId: userId,
          eventId: eventId,
        );
        if (isExisted) {
          print('Data Exist: $isExisted');
        }
      case 'dislike':
        var isExisted = await usereventEngagementApi.findExistData(
          userId: userId,
          eventId: eventId,
        );
        if (isExisted) {
          print('Data Exist: $isExisted');
        }
    }

    // TODO: Implement API call
    print('API: $action = $value');
  }
}
