class Userdto {
  final int id;
  final String fullname;
  final String email;
  final String gender;
  final String password;
  final String phoneNumber;
  final DateTime dateOfBirth;
  final bool organizer;
  final bool verified;
  final DateTime createdAt;
  final bool google;

  Userdto({
    required this.id,
    required this.fullname,
    required this.email,
    required this.gender,
    required this.password,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.organizer,
    required this.verified,

    required this.createdAt,
    required this.google,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'gender': gender,
      'password': password,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'isOrganizer': organizer,
      'isVerified': verified,
      'createdAt': createdAt.toIso8601String(),
      'isGoogle': google,
    };
  }

  factory Userdto.fromJson(Map<String, dynamic> json) {
    return Userdto(
      id: json['id'] ?? 0,
      fullname: json['fullname'] ?? "",
      email: json['email'] ?? "",
      gender: json['gender'] ?? "",
      password: json['password'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : DateTime.now(), // Provide a default value
      organizer: json['organizer'] ?? false,
      verified: json['verified'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(), // Provide a default value
      google: json['google'] ?? false,
    );
  }
}
