import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../theme/theme_provider.dart';
import 'login_activity_page.dart';
import 'privacy_settings_page.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  bool twoFactorEnabled = false;
  bool biometricEnabled = false;
  bool loginAlertsEnabled = true;
  bool deviceTrackingEnabled = true;

  List<Map<String, dynamic>> loginHistory = [
    {
      'device': 'iPhone 14 Pro',
      'location': 'New York, NY',
      'time': '2 hours ago',
      'status': 'current',
    },
    {
      'device': 'MacBook Pro',
      'location': 'New York, NY',
      'time': '1 day ago',
      'status': 'success',
    },
    {
      'device': 'Chrome Browser',
      'location': 'Los Angeles, CA',
      'time': '3 days ago',
      'status': 'success',
    },
    {
      'device': 'Unknown Device',
      'location': 'Miami, FL',
      'time': '1 week ago',
      'status': 'blocked',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSecuritySettings();
  }

  Future<void> _loadSecuritySettings() async {
    // Load security settings from preferences
    // This would typically come from your backend
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            backgroundColor: const Color(0xFFB19CD9),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Security Settings',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Authentication Section
                _buildSectionTitle('Authentication'),
                const SizedBox(height: 12),
                _buildAuthenticationCard(),

                const SizedBox(height: 24),

                // Privacy & Security Section
                _buildSectionTitle('Privacy & Security'),
                const SizedBox(height: 12),
                _buildPrivacyCard(),

                const SizedBox(height: 24),

                // Login History Section
                _buildSectionTitle('Recent Login Activity'),
                const SizedBox(height: 12),
                _buildLoginHistoryCard(),

                const SizedBox(height: 24),

                // Security Actions Section
                _buildSectionTitle('Security Actions'),
                const SizedBox(height: 12),
                _buildSecurityActionsCard(),

                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Text(
          title,
          style: TextStyle(
            color: themeProvider.textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }

  Widget _buildAuthenticationCard() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: themeProvider.borderColor, width: 1),
          ),
          child: Column(
            children: [
              _buildSecurityToggleItem(
                icon: Icons.security,
                title: 'Two-Factor Authentication',
                subtitle: 'Add an extra layer of security',
                value: twoFactorEnabled,
                onChanged: (value) {
                  if (value) {
                    _showTwoFactorSetupDialog();
                  } else {
                    _showDisableTwoFactorDialog();
                  }
                },
              ),
              _buildDivider(),
              _buildSecurityToggleItem(
                icon: Icons.fingerprint,
                title: 'Biometric Authentication',
                subtitle: 'Use fingerprint or face ID',
                value: biometricEnabled,
                onChanged: (value) {
                  setState(() {
                    biometricEnabled = value;
                  });
                  if (value) {
                    _setupBiometric();
                  }
                },
              ),
              _buildDivider(),
              _buildSecurityItem(
                icon: Icons.lock_reset,
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: _showChangePasswordDialog,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrivacyCard() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: themeProvider.borderColor, width: 1),
          ),
          child: Column(
            children: [
              _buildSecurityToggleItem(
                icon: Icons.notifications_active,
                title: 'Login Alerts',
                subtitle: 'Get notified of new logins',
                value: loginAlertsEnabled,
                onChanged: (value) {
                  setState(() {
                    loginAlertsEnabled = value;
                  });
                },
              ),
              _buildDivider(),
              _buildSecurityToggleItem(
                icon: Icons.devices,
                title: 'Device Tracking',
                subtitle: 'Track devices that access your account',
                value: deviceTrackingEnabled,
                onChanged: (value) {
                  setState(() {
                    deviceTrackingEnabled = value;
                  });
                },
              ),
              _buildDivider(),
              _buildSecurityItem(
                icon: Icons.privacy_tip,
                title: 'Privacy Settings',
                subtitle: 'Manage your privacy preferences',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacySettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoginHistoryCard() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: themeProvider.borderColor, width: 1),
          ),
          child: Column(
            children: [
              ...loginHistory.map((login) => _buildLoginHistoryItem(login)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _showFullLoginHistory,
                  child: Text(
                    'View All Login Activity',
                    style: TextStyle(
                      color: AdminTheme.primaryPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoginHistoryItem(Map<String, dynamic> login) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        Color statusColor;
        IconData statusIcon;

        switch (login['status']) {
          case 'current':
            statusColor = Colors.green;
            statusIcon = Icons.check_circle;
            break;
          case 'success':
            statusColor = themeProvider.subtitleColor;
            statusIcon = Icons.check;
            break;
          case 'blocked':
            statusColor = Colors.red;
            statusIcon = Icons.block;
            break;
          default:
            statusColor = themeProvider.subtitleColor;
            statusIcon = Icons.help;
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(statusIcon, color: statusColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      login['device'],
                      style: TextStyle(
                        color: themeProvider.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${login['location']} • ${login['time']}',
                      style: TextStyle(
                        color: themeProvider.subtitleColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (login['status'] == 'current')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Current',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSecurityActionsCard() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: themeProvider.borderColor, width: 1),
          ),
          child: Column(
            children: [
              _buildSecurityItem(
                icon: Icons.logout,
                iconColor: Colors.orange,
                title: 'Sign Out All Devices',
                subtitle: 'Sign out from all other devices',
                onTap: _showSignOutAllDialog,
              ),
              _buildDivider(),
              _buildSecurityItem(
                icon: Icons.download,
                title: 'Download Security Report',
                subtitle: 'Get a report of your security activity',
                onTap: _downloadSecurityReport,
              ),
              _buildDivider(),
              _buildSecurityItem(
                icon: Icons.delete_forever,
                iconColor: Colors.red,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                onTap: _showDeleteAccountDialog,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSecurityItem({
    required IconData icon,
    Color? iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AdminTheme.primaryPurple).withOpacity(
                      0.2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AdminTheme.primaryPurple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: themeProvider.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: themeProvider.subtitleColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: themeProvider.subtitleColor),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSecurityToggleItem({
    required IconData icon,
    Color? iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (iconColor ?? AdminTheme.primaryPurple).withOpacity(
                    0.2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AdminTheme.primaryPurple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: themeProvider.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: themeProvider.subtitleColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Switch(
                value: value,
                onChanged: onChanged,
                // activeThumbColor: AdminTheme.primaryPurple,
                activeTrackColor: AdminTheme.primaryPurple.withOpacity(0.3),
                inactiveThumbColor: themeProvider.isDarkMode
                    ? Colors.white
                    : Colors.grey,
                inactiveTrackColor: themeProvider.subtitleColor.withOpacity(
                  0.3,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          color: themeProvider.borderColor,
        );
      },
    );
  }

  // Dialog and action methods
  void _showTwoFactorSetupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Text(
                'Enable Two-Factor Authentication',
                style: TextStyle(color: themeProvider.textColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Two-factor authentication adds an extra layer of security to your account.',
                    style: TextStyle(color: themeProvider.textColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Choose your preferred method:',
                    style: TextStyle(color: themeProvider.subtitleColor),
                  ),
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
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      twoFactorEnabled = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Two-factor authentication enabled'),
                        backgroundColor: AdminTheme.primaryPurple,
                      ),
                    );
                  },
                  child: const Text(
                    'Enable',
                    style: TextStyle(color: AdminTheme.primaryPurple),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDisableTwoFactorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Text(
                'Disable Two-Factor Authentication',
                style: TextStyle(color: themeProvider.textColor),
              ),
              content: Text(
                'Are you sure you want to disable two-factor authentication? This will make your account less secure.',
                style: TextStyle(color: themeProvider.textColor),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: themeProvider.subtitleColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      twoFactorEnabled = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Two-factor authentication disabled'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  child: const Text(
                    'Disable',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _setupBiometric() {
    // Implement biometric setup
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Biometric authentication enabled'),
        backgroundColor: AdminTheme.primaryPurple,
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Text(
                'Change Password',
                style: TextStyle(color: themeProvider.textColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    obscureText: true,
                    style: TextStyle(color: themeProvider.textColor),
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      labelStyle: TextStyle(color: themeProvider.subtitleColor),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.subtitleColor,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AdminTheme.primaryPurple),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: true,
                    style: TextStyle(color: themeProvider.textColor),
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      labelStyle: TextStyle(color: themeProvider.subtitleColor),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.subtitleColor,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AdminTheme.primaryPurple),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: true,
                    style: TextStyle(color: themeProvider.textColor),
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      labelStyle: TextStyle(color: themeProvider.subtitleColor),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.subtitleColor,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AdminTheme.primaryPurple),
                      ),
                    ),
                  ),
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
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password changed successfully'),
                        backgroundColor: AdminTheme.primaryPurple,
                      ),
                    );
                  },
                  child: const Text(
                    'Change',
                    style: TextStyle(color: AdminTheme.primaryPurple),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showFullLoginHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginActivityPage()),
    );
  }

  void _showSignOutAllDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Text(
                'Sign Out All Devices',
                style: TextStyle(color: themeProvider.textColor),
              ),
              content: Text(
                'This will sign you out from all devices except this one. You\'ll need to sign in again on those devices.',
                style: TextStyle(color: themeProvider.textColor),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: themeProvider.subtitleColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Signed out from all other devices'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  child: const Text(
                    'Sign Out All',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _downloadSecurityReport() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Row(
                children: [
                  Icon(Icons.download, color: AdminTheme.primaryPurple),
                  const SizedBox(width: 8),
                  Text(
                    'Security Report',
                    style: TextStyle(color: themeProvider.textColor),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose the type of security report to download:',
                      style: TextStyle(
                        color: themeProvider.textColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildReportOption(
                      'Complete Security Report',
                      'Full security analysis with all details',
                      Icons.security,
                      () => _generateSecurityReport('complete'),
                      themeProvider,
                    ),
                    const SizedBox(height: 8),
                    _buildReportOption(
                      'Login Activity Report',
                      'Detailed login history and analysis',
                      Icons.login,
                      () => _generateSecurityReport('login'),
                      themeProvider,
                    ),
                    const SizedBox(height: 8),
                    _buildReportOption(
                      'Privacy Settings Report',
                      'Current privacy configuration',
                      Icons.privacy_tip,
                      () => _generateSecurityReport('privacy'),
                      themeProvider,
                    ),
                    const SizedBox(height: 8),
                    _buildReportOption(
                      'Security Recommendations',
                      'Personalized security improvements',
                      Icons.lightbulb,
                      () => _generateSecurityReport('recommendations'),
                      themeProvider,
                    ),
                  ],
                ),
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

  Widget _buildReportOption(
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
    ThemeProvider themeProvider,
  ) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: themeProvider.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: themeProvider.borderColor),
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
            Icon(Icons.download, color: AdminTheme.primaryPurple, size: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _generateSecurityReport(String reportType) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return AlertDialog(
            backgroundColor: themeProvider.surfaceColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: AdminTheme.primaryPurple,
                ),
                const SizedBox(height: 16),
                Text(
                  'Generating security report...',
                  style: TextStyle(color: themeProvider.textColor),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Simulate report generation
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Close loading dialog
    Navigator.of(context).pop();

    // Generate the actual report content
    final reportContent = _createReportContent(reportType);

    // Show report preview and download options
    _showReportPreview(reportType, reportContent);
  }

  String _createReportContent(String reportType) {
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';
    final timeStr = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    switch (reportType) {
      case 'complete':
        return '''
COMPLETE SECURITY REPORT
Generated: $dateStr at $timeStr

=== ACCOUNT OVERVIEW ===
Account Status: Active
Security Score: 94/100
Two-Factor Authentication: ${twoFactorEnabled ? 'Enabled' : 'Disabled'}
Biometric Authentication: ${biometricEnabled ? 'Enabled' : 'Disabled'}
Login Alerts: ${loginAlertsEnabled ? 'Enabled' : 'Disabled'}

=== RECENT LOGIN ACTIVITY ===
${loginHistory.map((login) => '• ${login['device']} from ${login['location']} - ${login['time']} (${login['status']})').join('\n')}

=== SECURITY SETTINGS ===
• Password: Strong (last changed 2 weeks ago)
• Recovery Email: Verified
• Phone Number: Verified
• Device Tracking: ${deviceTrackingEnabled ? 'Enabled' : 'Disabled'}

=== PRIVACY SETTINGS ===
• Profile Visibility: Public
• Data Collection: Minimal
• Location Tracking: Disabled
• Analytics: Enabled

=== RECOMMENDATIONS ===
• Consider enabling biometric authentication
• Review connected third-party applications
• Update recovery information regularly
• Monitor login activity weekly

=== THREAT ANALYSIS ===
• No suspicious activity detected
• All login locations verified
• No unauthorized access attempts
• Account security: Excellent

Report generated by BursaConnect Security System
''';

      case 'login':
        return '''
LOGIN ACTIVITY REPORT
Generated: $dateStr at $timeStr

=== LOGIN SUMMARY ===
Total Logins (Last 30 days): ${loginHistory.length}
Successful Logins: ${loginHistory.where((l) => l['status'] == 'success' || l['status'] == 'current').length}
Failed Attempts: ${loginHistory.where((l) => l['status'] == 'blocked').length}
Unique Locations: 4
Unique Devices: ${loginHistory.map((l) => l['device']).toSet().length}

=== DETAILED LOGIN HISTORY ===
${loginHistory.map((login) => '''
Device: ${login['device']}
Location: ${login['location']}
Time: ${login['time']}
Status: ${login['status']}
IP Address: [Redacted for security]
---''').join('\n')}

=== SECURITY ANALYSIS ===
• Most active device: ${loginHistory.first['device']}
• Most common location: New York, NY
• Peak login time: 2-4 PM
• Security incidents: 1 blocked attempt

=== RECOMMENDATIONS ===
• Review the blocked login attempt from Miami, FL
• Consider enabling login notifications
• Verify all device access is authorized
''';

      case 'privacy':
        return '''
PRIVACY SETTINGS REPORT
Generated: $dateStr at $timeStr

=== CURRENT PRIVACY CONFIGURATION ===
Profile Visibility: Public
Data Collection: Minimal
Personalized Ads: Disabled
Analytics Tracking: Enabled
Location Tracking: Disabled
Contact Access: Disabled
Camera Access: Enabled
Microphone Access: Disabled
Storage Access: Enabled

=== DATA RETENTION ===
Retention Period: 2 years
Auto-delete Inactive Data: Enabled
Downloadable Data: Enabled

=== PRIVACY SCORE ===
Current Score: 85/100
Rating: Good Privacy Protection

=== RECOMMENDATIONS ===
• Consider disabling analytics tracking for better privacy
• Review app permissions regularly
• Enable auto-delete for better data management
• Consider shorter data retention period
''';

      case 'recommendations':
        return '''
SECURITY RECOMMENDATIONS REPORT
Generated: $dateStr at $timeStr

=== HIGH PRIORITY ===
1. Enable Biometric Authentication
   - Adds an extra layer of security
   - Faster and more secure login
   - Reduces password dependency

2. Review Blocked Login Attempt
   - Unknown device from Miami, FL
   - Investigate if this was authorized
   - Consider changing password if suspicious

=== MEDIUM PRIORITY ===
3. Update Recovery Information
   - Verify backup email address
   - Add secondary phone number
   - Test recovery process

4. Review Connected Applications
   - Audit third-party app access
   - Remove unused connections
   - Update permissions as needed

=== LOW PRIORITY ===
5. Enable Login Notifications
   - Get alerts for new device logins
   - Monitor account access in real-time
   - Quick response to unauthorized access

6. Regular Security Checkups
   - Monthly login activity review
   - Quarterly password updates
   - Annual security settings audit

=== PRIVACY IMPROVEMENTS ===
7. Optimize Privacy Settings
   - Review data collection preferences
   - Adjust location tracking settings
   - Configure notification preferences

=== IMPLEMENTATION TIMELINE ===
Week 1: Enable biometric auth, review blocked login
Week 2: Update recovery info, audit connected apps
Week 3: Configure notifications, privacy review
Month 2: Implement regular security checkups

Your current security score: 94/100
Potential score after improvements: 98/100
''';

      default:
        return 'Security report content not available.';
    }
  }

  void _showReportPreview(String reportType, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Row(
                children: [
                  Icon(Icons.preview, color: AdminTheme.primaryPurple),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Security Report Preview',
                      style: TextStyle(color: themeProvider.textColor),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AdminTheme.primaryPurple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: AdminTheme.primaryPurple,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Report generated successfully. Preview below:',
                              style: TextStyle(
                                color: AdminTheme.primaryPurple,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: themeProvider.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: themeProvider.borderColor),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            content,
                            style: TextStyle(
                              color: themeProvider.textColor,
                              fontSize: 11,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close',
                    style: TextStyle(color: themeProvider.subtitleColor),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _simulateDownload(reportType, content);
                  },
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Download'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminTheme.primaryPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _simulateDownload(String reportType, String content) {
    // Show download progress
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return AlertDialog(
            backgroundColor: themeProvider.surfaceColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: AdminTheme.primaryPurple,
                ),
                const SizedBox(height: 16),
                Text(
                  'Downloading report...',
                  style: TextStyle(color: themeProvider.textColor),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Simulate download time
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.of(context).pop();

      // Show success message with file details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Security report downloaded successfully!',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'File: security_report_${reportType}_${DateTime.now().millisecondsSinceEpoch}.txt',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Size: ${(content.length / 1024).toStringAsFixed(1)} KB',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'View',
            textColor: Colors.white,
            onPressed: () {
              _showDownloadedReport(reportType, content);
            },
          ),
        ),
      );
    });
  }

  void _showDownloadedReport(String reportType, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Text(
                'Downloaded Report',
                style: TextStyle(color: themeProvider.textColor),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: SingleChildScrollView(
                  child: Text(
                    content,
                    style: TextStyle(
                      color: themeProvider.textColor,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: AdminTheme.primaryPurple),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.red),
              ),
              content: Text(
                'Are you sure you want to permanently delete your account? This action cannot be undone and all your data will be lost.',
                style: TextStyle(color: themeProvider.textColor),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: themeProvider.subtitleColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Handle account deletion
                  },
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
