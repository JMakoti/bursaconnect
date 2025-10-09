import 'package:flutter/material.dart';
import '../../../core/colors/colors.dart'; // Adjust the path to where your colors.dart is located
import '../../widgets/bursary_tile.dart';
import '../../Data/dummy_bursaries.dart';
import 'bursary_details.dart';

class BursaryListing extends StatelessWidget {
  const BursaryListing({super.key});

  @override
  Widget build(BuildContext context) {
    final bursaryTiles = dummyBursaries.map((bursary) {
      return BursaryTile(
        bursary: bursary,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BursaryDetails(bursary: bursary)),
          );
        },
      );
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Available Bursaries',
          style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: bursaryTiles),
      ),
    );
  }
}
