import 'package:flutter/material.dart';
import '../../core/colors/colors.dart';
import '../Models/bursary.dart';
import './action_btn.dart';
import './container.dart';

class AppliedBursaryTile extends StatelessWidget {
  final Bursary bursary;

  const AppliedBursaryTile({super.key, required this.bursary});

  @override
  Widget build(BuildContext context) {
    return ContainerInfoCard(
      // color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top section — Bursary title and provider
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                child: const Icon(
                  Icons.school_rounded,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bursary.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
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
          const SizedBox(height: 12),

          /// Bursary details (amount, type, application period)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bursary.type,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Application: ${bursary.applicationPeriod}',
                  style: TextStyle(
                    color: AppColors.text.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Amount: ${bursary.amountRange}',
                  style: TextStyle(
                    color: AppColors.text.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          /// Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ActionButton(
                text: 'Pending',
                onPressed: (){},
                bgColor: AppColors.accent,
                fgColor: Colors.white,
                width: 140,
              ),
              ActionButton(
                text: 'Delete',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Delete application for ${bursary.name}'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                },
                bgColor: AppColors.error,
                fgColor: AppColors.background,
                // borderColor: AppColors.accent,
                width: 140,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
