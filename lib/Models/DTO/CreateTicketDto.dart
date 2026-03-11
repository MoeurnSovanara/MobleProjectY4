class Createticketdto {
  final int id;
  final int eventId;
  final int userId;
  final int ticketTypeId;
  final String uniqueTicketCode;
  final int quantity;
  final double price;
  final String status;

  Createticketdto({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.ticketTypeId,
    required this.uniqueTicketCode,
    required this.quantity,
    required this.price,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'ticketTypeId': ticketTypeId,
      'uniqueTicketCode': uniqueTicketCode,
      'quantity': quantity,
      'price': price,
      'status': status,
    };
  }

  factory Createticketdto.fromJson(Map<String, dynamic> json) {
    return Createticketdto(
      id: json['id'] ?? 0,
      eventId: json['eventId'] ?? 0,
      userId: json['userId'] ?? 0,
      ticketTypeId: json['ticketTypeId'] ?? 0,
      uniqueTicketCode: json['uniqueTicketCode'] ?? "",
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? 0,
      status: json['status'] ?? "",
    );
  }
}
