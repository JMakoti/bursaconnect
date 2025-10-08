import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../theme/theme_provider.dart';
import 'connected_accounts_page.dart';
import 'data_management_page.dart';
// import 'help_support_page.dart';
import 'notification_preferences_page.dart';
import 'profile_analytics_page.dart';
import 'profile_page.dart';
import 'security_settings_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool twoFactorEnabled = false;
  bool notificationsEnabled = true;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: AppBar(
            backgroundColor: const Color(0xFFB19CD9),
            elevation: 0,
            title: const Text(
              'Settings',
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
                // Profile Section
                _buildSectionTitle('Profile'),
                const SizedBox(height: 12),
                _buildProfileCard(),

                const SizedBox(height: 24),

                // Account Settings Section
                _buildSectionTitle('Account Settings'),
                const SizedBox(height: 12),
                _buildAccountSettingsCard(),

                const SizedBox(height: 24),

                // Appearance Section
                _buildSectionTitle('Appearance'),
                const SizedBox(height: 12),
                _buildAppearanceCard(),

                const SizedBox(height: 24),

                // Other Preferences Section
                _buildSectionTitle('Other Preferences'),
                const SizedBox(height: 12),
                _buildOtherPreferencesCard(),

                const SizedBox(height: 24),

                // Data & Analytics Section
                _buildSectionTitle('Data & Analytics'),
                const SizedBox(height: 12),
                _buildDataAnalyticsCard(),

                const SizedBox(height: 32),

                // Logout Button
                _buildLogoutButton(),

                const SizedBox(height: 24),

                // App Version
                _buildAppVersion(),

                const SizedBox(
                  height: 100,
                ), // Extra padding for bottom navigation
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

  Widget _buildProfileCard() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: themeProvider.borderColor, width: 1),
          ),
          child: _buildSettingItem(
            icon: Icons.person,
            iconColor: AdminTheme.primaryPurple,
            title: 'My Profile',
            subtitle: 'View and edit your profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAccountSettingsCard() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: themeProvider.borderColor, width: 1),
          ),
          child: Column(
            children: [
              _buildSettingItem(
                icon: Icons.security,
                iconColor: AdminTheme.primaryPurple,
                title: 'Security Settings',
                subtitle: 'Manage your account security',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecuritySettingsPage(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.lock,
                iconColor: AdminTheme.primaryPurple,
                title: 'Change Password',
                onTap: () {
                  _showChangePasswordDialog();
                },
              ),
              _buildDivider(),
              _buildSettingItemWithToggle(
                icon: Icons.security,
                iconColor: AdminTheme.primaryPurple,
                title: 'Two-Factor Authentication',
                value: twoFactorEnabled,
                onChanged: (value) {
                  setState(() {
                    twoFactorEnabled = value;
                  });
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.link,
                iconColor: AdminTheme.primaryPurple,
                title: 'Connected Accounts',
                subtitle: 'Manage your connected accounts',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConnectedAccountsPage(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.delete_forever,
                iconColor: Colors.red,
                title: 'Delete Account',
                onTap: () {
                  _showDeleteAccountDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppearanceCard() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: themeProvider.borderColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose your theme',
                  style: TextStyle(
                    color: themeProvider.subtitleColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: AdminThemeMode.values.map((mode) {
                    final isSelected = themeProvider.themeMode == mode;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _buildThemeOption(
                          mode.displayName,
                          mode.icon,
                          isSelected,
                          () => themeProvider.setThemeMode(mode),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    String theme,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AdminTheme.primaryPurple
                  : themeProvider.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AdminTheme.primaryPurple
                    : themeProvider.borderColor,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? Colors.white
                      : themeProvider.subtitleColor,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  theme,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : themeProvider.subtitleColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(height: 4),
                  const Icon(Icons.check_circle, color: Colors.white, size: 16),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOtherPreferencesCard() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: themeProvider.borderColor, width: 1),
          ),
          child: Column(
            children: [
              _buildSettingItem(
                icon: Icons.language,
                iconColor: AdminTheme.primaryPurple,
                title: 'Language',
                subtitle: selectedLanguage,
                onTap: () {
                  _showLanguageDialog();
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.notifications,
                iconColor: AdminTheme.primaryPurple,
                title: 'Notification Preferences',
                subtitle: 'Manage your notifications',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPreferencesPage(),
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

  Widget _buildDataAnalyticsCard() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: themeProvider.borderColor, width: 1),
          ),
          child: Column(
            children: [
              _buildSettingItem(
                icon: Icons.analytics,
                iconColor: AdminTheme.primaryPurple,
                title: 'Profile Analytics',
                subtitle: 'View your usage statistics',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileAnalyticsPage(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.storage,
                iconColor: AdminTheme.primaryPurple,
                title: 'Data Management',
                subtitle: 'Backup, export, and manage your data',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DataManagementPage(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.help,
                iconColor: AdminTheme.primaryPurple,
                title: 'Help & Support',
                subtitle: 'Get help and contact support',
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const HelpSupportPage(),
                  //   ),
                  // );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
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
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: themeProvider.subtitleColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
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

  Widget _buildSettingItemWithToggle({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
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
                  color: iconColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
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
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: themeProvider.subtitleColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                // activeThumbColor: AdminTheme.primaryPurple,
                activeTrackColor: AdminTheme.primaryPurple.withValues(
                  alpha: 0.3,
                ),
                inactiveThumbColor: themeProvider.isDarkMode
                    ? Colors.white
                    : Colors.grey,
                inactiveTrackColor: themeProvider.subtitleColor.withValues(
                  alpha: 0.3,
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

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: InkWell(
        onTap: _showLogoutDialog,
        borderRadius: BorderRadius.circular(12),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 12),
              Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppVersion() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Center(
          child: Text(
            'App Version 1.0.0',
            style: TextStyle(color: themeProvider.subtitleColor, fontSize: 14),
          ),
        );
      },
    );
  }

  // Dialog methods
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

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Text(
                'Select Language',
                style: TextStyle(color: themeProvider.textColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    [
                      'English',
                      'Spanish',
                      'French',
                      'German',
                      'Chinese',
                      'Japanese',
                    ].map((language) {
                      return ListTile(
                        title: Text(
                          language,
                          style: TextStyle(color: themeProvider.textColor),
                        ),
                        leading: Radio<String>(
                          value: language,
                          groupValue: selectedLanguage,
                          onChanged: (String? value) {
                            setState(() {
                              selectedLanguage = value!;
                            });
                            Navigator.of(context).pop();
                          },
                          activeColor: AdminTheme.primaryPurple,
                        ),
                      );
                    }).toList(),
              ),
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
                'Are you sure you want to delete your account? This action cannot be undone.',
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Text(
                'Log Out',
                style: TextStyle(color: themeProvider.textColor),
              ),
              content: Text(
                'Are you sure you want to log out?',
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
                    // Handle logout
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Logged out successfully'),
                        backgroundColor: AdminTheme.primaryPurple,
                      ),
                    );
                  },
                  child: const Text(
                    'Log Out',
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
