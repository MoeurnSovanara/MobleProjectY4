class Createeventdto {
  final int id;
  final int categoryId;
  final int userId;
  final int venuesId;
  final String title;
  final String image;
  final String description;
  final int capacityTicketd;
  final DateTime eventStart;
  final DateTime eventEnd;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Duration startTime;
  final Duration endTime;

  Createeventdto({
    required this.id,
    required this.categoryId,
    required this.userId,
    required this.venuesId,
    required this.title,
    required this.image,
    required this.description,
    required this.capacityTicketd,
    required this.eventStart,
    required this.eventEnd,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  static Duration _parseTimeSpan(String? timeString) {
    if (timeString == null || timeString.isEmpty) return Duration();

    try {
      List<String> parts = timeString.split(':');
      return Duration(
        hours: int.parse(parts[0]),
        minutes: int.parse(parts[1]),
        seconds: parts.length > 2 ? int.parse(parts[2]) : 0,
      );
    } catch (e) {
      print('Error parsing time span: $e');
      return Duration();
    }
  }

  // Helper function to format Duration to TimeSpan string
  static String? _formatTimeSpan(Duration? duration) {
    if (duration == null) return null;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'userId': userId,
      'venuesId': venuesId,
      'title': title,
      'image': image,
      'description': description,
      'capacityTicketd': capacityTicketd,
      'eventStart': eventStart.toIso8601String(),
      'eventEnd': eventEnd.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'startTime': _formatTimeSpan(startTime),
      'endTime': _formatTimeSpan(endTime),
    };
  }

  factory Createeventdto.fromJson(Map<String, dynamic> json) {
    return Createeventdto(
      id: json['id'] ?? 0,
      categoryId: json['categoryId'] ?? 0,
      userId: json['userId'] ?? 0,
      venuesId: json['venuesId'] ?? 0,
      title: json['title'] ?? "",
      image: json['image'] ?? 0,
      description: json['description'] ?? "",
      capacityTicketd: json['capacityTicketd'] ?? "",
      eventStart: DateTime.parse(
        json['eventStart'] ?? DateTime.now().toIso8601String(),
      ),
      eventEnd: DateTime.parse(
        json['eventEnd'] ?? DateTime.now().toIso8601String(),
      ),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      startTime: _parseTimeSpan(json['startTime']),
      endTime: _parseTimeSpan(json['endTime']),
    );
  }
}
