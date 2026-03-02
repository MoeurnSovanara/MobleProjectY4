import 'package:mobile_assignment/Models/DTO/EventNormalDto.dart';

class Notgetusereventengagementdto {
  final int userId;
  final int eventId;
  final bool isBookMarked;
  final bool isLiked;
  final bool isDisliked;
  final Eventnormaldto events;

  Notgetusereventengagementdto({
    required this.userId,
    required this.eventId,
    required this.isBookMarked,
    required this.isDisliked,
    required this.isLiked,
    required this.events,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'eventId': eventId,
      'isBookMarked': isBookMarked,
      'isLiked': isLiked,
      'isDisliked': isDisliked,
      'events': events.toJson(),
    };
  }

  factory Notgetusereventengagementdto.fromJson(Map<String, dynamic> json) {
    return Notgetusereventengagementdto(
      userId: json['userId'],
      eventId: json['eventId'],
      isBookMarked: json['isBookMarked'],
      isDisliked: json['isDisliked'],
      isLiked: json['isLiked'],
      events: Eventnormaldto.fromJson(json['events']),
    );
  }
}
