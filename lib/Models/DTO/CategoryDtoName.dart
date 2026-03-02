class CategoryDtoName {
  final int id;
  final String categoryName;
  // Remove the events list if not needed

  CategoryDtoName({
    required this.id,
    required this.categoryName,
    // Remove events from constructor
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      // Remove events from JSON
    };
  }

  factory CategoryDtoName.fromJson(Map<String, dynamic> json) {
    return CategoryDtoName(
      id: json['id'] ?? 0,
      categoryName: json['categoryName'] ?? "",
      // Remove events from parsing
    );
  }
}
