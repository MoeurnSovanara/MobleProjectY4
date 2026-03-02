import 'package:mobile_assignment/Models/DTO/VenuesNameDto.dart';

class Eventnormaldto {
  final int id;
  final int categoryId;
  final int userId;
  final int venuesId;
  final String title;
  final String image;
  final String description;
  final String CapacityTicketd;
  final DateTime eventStart;
  final DateTime eventEnd;
  final DateTime updatedAt;
  final Duration? startTime;
  final Duration? endTime;
  final Venuesnamedto venues;

  Eventnormaldto({
    required this.id,
    required this.categoryId,
    required this.userId,
    required this.venuesId,
    required this.title,
    required this.image,
    required this.description,
    required this.CapacityTicketd,
    required this.eventStart,
    required this.eventEnd,
    this.startTime,
    this.endTime,
    required this.updatedAt,
    required this.venues,
  });

  // Helper function to parse TimeSpan string to Duration
  static Duration? _parseTimeSpan(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;

    try {
      List<String> parts = timeString.split(':');
      return Duration(
        hours: int.parse(parts[0]),
        minutes: int.parse(parts[1]),
        seconds: parts.length > 2 ? int.parse(parts[2]) : 0,
      );
    } catch (e) {
      print('Error parsing time span: $e');
      return null;
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
      'capacityTicketd': CapacityTicketd,
      'eventStart': eventStart.toIso8601String(),
      'eventEnd': eventEnd.toIso8601String(),
      'updateAt': updatedAt.toIso8601String(),
      'startTime': _formatTimeSpan(startTime),
      'endTime': _formatTimeSpan(endTime),
      'venues': venues.toJson(),
    };
  }

  factory Eventnormaldto.fromJson(Map<String, dynamic> json) {
    return Eventnormaldto(
      id: json['id'] ?? 0,
      categoryId: json['categoryId'] ?? 0,
      userId: json['userId'] ?? 0,
      venuesId: json['venuesId'] ?? 0,
      title: json['title'] ?? "",
      image: json['image'] ?? 0,
      description: json['description'] ?? "",
      CapacityTicketd: json['capacityTicketd'] ?? "",
      eventStart: DateTime.parse(
        json['eventStart'] ?? DateTime.now().toIso8601String(),
      ),
      eventEnd: DateTime.parse(
        json['eventEnd'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updateAt'] ?? DateTime.now().toIso8601String(),
      ),
      startTime: _parseTimeSpan(json['startTime']),
      endTime: _parseTimeSpan(json['endTime']),
      venues: Venuesnamedto.fromJson(json['venues']),
    );
  }
}
