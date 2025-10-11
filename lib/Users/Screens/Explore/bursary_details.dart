import 'package:flutter/material.dart';
import 'package:bursaconnect/core/colors/colors.dart';
import 'package:bursaconnect/Users/Models/bursary.dart';
import 'package:bursaconnect/Users/widgets/container.dart';
import '../../../Admin/Services/ActiveBussaries.dart';

class BursaryDetails extends StatefulWidget {
  final String bursaryId;

  const BursaryDetails({super.key, required this.bursaryId});

  @override
  State<BursaryDetails> createState() => _BursaryDetailsState();
}

class _BursaryDetailsState extends State<BursaryDetails> {
  final _service = BursaryService();
  Bursary? _bursary;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchBursary();
  }

  Future<void> _fetchBursary() async {
    final bursary = await _service.getBursaryById(widget.bursaryId);
    if (mounted) {
      setState(() {
        _bursary = bursary;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_bursary == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Bursary Not Found'),
          backgroundColor: AppColors.background,
        ),
        body: const Center(child: Text('This bursary could not be found.')),
      );
    }

    final bursary = _bursary!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          bursary.title,
          style: const TextStyle(color: AppColors.background),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 2,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bursaryInfoCard(bursary),
            const SizedBox(height: 16),
            _fundingDetailsCard(bursary),
            const SizedBox(height: 16),
            _eligibilityCard(bursary),
            const SizedBox(height: 16),
            _applicationDetailsCard(bursary),
          ],
        ),
      ),
    );
  }

  /// --- SECTIONS ---
  Widget _bursaryInfoCard(Bursary bursary) {
    return ContainerInfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                child: const Icon(Icons.school, size: 28, color: AppColors.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bursary.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      bursary.provider,
                      style: TextStyle(
                        color: AppColors.text.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _infoRow('Category', bursary.category),
          const Divider(),
          _infoRow('Level of Study', bursary.level),
          const Divider(),
          _infoRow('Region', bursary.region),
        ],
      ),
    );
  }

  Widget _eligibilityCard(Bursary bursary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eligibility Criteria',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        ContainerInfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: bursary.eligibility.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('• $e',
                    style: TextStyle(color: AppColors.text.withValues(alpha: 0.8))),
              ),
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _fundingDetailsCard(Bursary bursary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Funding Details',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        ContainerInfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow('Funding Type', bursary.fundingType),
              const Divider(),
              _infoRow('Amount Range', 'Ksh. ${bursary.amountRange}'),
              const Divider(),
              _infoRow('Application Deadline', bursary.deadline ?? 'Open'),
              const Divider(),
              _infoRow('Contact Email', bursary.contactEmail),
              const Divider(),
              _infoRow('Website', bursary.website),
            ],
          ),
        ),
      ],
    );
  }

  Widget _applicationDetailsCard(Bursary bursary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Application Details',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        ContainerInfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow('Mode of Application', bursary.applicationMode),
              const Divider(),
              _infoRow('Application Period', bursary.applicationPeriod),
              const Divider(),
              _infoRow('Application Link', bursary.applicationLink ?? 'N/A'),
              const Divider(),
              _infoRow('Status', bursary.isOpen ? 'Open' : 'Closed'),
            ],
          ),
        ),
      ],
    );
  }

  /// --- UTILITY ---
  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: AppColors.text.withValues(alpha: 0.8))),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
