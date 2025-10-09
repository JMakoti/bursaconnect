import 'package:flutter/material.dart';

// /// Top-level Student model
/// student model linked to UserModel and BusinessModel

class Student {
  final String userId; // Reference to users collection
  final String bursaryId; // Reference to bursaries collection
  final EducationInfo educationInfo;
  final List<Attachment> attachments;
  final String? guardianName;
  final String? guardianPhone;

  Student({
    required this.userId,
    required this.bursaryId,
    required this.educationInfo,
    required this.attachments,
    this.guardianName,
    this.guardianPhone,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      userId: json['userId'],
      bursaryId: json['bursaryId'],
      educationInfo: EducationInfo.fromJson(json['educationInfo']),
      attachments: (json['attachments'] as List)
          .map((a) => Attachment.fromJson(a))
          .toList(),
      guardianName: json['guardianName'],
      guardianPhone: json['guardianPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bursaryId': bursaryId,
      'educationInfo': educationInfo.toJson(),
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


