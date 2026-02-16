class TicketTypeDto {
  final int id;
  final String typeName;
  final double price;
  final int quantityAvailable;
  final int totalTickets;

  TicketTypeDto({
    required this.id,
    required this.typeName,
    required this.price,
    required this.quantityAvailable,
    required this.totalTickets,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'typeName': typeName,
      'price': price,
      'quantityAvailable': quantityAvailable,
      'totalTickets': totalTickets,
    };
  }

  factory TicketTypeDto.fromJson(Map<String, dynamic> json) {
    return TicketTypeDto(
      id: json['id'] ?? 0,
      typeName: json['typeName'] ?? "",
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      quantityAvailable: json['quantityAvailable'] ?? 0,
      totalTickets: json['totalTickets'] ?? 0,
    );
  }
}
