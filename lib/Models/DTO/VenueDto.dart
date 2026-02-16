
class Venuedto {
  final int id;
  final String venueName;
  final String venueInfo;
  final String venueLocation;

  Venuedto({
    required this.id,
    required this.venueName,
    required this.venueInfo,
    required this.venueLocation,
  });

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'venueName': venueName,
      'venueInfo': venueInfo,
      'venueLocation': venueLocation,
    };
  }

  factory Venuedto.fromJson(Map<String, dynamic> json){
    return Venuedto(id: json['id'] ?? 0,
        venueName: json['venueName'] ?? "",
        venueInfo: json['venueInfo'] ?? "",
        venueLocation: json['venueLocation'] ?? "");
  }
}