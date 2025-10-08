import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../theme/theme_provider.dart';

class ProfileAnalyticsPage extends StatefulWidget {
  const ProfileAnalyticsPage({super.key});

  @override
  State<ProfileAnalyticsPage> createState() => _ProfileAnalyticsPageState();
}

class _ProfileAnalyticsPageState extends State<ProfileAnalyticsPage> {
  String selectedPeriod = 'Last 30 days';
  final List<String> periods = [
    'Last 7 days',
    'Last 30 days',
    'Last 3 months',
    'Last 6 months',
    'Last year',
  ];

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
              'Profile Analytics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.download, color: Colors.white),
                onPressed: _exportData,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPeriodSelector(themeProvider),
                const SizedBox(height: 24),
                _buildOverviewCards(themeProvider),
                const SizedBox(height: 24),
                _buildActivityChart(themeProvider),
                const SizedBox(height: 24),
                _buildUsageStats(themeProvider),
                const SizedBox(height: 24),
                _buildSecurityInsights(themeProvider),
                const SizedBox(height: 24),
                _buildRecommendations(themeProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeriodSelector(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: AdminTheme.primaryPurple, size: 20),
          const SizedBox(width: 12),
          Text(
            'Time Period:',
            style: TextStyle(
              color: themeProvider.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          DropdownButton<String>(
            value: selectedPeriod,
            onChanged: (String? newValue) {
              setState(() {
                selectedPeriod = newValue!;
              });
            },
            dropdownColor: themeProvider.surfaceColor,
            underline: Container(),
            style: TextStyle(
              color: AdminTheme.primaryPurple,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            items: periods.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(ThemeProvider themeProvider) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildMetricCard(
          'Profile Views',
          '1,247',
          '+12%',
          Icons.visibility,
          Colors.blue,
          themeProvider,
        ),
        _buildMetricCard(
          'Login Sessions',
          '89',
          '+5%',
          Icons.login,
          Colors.green,
          themeProvider,
        ),
        _buildMetricCard(
          'Settings Changes',
          '23',
          '+8%',
          Icons.settings,
          Colors.orange,
          themeProvider,
        ),
        _buildMetricCard(
          'Security Score',
          '94%',
          '+2%',
          Icons.security,
          Colors.purple,
          themeProvider,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
    ThemeProvider themeProvider,
  ) {
    final bool isPositive = change.startsWith('+');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: isPositive ? Colors.green : Colors.red,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      change,
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: themeProvider.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: themeProvider.subtitleColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChart(ThemeProvider themeProvider) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity Overview',
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.show_chart, color: AdminTheme.primaryPurple, size: 20),
            ],
          ),
          const SizedBox(height: 20),
          // Simplified chart representation
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: themeProvider.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics,
                    color: AdminTheme.primaryPurple,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Interactive Chart',
                    style: TextStyle(
                      color: themeProvider.subtitleColor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Peak activity: 2-4 PM',
                    style: TextStyle(
                      color: themeProvider.subtitleColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageStats(ThemeProvider themeProvider) {
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
            'Usage Statistics',
            style: TextStyle(
              color: themeProvider.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildUsageItem(
            'Most Active Day',
            'Wednesday',
            '45 sessions',
            Icons.calendar_today,
            themeProvider,
          ),
          const SizedBox(height: 16),
          _buildUsageItem(
            'Average Session',
            '24 minutes',
            '+3 min from last month',
            Icons.timer,
            themeProvider,
          ),
          const SizedBox(height: 16),
          _buildUsageItem(
            'Favorite Feature',
            'Profile Settings',
            '67% of time spent',
            Icons.favorite,
            themeProvider,
          ),
          const SizedBox(height: 16),
          _buildUsageItem(
            'Device Usage',
            'Mobile: 78%',
            'Desktop: 22%',
            Icons.devices,
            themeProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildUsageItem(
    String title,
    String value,
    String subtitle,
    IconData icon,
    ThemeProvider themeProvider,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AdminTheme.primaryPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AdminTheme.primaryPurple, size: 16),
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
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: AdminTheme.primaryPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(color: themeProvider.subtitleColor, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSecurityInsights(ThemeProvider themeProvider) {
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
          Row(
            children: [
              Icon(Icons.security, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                'Security Insights',
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSecurityItem(
            'Password Strength',
            'Strong',
            Colors.green,
            Icons.check_circle,
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildSecurityItem(
            '2FA Status',
            'Enabled',
            Colors.green,
            Icons.verified_user,
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildSecurityItem(
            'Login Locations',
            '2 countries',
            Colors.orange,
            Icons.location_on,
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildSecurityItem(
            'Suspicious Activity',
            'None detected',
            Colors.green,
            Icons.shield,
            themeProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityItem(
    String title,
    String status,
    Color statusColor,
    IconData icon,
    ThemeProvider themeProvider,
  ) {
    return Row(
      children: [
        Icon(icon, color: statusColor, size: 16),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: themeProvider.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
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
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                'Recommendations',
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRecommendationItem(
            'Enable biometric login for faster access',
            'Security',
            Icons.fingerprint,
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildRecommendationItem(
            'Complete your profile for better experience',
            'Profile',
            Icons.person,
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildRecommendationItem(
            'Review your notification settings',
            'Settings',
            Icons.notifications,
            themeProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(
    String title,
    String category,
    IconData icon,
    ThemeProvider themeProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeProvider.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AdminTheme.primaryPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AdminTheme.primaryPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: AdminTheme.primaryPurple, size: 16),
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  category,
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

  void _exportData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Text(
                'Export Analytics Data',
                style: TextStyle(color: themeProvider.textColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Choose the format for your analytics export:',
                    style: TextStyle(color: themeProvider.textColor),
                  ),
                  const SizedBox(height: 16),
                  _buildExportOption(
                    'PDF Report',
                    Icons.picture_as_pdf,
                    themeProvider,
                  ),
                  const SizedBox(height: 8),
                  _buildExportOption(
                    'CSV Data',
                    Icons.table_chart,
                    themeProvider,
                  ),
                  const SizedBox(height: 8),
                  _buildExportOption('JSON Export', Icons.code, themeProvider),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: themeProvider.subtitleColor),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildExportOption(
    String title,
    IconData icon,
    ThemeProvider themeProvider,
  ) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title export started'),
            backgroundColor: AdminTheme.primaryPurple,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: themeProvider.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: themeProvider.borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: AdminTheme.primaryPurple, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: themeProvider.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
