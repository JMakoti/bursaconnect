import 'package:flutter/material.dart';
import '../../core/colors/colors.dart';

class ContainerInfoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  final double? width;
  final Color? color;

  const ContainerInfoCard({
    super.key,
    required this.child,
    this.width,
    this.margin = const EdgeInsets.only(bottom: 16),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color ?? AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
