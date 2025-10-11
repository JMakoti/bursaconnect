class AppUser {
  final String id;
  final String fullname;
  final String email;
  final String? phoneNumber;
  final List<String>? appliedBursaries;

  AppUser({
    required this.id,
    required this.fullname,
    required this.email,
    this.phoneNumber,
    this.appliedBursaries,
  });

  factory AppUser.fromJson(Map<String, dynamic> json, String id) {
    return AppUser(
      id: id,
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      appliedBursaries:
          List<String>.from(json['appliedBursaries'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      'phoneNumber': phoneNumber,
      'appliedBursaries': appliedBursaries,
    };
  }
}
