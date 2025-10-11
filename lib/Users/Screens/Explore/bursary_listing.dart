import 'package:flutter/material.dart';
import '../../../core/colors/colors.dart'; // Adjust the path to where your colors.dart is located
import '../../widgets/bursary_tile.dart';
// import '../../Data/dummy_bursaries.dart';
import 'bursary_details.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bursaconnect/Users/Models/bursary.dart';
import '../../../Admin/Services/ActiveBussaries.dart';
// import 'package:bursaconnect/Users/widget

class BursaryListing extends StatelessWidget {
  const BursaryListing({super.key});

  @override
  Widget build(BuildContext context) {
    final bursaryService = BursaryService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Available Bursaries',
          style: TextStyle(
            color: AppColors.background,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        elevation: 2,
      ),
      body: StreamBuilder<List<Bursary>>(
        stream: bursaryService.get_all_bursaries(),
        builder: (context, snapshot) {
          // 🔄 Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ Error State
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load bursaries: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // 📭 Empty State
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No bursaries available at the moment.',
                style: TextStyle(fontSize: 16, color: AppColors.text),
              ),
            );
          }

          // ✅ Data Loaded
          final bursaries = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: bursaries.length,
            itemBuilder: (context, index) {
              final bursary = bursaries[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: BursaryTile(
                  bursary: bursary,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // builder: (_) => BursaryDetails(bursary: bursary),
                        builder: (_) => BursaryDetails(bursaryId: bursary.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}