import 'package:bursaconnect/Users/widgets/applied_bursary_tile.dart';
import 'package:flutter/material.dart';
import '../../../core/colors.dart'; // Adjust the path to where your colors.dart is located
import '../../Data/dummy_bursaries.dart';
// import 'bursary_details.dart';

class AppliedBursaryListing extends StatelessWidget {
  const AppliedBursaryListing ({super.key});

  @override
  Widget build(BuildContext context) {
    final bursaryTiles = dummyBursaries.map((bursary) {
      return AppliedBursaryTile(
        bursary: bursary,
      );
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Applied Bursaries',
          style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: bursaryTiles),
      ),
    );
  }
}
