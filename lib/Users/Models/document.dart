import 'package:flutter/material.dart';

class Document {
  final String name;
  final String date;
  final String size;
  final IconData icon;

  Document({
    required this.name,
    required this.date,
    required this.size,
    required this.icon,
  });
}
