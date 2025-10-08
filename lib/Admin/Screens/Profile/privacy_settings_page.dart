import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../theme/theme_provider.dart';
import 'services/preferences_service.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  // Privacy Settings
  bool profileVisibility = true;
  bool dataCollection = false;
  bool personalizedAds = false;
  bool analyticsTracking = true;
  bool locationTracking = false;
  bool contactsAccess = false;
  bool cameraAccess = true;
  bool microphoneAccess = false;
  bool storageAccess = true;
  bool crashReporting = true;

  // Data Retention Settings
  String dataRetentionPeriod = '2 years';
  bool autoDeleteInactiveData = true;
  bool downloadableData = true;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
    try {
      final settings = await PreferencesService.getSecuritySettings();
      if (settings.isNotEmpty) {
        setState(() {
          profileVisibility = settings['profile_visibility'] ?? true;
          dataCollection = settings['data_collection'] ?? false;
          personalizedAds = settings['personalized_ads'] ?? false;
          analyticsTracking = settings['analytics_tracking'] ?? true;
          locationTracking = settings['location_tracking'] ?? false;
          contactsAccess = settings['contacts_access'] ?? false;
          cameraAccess = settings['camera_access'] ?? true;
          microphoneAccess = settings['microphone_access'] ?? false;
          storageAccess = settings['storage_access'] ?? true;
          crashReporting = settings['crash_reporting'] ?? true;
          dataRetentionPeriod = settings['data_retention_period'] ?? '2 years';
          autoDeleteInactiveData =
              settings['auto_delete_inactive_data'] ?? true;
          downloadableData = settings['downloadable_data'] ?? true;
        });
      }
    } catch (e) {
      debugPrint('Failed to load privacy settings: $e');
    }
  }

  Future<void> _savePrivacySettings() async {
    try {
      final settings = {
        'profile_visibility': profileVisibility,
        'data_collection': dataCollection,
        'personalized_ads': personalizedAds,
        'analytics_tracking': analyticsTracking,
        'location_tracking': locationTracking,
        'contacts_access': contactsAccess,
        'camera_access': cameraAccess,
        'microphone_access': microphoneAccess,
        'storage_access': storageAccess,
        'crash_reporting': crashReporting,
        'data_retention_period': dataRetentionPeriod,
        'auto_delete_inactive_data': autoDeleteInactiveData,
        'downloadable_data': downloadableData,
      };

      await PreferencesService.saveSecuritySettings(settings);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Privacy settings saved successfully'),
            backgroundColor: AdminTheme.primaryPurple,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save privacy settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
              'Privacy Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.save, color: Colors.white),
                onPressed: _savePrivacySettings,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPrivacyOverview(themeProvider),
                const SizedBox(height: 24),
                _buildProfilePrivacy(themeProvider),
                const SizedBox(height: 24),
                _buildDataCollection(themeProvider),
                const SizedBox(height: 24),
                _buildPermissions(themeProvider),
                const SizedBox(height: 24),
                _buildDataRetention(themeProvider),
                const SizedBox(height: 24),
                _buildPrivacyActions(themeProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrivacyOverview(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AdminTheme.primaryPurple, Color(0xFF9C7FD9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.privacy_tip, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                'Privacy Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Control how your data is collected, used, and shared. Your privacy is important to us.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildPrivacyScore(themeProvider),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Privacy Score',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _getPrivacyScoreText(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyScore(ThemeProvider themeProvider) {
    final score = _calculatePrivacyScore();
    // Privacy score color (for future use)
    // final color = score >= 80 ? Colors.green : score >= 60 ? Colors.orange : Colors.red;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          '$score',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  int _calculatePrivacyScore() {
    int score = 100;
    if (dataCollection) score -= 15;
    if (personalizedAds) score -= 10;
    if (locationTracking) score -= 20;
    if (contactsAccess) score -= 10;
    if (!profileVisibility) score += 5;
    if (!analyticsTracking) score += 10;
    return score.clamp(0, 100);
  }

  String _getPrivacyScoreText() {
    final score = _calculatePrivacyScore();
    if (score >= 80) return 'Excellent privacy protection';
    if (score >= 60) return 'Good privacy settings';
    return 'Consider improving privacy settings';
  }

  Widget _buildProfilePrivacy(ThemeProvider themeProvider) {
    return _buildSection(themeProvider, 'Profile Privacy', Icons.person, [
      _buildPrivacyToggle(
        'Profile Visibility',
        'Make your profile visible to other users',
        profileVisibility,
        (value) => setState(() => profileVisibility = value),
        themeProvider,
      ),
    ]);
  }

  Widget _buildDataCollection(ThemeProvider themeProvider) {
    return _buildSection(themeProvider, 'Data Collection', Icons.data_usage, [
      _buildPrivacyToggle(
        'Data Collection',
        'Allow collection of usage data for app improvement',
        dataCollection,
        (value) => setState(() => dataCollection = value),
        themeProvider,
      ),
      const SizedBox(height: 12),
      _buildPrivacyToggle(
        'Personalized Ads',
        'Show ads based on your interests and activity',
        personalizedAds,
        (value) => setState(() => personalizedAds = value),
        themeProvider,
      ),
      const SizedBox(height: 12),
      _buildPrivacyToggle(
        'Analytics Tracking',
        'Help improve the app with anonymous usage analytics',
        analyticsTracking,
        (value) => setState(() => analyticsTracking = value),
        themeProvider,
      ),
      const SizedBox(height: 12),
      _buildPrivacyToggle(
        'Crash Reporting',
        'Automatically send crash reports to help fix issues',
        crashReporting,
        (value) => setState(() => crashReporting = value),
        themeProvider,
      ),
    ]);
  }

  Widget _buildPermissions(ThemeProvider themeProvider) {
    return _buildSection(themeProvider, 'App Permissions', Icons.security, [
      _buildPrivacyToggle(
        'Location Tracking',
        'Allow app to access your location',
        locationTracking,
        (value) => setState(() => locationTracking = value),
        themeProvider,
      ),
      const SizedBox(height: 12),
      _buildPrivacyToggle(
        'Contacts Access',
        'Allow app to access your contacts',
        contactsAccess,
        (value) => setState(() => contactsAccess = value),
        themeProvider,
      ),
      const SizedBox(height: 12),
      _buildPrivacyToggle(
        'Camera Access',
        'Allow app to access your camera',
        cameraAccess,
        (value) => setState(() => cameraAccess = value),
        themeProvider,
      ),
      const SizedBox(height: 12),
      _buildPrivacyToggle(
        'Microphone Access',
        'Allow app to access your microphone',
        microphoneAccess,
        (value) => setState(() => microphoneAccess = value),
        themeProvider,
      ),
      const SizedBox(height: 12),
      _buildPrivacyToggle(
        'Storage Access',
        'Allow app to access device storage',
        storageAccess,
        (value) => setState(() => storageAccess = value),
        themeProvider,
      ),
    ]);
  }

  Widget _buildDataRetention(ThemeProvider themeProvider) {
    return _buildSection(themeProvider, 'Data Retention', Icons.schedule, [
      _buildDataRetentionSelector(themeProvider),
      const SizedBox(height: 12),
      _buildPrivacyToggle(
        'Auto-delete Inactive Data',
        'Automatically delete data after inactivity period',
        autoDeleteInactiveData,
        (value) => setState(() => autoDeleteInactiveData = value),
        themeProvider,
      ),
      const SizedBox(height: 12),
      _buildPrivacyToggle(
        'Downloadable Data',
        'Allow downloading your data for portability',
        downloadableData,
        (value) => setState(() => downloadableData = value),
        themeProvider,
      ),
    ]);
  }

  Widget _buildDataRetentionSelector(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Retention Period',
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'How long to keep your data',
                style: TextStyle(
                  color: themeProvider.subtitleColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          DropdownButton<String>(
            value: dataRetentionPeriod,
            onChanged: (String? newValue) {
              setState(() {
                dataRetentionPeriod = newValue!;
              });
            },
            dropdownColor: themeProvider.surfaceColor,
            style: TextStyle(
              color: AdminTheme.primaryPurple,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            underline: Container(),
            items: ['6 months', '1 year', '2 years', '5 years', 'Forever']
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                })
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyActions(ThemeProvider themeProvider) {
    return _buildSection(
      themeProvider,
      'Privacy Actions',
      Icons.admin_panel_settings,
      [
        _buildActionButton(
          'Download My Data',
          'Get a copy of all your data',
          Icons.download,
          Colors.blue,
          () => _downloadData(),
          themeProvider,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Delete Account Data',
          'Permanently delete all your data',
          Icons.delete_forever,
          Colors.red,
          () => _showDeleteDataDialog(),
          themeProvider,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          'Privacy Policy',
          'Read our privacy policy',
          Icons.policy,
          Colors.green,
          () => _showPrivacyPolicy(),
          themeProvider,
        ),
      ],
    );
  }

  Widget _buildSection(
    ThemeProvider themeProvider,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AdminTheme.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AdminTheme.primaryPurple, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildPrivacyToggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    ThemeProvider themeProvider,
  ) {
    return Row(
      children: [
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
                subtitle,
                style: TextStyle(
                  color: themeProvider.subtitleColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          // activeThumbColor: AdminTheme.primaryPurple,
          activeTrackColor: AdminTheme.primaryPurple.withValues(alpha: 0.3),
          inactiveThumbColor: themeProvider.isDarkMode
              ? Colors.white
              : Colors.grey,
          inactiveTrackColor: themeProvider.subtitleColor.withValues(
            alpha: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
    ThemeProvider themeProvider,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeProvider.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
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
                    subtitle,
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
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _downloadData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Data download started. You will receive an email when ready.',
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showDeleteDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: const Text(
                'Delete Account Data',
                style: TextStyle(color: Colors.red),
              ),
              content: Text(
                'This action will permanently delete all your data and cannot be undone. Are you sure you want to continue?',
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
                        content: Text('Account deletion cancelled'),
                        backgroundColor: Colors.grey,
                      ),
                    );
                  },
                  child: const Text(
                    'Delete',
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

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Text(
                'Privacy Policy',
                style: TextStyle(color: themeProvider.textColor),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: SingleChildScrollView(
                  child: Text(
                    '''
Privacy Policy

Last updated: ${DateTime.now().toString().split(' ')[0]}

1. Information We Collect
We collect information you provide directly to us, such as when you create an account, update your profile, or contact us for support.

2. How We Use Your Information
We use the information we collect to provide, maintain, and improve our services, process transactions, and communicate with you.

3. Information Sharing
We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy.

4. Data Security
We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.

5. Your Rights
You have the right to access, update, or delete your personal information. You can also opt out of certain communications from us.

6. Contact Us
If you have any questions about this Privacy Policy, please contact us at privacy@bursaconnect.com.
                    ''',
                    style: TextStyle(
                      color: themeProvider.textColor,
                      fontSize: 12,
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
}
