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

  final Function(Usereventengagementdto)? onUpdate;

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
    // Store previous state for rollback
    bool previousLiked = isLiked;
    int previousLikeCount = likeCount;
    bool previousDisliked = isDisliked;
    int previousDislikeCount = dislikeCount;

    // Update local state optimistically
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

    try {
      Usereventengagementdto updatedEvent = await _callApi('like', isLiked);
      if (onUpdate != null) {
        onUpdate!(updatedEvent);
      }
    } catch (e) {
      // Rollback on error
      isLiked = previousLiked;
      likeCount = previousLikeCount;
      isDisliked = previousDisliked;
      dislikeCount = previousDislikeCount;

      // Still notify with original state
      if (onUpdate != null) {
        onUpdate!(
          Usereventengagementdto(
            userId: userId,
            eventId: eventId,
            isLiked: isLiked,
            isDisliked: isDisliked,
            isBookMarked: isBookMarked,
          ),
        );
      }
      print('Error in handleLike: $e');
    }
  }

  Future<void> handleDislike() async {
    // Store previous state
    bool previousDisliked = isDisliked;
    int previousDislikeCount = dislikeCount;
    bool previousLiked = isLiked;
    int previousLikeCount = likeCount;

    // Update local state optimistically
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

    try {
      Usereventengagementdto updatedEvent = await _callApi(
        'dislike',
        isDisliked,
      );
      if (onUpdate != null) {
        onUpdate!(updatedEvent);
      }
    } catch (e) {
      // Rollback on error
      isDisliked = previousDisliked;
      dislikeCount = previousDislikeCount;
      isLiked = previousLiked;
      likeCount = previousLikeCount;

      if (onUpdate != null) {
        onUpdate!(
          Usereventengagementdto(
            userId: userId,
            eventId: eventId,
            isLiked: isLiked,
            isDisliked: isDisliked,
            isBookMarked: isBookMarked,
          ),
        );
      }
      print('Error in handleDislike: $e');
    }
  }

  Future<void> handleBookMark() async {
    // Store previous state
    bool previousBookMarked = isBookMarked;
    int previousBookmarkedCount = bookmarkedCount;

    // Update local state optimistically
    if (isBookMarked) {
      isBookMarked = false;
      bookmarkedCount--;
    } else {
      isBookMarked = true;
      bookmarkedCount++;
    }

    try {
      Usereventengagementdto updatedEvent = await _callApi(
        'bookmarked',
        isBookMarked,
      );
      if (onUpdate != null) {
        onUpdate!(updatedEvent);
      }
    } catch (e) {
      // Rollback on error
      isBookMarked = previousBookMarked;
      bookmarkedCount = previousBookmarkedCount;

      if (onUpdate != null) {
        onUpdate!(
          Usereventengagementdto(
            userId: userId,
            eventId: eventId,
            isLiked: isLiked,
            isDisliked: isDisliked,
            isBookMarked: isBookMarked,
          ),
        );
      }
      print('Error in handleBookMark: $e');
    }
  }

  Future<Usereventengagementdto> _callApi(String action, bool value) async {
    UsereventEngagementApi usereventEngagementApi = UsereventEngagementApi();

    try {
      var isExisted = await usereventEngagementApi.findExistData(
        userId: userId,
        eventId: eventId,
      );

      Usereventengagementdto engagementDto = Usereventengagementdto(
        userId: userId,
        eventId: eventId,
        isBookMarked: isBookMarked,
        isLiked: isLiked,
        isDisliked: isDisliked,
      );

      if (isExisted) {
        var response = await usereventEngagementApi.updateEventEngagement(
          userId: userId,
          eventId: eventId,
          userEventEngagement: engagementDto,
        );

        if (response.statusCode >= 200 && response.statusCode <= 299) {
          print("Update Successfully");
          return engagementDto;
        } else {
          print("Failed to Update");
          return engagementDto; // Return current state even on failure
        }
      } else {
        var response = await usereventEngagementApi.createEventEngagement(
          userEventEngagement: engagementDto,
        );

        if (response.statusCode >= 200 && response.statusCode <= 299) {
          print('Create Successfully');
          return engagementDto;
        } else {
          print('Failed to create');
          return engagementDto; // Return current state even on failure
        }
      }
    } catch (e) {
      print('Error in API call: $e');
      rethrow; // Rethrow to trigger rollback
    }
  }
}
