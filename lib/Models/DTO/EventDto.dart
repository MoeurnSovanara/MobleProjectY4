import 'package:mobile_assignment/Models/DTO/CategoryDto.dart';
import 'package:mobile_assignment/Models/DTO/TicketTypeDto.dart';
import 'package:mobile_assignment/Models/DTO/UserEventEngagementDto.dart';
import 'package:mobile_assignment/Models/DTO/VenueDto.dart';

class Eventdto {
  final int id;
  final String title;
  final String image;
  final String description;
  final String capacityTiket;
  final DateTime eventStart;
  final DateTime eventEnd;
  final DateTime createdAt;
  final DateTime updateAt;
  final Categorydto category;
  final List<Usereventengagementdto> userEventEngagements;
  final Venuedto venues;
  final List<TicketTypeDto> ticketTypes;

  Eventdto({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.capacityTiket,
    required this.eventStart,
    required this.eventEnd,
    required this.createdAt,
    required this.updateAt,
    required this.category,
    required this.userEventEngagements,
    required this.venues,
    required this.ticketTypes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'description': description,
      'capacityTiket': capacityTiket,
      'eventStart': eventStart.toIso8601String(),
      'eventEnd': eventEnd.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
      'category': category.toJson(),
      'userEventEngagements': userEventEngagements
          .map((e) => e.toJson())
          .toList(),
      'venues': venues.toJson(),
      'ticketTypes': ticketTypes.map((e) => e.toJson()).toList(),
    };
  }

  factory Eventdto.fromJson(Map<String, dynamic> json) {
    return Eventdto(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      image: json['image'] ?? "",
      description: json['description'] ?? "",
      capacityTiket: json['capacityTiket'] ?? "",
      eventStart: DateTime.parse(
        json['eventStart'] ?? DateTime.now().toIso8601String(),
      ),
      eventEnd: DateTime.parse(
        json['eventEnd'] ?? DateTime.now().toIso8601String(),
      ),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updateAt: DateTime.parse(
        json['updateAt'] ?? DateTime.now().toIso8601String(),
      ),
      category: Categorydto.fromJson(json['category'] ?? {}),
      userEventEngagements:
          (json['userEventEngagements'] as List<dynamic>?)
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
