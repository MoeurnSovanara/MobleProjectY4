import 'package:mobile_assignment/Models/DTO/TicketTypeAddEventDto.dart';

class Ticketdto {
  final int id;
  final int eventId;
  final int userId;
  final TicketTypeAddEventDto ticketType;
  final String uniqueTicketCode;
  final int quantity;
  final String status;

  Ticketdto({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.ticketType,
    required this.uniqueTicketCode,
    required this.quantity,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'ticketType': ticketType.toJson(),
      'uniqueTicketCode': uniqueTicketCode,
      'quantity': quantity,
      'status': status,
    };
  }

  factory Ticketdto.fromJson(Map<String, dynamic> json) {
    return Ticketdto(
      id: json['id'] ?? 0,
      eventId: json['eventId'] ?? 0,
      userId: json['userId'] ?? 0,
      ticketType: TicketTypeAddEventDto.fromJson(json['ticketType']),
      uniqueTicketCode: json['uniqueTicketCode'] ?? "",
      quantity: json['quantity'] ?? 1,
      status: json['status'] ?? "",
    );
  }
}
