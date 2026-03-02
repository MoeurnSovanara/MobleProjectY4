import 'package:mobile_assignment/Models/DTO/EventDto.dart';

class TicketTypeAddEventDto {
  final int id;
  final String typeName;
  final double price;
  final int quantityAvailable;
  final int totalTickets;
  final Eventdto events;

  TicketTypeAddEventDto({
    required this.id,
    required this.typeName,
    required this.price,
    required this.quantityAvailable,
    required this.totalTickets,
    required this.events,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'typeName': typeName,
      'price': price,
      'quantityAvailable': quantityAvailable,
      'totalTickets': totalTickets,
      'events': events.toJson(),
    };
  }

  factory TicketTypeAddEventDto.fromJson(Map<String, dynamic> json) {
    return TicketTypeAddEventDto(
      id: json['id'] ?? 0,
      typeName: json['typeName'] ?? "",
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      quantityAvailable: json['quantityAvailable'] ?? 0,
      totalTickets: json['totalTickets'] ?? 0,
      events: Eventdto.fromJson(json['events']),
    );
  }
}
