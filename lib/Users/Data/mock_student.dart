import 'package:flutter/material.dart';
import '../Models/student.dart';

final mockStudent = Student(
  userId: "user_001", // 🔗 Simulates Firestore user document ID
  bursaryId: "bursary_123", // 🔗 Simulates Firestore bursary document ID

  educationInfo: EducationInfo(
    institution: "Kenyatta University",
    level: "University",
    year: "2nd Year",
    course: "Bachelor of Commerce",
    courseDuration: "4 Years",
    modeOfStudy: "Regular",
  ),

  attachments: [
    Attachment(
      name: "Admission Letter.pdf",
      icon: Icons.picture_as_pdf,
      fileType: "PDF",
    ),
    Attachment(
      name: "Fee Structure.pdf",
      icon: Icons.picture_as_pdf,
      fileType: "PDF",
    ),
    Attachment(
      name: "National ID Copy.jpg",
      icon: Icons.image,
      fileType: "Image",
    ),
  ],

  guardianName: "Mary Wanjiru",
  guardianPhone: "+254712345678",
);


// Mock User
final mockUser = {
  "id": "user_001",
  "fullName": "John Maina",
  "email": "john@gmail.com",
  "phone": "+254700111222",
  "role": "student",
};

// Mock Bursary
final mockBursary = {
  "id": "bursary_123",
  "name": "County Government Bursary",
  "provider": "Mombasa County Government",
  "category": "Government",
  "type": "Need-based",
  "targetGroup": "University students from low-income families",
  "level": "University",
  "region": "Mombasa",
  "fundingType": "Grant",
  "amountAvailable": 500000,
  "status": "Open",
};
