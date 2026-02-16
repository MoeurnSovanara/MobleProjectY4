class Usereventengagementdto {
  final int userId;
  final int eventId;
  final bool isBookMarked;
  final bool isLiked;
  final bool isDisliked;

  Usereventengagementdto({
    required this.userId,
    required this.eventId,
    required this.isBookMarked,
    required this.isLiked,
    required this.isDisliked,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'eventId': eventId,
      'isBookMarked': isBookMarked,
      'isLiked': isLiked,
      'isDisliked': isDisliked,
    };
  }

  factory Usereventengagementdto.fromJson(Map<String, dynamic> json) {
    return Usereventengagementdto(
      userId: json['userId'] ?? 0,
      eventId: json['eventId'] ?? 0,
      isBookMarked: json['bookMarked'] ?? false,
      isLiked: json['liked'] ?? false,
      isDisliked: json['disliked'] ?? false,
    );
  }
}
