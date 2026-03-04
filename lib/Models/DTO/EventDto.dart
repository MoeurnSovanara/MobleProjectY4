import 'package:mobile_assignment/Models/DTO/CategoryDtoName.dart';
import 'package:mobile_assignment/Models/DTO/TicketTypeDto.dart';
import 'package:mobile_assignment/Models/DTO/UserEventEngagementDto.dart';
import 'package:mobile_assignment/Models/DTO/VenueDto.dart';

class Eventdto {
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
  final Duration? startTime; // Made nullable to match your model
  final Duration? endTime; // Made nullable to match your model
  final DateTime createdAt;
  final DateTime updatedAt;
  final CategoryDtoName category;
  final List<Usereventengagementdto> eventEngagement;
  final Venuedto venues;
  final List<TicketTypeDto> ticketTypes;

  Eventdto({
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
    this.startTime, // Now optional
    this.endTime, // Now optional
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.eventEngagement,
    required this.venues,
    required this.ticketTypes,
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
      'capacityTicketd': capacityTicketd,
      'eventStart': eventStart.toIso8601String(),
      'eventEnd': eventEnd.toIso8601String(),
      'startTime': _formatTimeSpan(startTime), // ADDED
      'endTime': _formatTimeSpan(endTime), // ADDED
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'category': category.toJson(),
      'eventEngagement': eventEngagement.map((e) => e.toJson()).toList(),
      'venues': venues.toJson(),
      'ticketTypes': ticketTypes.map((e) => e.toJson()).toList(),
    };
  }

  factory Eventdto.fromJson(Map<String, dynamic> json) {
    return Eventdto(
      id: json['id'] ?? 0,
      categoryId: json['categoryId'] ?? 0,
      userId: json['userId'] ?? 0,
      venuesId: json['venuesId'] ?? 0,
      title: json['title'] ?? "",
      image: json['image'] ?? "",
      description: json['description'] ?? "",
      capacityTicketd: json['capacityTicketd'] ?? "",
      eventStart: DateTime.parse(
        json['eventStart'] ?? DateTime.now().toIso8601String(),
      ),
      eventEnd: DateTime.parse(
        json['eventEnd'] ?? DateTime.now().toIso8601String(),
      ),
      startTime: _parseTimeSpan(json['startTime']), // ADDED
      endTime: _parseTimeSpan(json['endTime']), // ADDED
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      category: CategoryDtoName.fromJson(json['category'] ?? {}),
      eventEngagement:
          (json['eventEngagement'] as List<dynamic>?)
              ?.map((e) => Usereventengagementdto.fromJson(e))
              .toList() ??
          [],
      venues: Venuedto.fromJson(json['venues'] ?? {}),
      ticketTypes:
          (json['ticketTypes'] as List<dynamic>?)
              ?.map((e) => TicketTypeDto.fromJson(e))
              .toList() ??
          [],
    );
  }
}
