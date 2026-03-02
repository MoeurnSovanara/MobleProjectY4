class Venuesnamedto {
  final int id;
  final String venueName;
  final String venueInfo;
  final String venueLocation;
  Venuesnamedto({
    required this.id,
    required this.venueInfo,
    required this.venueLocation,
    required this.venueName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venueName': venueName,
      'venueInfo': venueInfo,
      'venueLocation': venueLocation,
    };
  }

  factory Venuesnamedto.fromJson(Map<String, dynamic> json) {
    return Venuesnamedto(
      id: json['id'] ?? 0,
      venueName: json['venueName'] ?? "",
      venueInfo: json['venueInfo'] ?? "",
      venueLocation: json['venueLocation'] ?? "",
    );
  }
}
