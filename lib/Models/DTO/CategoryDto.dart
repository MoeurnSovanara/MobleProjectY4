import 'package:mobile_assignment/Models/DTO/EventDto.dart';

class Categorydto {
  final int id;
  final String categoryName;
  final List<Eventdto> events;

  Categorydto({
    required this.id,
    required this.categoryName,
    required this.events,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      'events': events.map((e) => e.toJson()).toList(),
    };
  }

  factory Categorydto.fromJson(Map<String, dynamic> json) {
    return Categorydto(
      id: json['id'] ?? 0,
      categoryName: json['categoryName'] ?? "",
      events:
          (json['events'] as List<dynamic>?)
              ?.map((e) => Eventdto.fromJson(e))
              .toList() ??
          [],
    );
  }
}
