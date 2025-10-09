import 'package:flutter/material.dart';
import '../Models/student.dart';

final mockStudent = Student(
  fullName: "John Maina",
  studentId: "1122334455",
  email: "john@gmail.com",
  idNumber: "112288",

  // --- Education Info ---
  educationInfo: EducationInfo(
    institution: "Kenyatta University",
    level: "University",
    year: "Second Year",
    course: "Bachelor of Commerce",
    courseDuration: "4 Years",
    modeOfStudy: "Regular",
  ),

  // --- Bursary Info ---
  bursaryInfo: BursaryInfo(
    amountRequested: 15000,
    amountReceived: 10000,
    status: "Pending",
    statusColor: Colors.orangeAccent,
  ),

  // --- Attachments ---
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
);
