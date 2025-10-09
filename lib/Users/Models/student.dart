import 'package:flutter/material.dart';

/// Top-level Student model
class Student {
  final String fullName;
  final String studentId;
  final String email;
  final String idNumber;
  final EducationInfo educationInfo;
  final BursaryInfo bursaryInfo;
  final List<Attachment> attachments;
  final String? guardianName;
  final String? guardianPhone;

  Student({
    required this.fullName,
    required this.studentId,
    required this.email,
    required this.idNumber,
    required this.educationInfo,
    required this.bursaryInfo,
    required this.attachments,
    this.guardianName,
    this.guardianPhone,
  });

  /// Copy method for updates
  Student copyWith({
    String? fullName,
    String? studentId,
    String? email,
    String? idNumber,
    EducationInfo? educationInfo,
    BursaryInfo? bursaryInfo,
    List<Attachment>? attachments,
    String? guardianName,
    String? guardianPhone,
  }) {
    return Student(
      fullName: fullName ?? this.fullName,
      studentId: studentId ?? this.studentId,
      email: email ?? this.email,
      idNumber: idNumber ?? this.idNumber,
      educationInfo: educationInfo ?? this.educationInfo,
      bursaryInfo: bursaryInfo ?? this.bursaryInfo,
      attachments: attachments ?? this.attachments,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
    );
  }

  /// JSON Serialization
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      fullName: json['fullName'],
      studentId: json['studentId'],
      email: json['email'],
      idNumber: json['idNumber'],
      educationInfo: EducationInfo.fromJson(json['educationInfo']),
      bursaryInfo: BursaryInfo.fromJson(json['bursaryInfo']),
      attachments: (json['attachments'] as List)
          .map((a) => Attachment.fromJson(a))
          .toList(),
      guardianName: json['guardianName'],
      guardianPhone: json['guardianPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'studentId': studentId,
      'email': email,
      'idNumber': idNumber,
      'educationInfo': educationInfo.toJson(),
      'bursaryInfo': bursaryInfo.toJson(),
      'attachments': attachments.map((a) => a.toJson()).toList(),
      'guardianName': guardianName,
      'guardianPhone': guardianPhone,
    };
  }
}

/// --------------------------------------------
/// Education Info Model
/// --------------------------------------------
class EducationInfo {
  final String institution;
  final String level;
  final String year;
  final String course;
  final String courseDuration;
  final String modeOfStudy;

  EducationInfo({
    required this.institution,
    required this.level,
    required this.year,
    required this.course,
    required this.courseDuration,
    required this.modeOfStudy,
  });

  factory EducationInfo.fromJson(Map<String, dynamic> json) {
    return EducationInfo(
      institution: json['institution'],
      level: json['level'],
      year: json['year'],
      course: json['course'],
      courseDuration: json['courseDuration'],
      modeOfStudy: json['modeOfStudy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'level': level,
      'year': year,
      'course': course,
      'courseDuration': courseDuration,
      'modeOfStudy': modeOfStudy,
    };
  }

  EducationInfo copyWith({
    String? institution,
    String? level,
    String? year,
    String? course,
    String? courseDuration,
    String? modeOfStudy,
  }) {
    return EducationInfo(
      institution: institution ?? this.institution,
      level: level ?? this.level,
      year: year ?? this.year,
      course: course ?? this.course,
      courseDuration: courseDuration ?? this.courseDuration,
      modeOfStudy: modeOfStudy ?? this.modeOfStudy,
    );
  }
}

/// --------------------------------------------
/// Bursary Info Model
/// --------------------------------------------
class BursaryInfo {
  final double amountRequested;
  final double amountReceived;
  final String status; // e.g. "Pending", "Approved", "Rejected"
  final Color statusColor;

  BursaryInfo({
    required this.amountRequested,
    required this.amountReceived,
    required this.status,
    required this.statusColor,
  });

  factory BursaryInfo.fromJson(Map<String, dynamic> json) {
    return BursaryInfo(
      amountRequested: (json['amountRequested'] ?? 0).toDouble(),
      amountReceived: (json['amountReceived'] ?? 0).toDouble(),
      status: json['status'],
      statusColor: _colorFromHex(json['statusColor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amountRequested': amountRequested,
      'amountReceived': amountReceived,
      'status': status,
      'statusColor': _colorToHex(statusColor),
    };
  }

  static Color _colorFromHex(String hexColor) {
    return Color(int.parse(hexColor.replaceAll('#', '0xff')));
  }

  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16)}';
  }

  BursaryInfo copyWith({
    double? amountRequested,
    double? amountReceived,
    String? status,
    Color? statusColor,
  }) {
    return BursaryInfo(
      amountRequested: amountRequested ?? this.amountRequested,
      amountReceived: amountReceived ?? this.amountReceived,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
    );
  }
}

/// --------------------------------------------
/// Attachment Model
/// --------------------------------------------
class Attachment {
  final String name;
  final IconData icon;
  final String fileType;

  Attachment({
    required this.name,
    required this.icon,
    required this.fileType,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      name: json['name'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      fileType: json['fileType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon.codePoint,
      'fileType': fileType,
    };
  }

  Attachment copyWith({
    String? name,
    IconData? icon,
    String? fileType,
  }) {
    return Attachment(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      fileType: fileType ?? this.fileType,
    );
  }
}
