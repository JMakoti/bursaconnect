import 'package:flutter/material.dart';
import 'package:bursaconnect/Users/widgets/applied_bursary_tile.dart';
import 'package:bursaconnect/core/colors/colors.dart';
import '../../Models/bursary.dart';
import '../../Services/application_service.dart';

class AppliedBursaryListing extends StatefulWidget {
  const AppliedBursaryListing({super.key});

  @override
  State<AppliedBursaryListing> createState() => _AppliedBursaryListingState();
}

class _AppliedBursaryListingState extends State<AppliedBursaryListing> {
  final _applicationService = ApplicationService();
  late Future<List<Bursary>> _appliedBursariesFuture;

  @override
  void initState() {
    super.initState();
    _appliedBursariesFuture = _fetchAppliedBursaries();
  }

  Future<List<Bursary>> _fetchAppliedBursaries() async {
    final details = await _applicationService.getAppliedBursaryDetails();
    // return details.map((data) => Bursary.fromMap(data)).toList();
    return details.map((data) => Bursary.fromJson(data, data['id'] ?? '')).toList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Applied Bursaries',
          style: TextStyle(
            color: AppColors.background,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 2,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Bursary>>(
        future: _appliedBursariesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }

          final bursaries = snapshot.data ?? [];

          if (bursaries.isEmpty) {
            return const Center(
              child: Text(
                'You haven’t applied for any bursaries yet.',
                style: TextStyle(color: AppColors.text),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: bursaries
                  .map((bursary) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: AppliedBursaryTile(bursary: bursary),
                      ))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}

