import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../theme/theme_provider.dart';

class SecurityReportPage extends StatefulWidget {
  const SecurityReportPage({super.key});

  @override
  State<SecurityReportPage> createState() => _SecurityReportPageState();
}

class _SecurityReportPageState extends State<SecurityReportPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            backgroundColor: AdminTheme.primaryPurple,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Security Report',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSecurityScore(themeProvider),
                const SizedBox(height: 24),
                _buildSecurityChecks(themeProvider),
                const SizedBox(height: 24),
                _buildRecentActivity(themeProvider),
                const SizedBox(height: 24),
                _buildRecommendations(themeProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSecurityScore(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AdminTheme.primaryPurple, Color(0xFF9C7FD9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Security Score',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '94',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Excellent',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.94,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityChecks(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Checks',
            style: TextStyle(
              color: themeProvider.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSecurityCheck(
            'Strong Password',
            true,
            'Your password meets security requirements',
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildSecurityCheck(
            'Two-Factor Authentication',
            true,
            'Additional security layer enabled',
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildSecurityCheck(
            'Biometric Authentication',
            true,
            'Fingerprint/Face ID enabled',
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildSecurityCheck(
            'Recent Login Activity',
            false,
            'Unusual login detected from new location',
            themeProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCheck(
    String title,
    bool isSecure,
    String description,
    ThemeProvider themeProvider,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSecure
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            isSecure ? Icons.check_circle : Icons.warning,
            color: isSecure ? Colors.green : Colors.orange,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: themeProvider.subtitleColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Security Activity',
            style: TextStyle(
              color: themeProvider.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildActivityItem(
            'Password Changed',
            '2 days ago',
            Icons.lock,
            Colors.green,
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildActivityItem(
            'New Device Login',
            '1 week ago',
            Icons.devices,
            Colors.orange,
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildActivityItem(
            '2FA Enabled',
            '2 weeks ago',
            Icons.security,
            Colors.green,
            themeProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
    ThemeProvider themeProvider,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: themeProvider.subtitleColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Recommendations',
            style: TextStyle(
              color: themeProvider.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecommendation(
            'Review recent login from unknown location',
            'Check if the login from New York was authorized',
            Icons.location_on,
            Colors.orange,
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildRecommendation(
            'Update recovery email',
            'Add a backup email for account recovery',
            Icons.email,
            Colors.blue,
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildRecommendation(
            'Enable login notifications',
            'Get notified of all login attempts',
            Icons.notifications,
            Colors.green,
            themeProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendation(
    String title,
    String description,
    IconData icon,
    Color color,
    ThemeProvider themeProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeProvider.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: themeProvider.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: themeProvider.subtitleColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: themeProvider.subtitleColor,
            size: 14,
          ),
        ],
      ),
    );
  }
}
