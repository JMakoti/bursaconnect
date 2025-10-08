import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../theme/theme_provider.dart';

class NotificationPreferencesPage extends StatefulWidget {
  const NotificationPreferencesPage({super.key});

  @override
  State<NotificationPreferencesPage> createState() =>
      _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState
    extends State<NotificationPreferencesPage> {
  // Email Notifications
  bool emailNotifications = true;
  bool accountActivity = true;
  bool securityAlerts = true;
  bool productUpdates = false;
  bool weeklyDigest = true;

  // Push Notifications
  bool pushNotifications = true;
  bool messages = true;
  bool accountActivityPush = true;
  bool securityAlertsPush = true;
  bool promotions = false;

  // SMS Notifications
  bool smsNotifications = false;

  // Quiet Hours
  bool quietHours = false;

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
              'Notification Preferences',
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
              children: [
                // Email Notifications Section
                _buildEmailNotificationsCard(),

                const SizedBox(height: 24),

                // Push Notifications Section
                _buildPushNotificationsCard(),

                const SizedBox(height: 24),

                // SMS Notifications Section
                _buildSMSNotificationsCard(),

                const SizedBox(height: 24),

                // Quiet Hours Section
                _buildQuietHoursCard(),

                const SizedBox(height: 100), // Extra padding for scrolling
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmailNotificationsCard() {
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
              // Header
              _buildNotificationHeader(
                icon: Icons.email,
                title: 'Email Notifications',
                value: emailNotifications,
                onChanged: (value) {
                  setState(() {
                    emailNotifications = value;
                    if (!value) {
                      // Turn off all email notifications if main toggle is off
                      accountActivity = false;
                      securityAlerts = false;
                      productUpdates = false;
                      weeklyDigest = false;
                    }
                  });
                },
              ),

              if (emailNotifications) ...[
                _buildDivider(),
                _buildNotificationItem(
                  title: 'Account Activity',
                  subtitle: 'Updates about your account',
                  value: accountActivity,
                  onChanged: (value) {
                    setState(() {
                      accountActivity = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildNotificationItem(
                  title: 'Security Alerts',
                  subtitle: 'Important security notifications',
                  value: securityAlerts,
                  onChanged: (value) {
                    setState(() {
                      securityAlerts = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildNotificationItem(
                  title: 'Product Updates',
                  subtitle: 'New features and improvements',
                  value: productUpdates,
                  onChanged: (value) {
                    setState(() {
                      productUpdates = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildNotificationItem(
                  title: 'Weekly Digest',
                  subtitle: 'Summary of your activity',
                  value: weeklyDigest,
                  onChanged: (value) {
                    setState(() {
                      weeklyDigest = value;
                    });
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildPushNotificationsCard() {
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
              // Header
              _buildNotificationHeader(
                icon: Icons.notifications,
                title: 'Push Notifications',
                value: pushNotifications,
                onChanged: (value) {
                  setState(() {
                    pushNotifications = value;
                    if (!value) {
                      // Turn off all push notifications if main toggle is off
                      messages = false;
                      accountActivityPush = false;
                      securityAlertsPush = false;
                      promotions = false;
                    }
                  });
                },
              ),

              if (pushNotifications) ...[
                _buildDivider(),
                _buildNotificationItem(
                  title: 'Messages',
                  subtitle: 'New messages and replies',
                  value: messages,
                  onChanged: (value) {
                    setState(() {
                      messages = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildNotificationItem(
                  title: 'Account Activity',
                  subtitle: 'Login and profile changes',
                  value: accountActivityPush,
                  onChanged: (value) {
                    setState(() {
                      accountActivityPush = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildNotificationItem(
                  title: 'Security Alerts',
                  subtitle: 'Critical security events',
                  value: securityAlertsPush,
                  onChanged: (value) {
                    setState(() {
                      securityAlertsPush = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildNotificationItem(
                  title: 'Promotions',
                  subtitle: 'Special offers and deals',
                  value: promotions,
                  onChanged: (value) {
                    setState(() {
                      promotions = value;
                    });
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSMSNotificationsCard() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: themeProvider.borderColor, width: 1),
          ),
          child: _buildNotificationHeader(
            icon: Icons.sms,
            title: 'SMS Notifications',
            value: smsNotifications,
            onChanged: (value) {
              setState(() {
                smsNotifications = value;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildQuietHoursCard() {
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
              _buildNotificationHeader(
                icon: Icons.nightlight_round,
                title: 'Quiet Hours',
                subtitle: 'Silence notifications during specific hours',
                value: quietHours,
                onChanged: (value) {
                  setState(() {
                    quietHours = value;
                  });
                  if (value) {
                    _showQuietHoursDialog();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationHeader({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AdminTheme.primaryPurple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AdminTheme.primaryPurple, size: 24),
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
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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
              const SizedBox(width: 16),
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

  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
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
          margin: const EdgeInsets.symmetric(horizontal: 20),
          color: themeProvider.borderColor,
        );
      },
    );
  }

  void _showQuietHoursDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Text(
                'Quiet Hours',
                style: TextStyle(color: themeProvider.textColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Set the hours during which you don\'t want to receive notifications.',
                    style: TextStyle(color: themeProvider.textColor),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'From',
                              style: TextStyle(
                                color: themeProvider.subtitleColor,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: themeProvider.backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: themeProvider.borderColor,
                                ),
                              ),
                              child: Text(
                                '10:00 PM',
                                style: TextStyle(
                                  color: themeProvider.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'To',
                              style: TextStyle(
                                color: themeProvider.subtitleColor,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: themeProvider.backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: themeProvider.borderColor,
                                ),
                              ),
                              child: Text(
                                '7:00 AM',
                                style: TextStyle(
                                  color: themeProvider.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      quietHours = false;
                    });
                    Navigator.of(context).pop();
                  },
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
                        content: Text('Quiet hours set successfully'),
                        backgroundColor: AdminTheme.primaryPurple,
                      ),
                    );
                  },
                  child: const Text(
                    'Save',
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
