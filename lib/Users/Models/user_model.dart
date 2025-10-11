class AppUser {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final List<String>? appliedBursaries;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.appliedBursaries,
  });

  factory AppUser.fromJson(Map<String, dynamic> json, String id) {
    return AppUser(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      appliedBursaries:
          List<String>.from(json['appliedBursaries'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'appliedBursaries': appliedBursaries,
    };
  }
}
