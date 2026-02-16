class Categorydto {
  final int id;
  final String categoryName;

  Categorydto({required this.id, required this.categoryName});

  Map<String, dynamic> toJson() {
    return {'id': id, 'categoryName': categoryName};
  }

  factory Categorydto.fromJson(Map<String, dynamic> json) {
    return Categorydto(
      id: json['id'] ?? 0,
      categoryName: json['categoryName'] ?? "",
    );
  }
}
