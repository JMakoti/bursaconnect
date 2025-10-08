import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../theme/theme_provider.dart';

class LoginActivityPage extends StatefulWidget {
  const LoginActivityPage({super.key});

  @override
  State<LoginActivityPage> createState() => _LoginActivityPageState();
}

class _LoginActivityPageState extends State<LoginActivityPage> {
  String selectedFilter = 'All';
  final List<String> filters = [
    'All',
    'Current Session',
    'Successful',
    'Failed',
    'Blocked',
  ];

  List<LoginActivity> loginActivities = [
    LoginActivity(
      device: 'iPhone 14 Pro',
      location: 'New York, NY',
      ipAddress: '192.168.1.100',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      status: LoginStatus.current,
      browser: 'Safari 17.0',
      os: 'iOS 17.1',
    ),
    LoginActivity(
      device: 'MacBook Pro',
      location: 'New York, NY',
      ipAddress: '192.168.1.101',
      time: DateTime.now().subtract(const Duration(days: 1)),
      status: LoginStatus.success,
      browser: 'Chrome 119.0',
      os: 'macOS 14.0',
    ),
    LoginActivity(
      device: 'Chrome Browser',
      location: 'Los Angeles, CA',
      ipAddress: '203.0.113.45',
      time: DateTime.now().subtract(const Duration(days: 3)),
      status: LoginStatus.success,
      browser: 'Chrome 118.0',
      os: 'Windows 11',
    ),
    LoginActivity(
      device: 'Unknown Device',
      location: 'Miami, FL',
      ipAddress: '198.51.100.23',
      time: DateTime.now().subtract(const Duration(days: 7)),
      status: LoginStatus.blocked,
      browser: 'Firefox 119.0',
      os: 'Linux Ubuntu',
    ),
    LoginActivity(
      device: 'Samsung Galaxy S23',
      location: 'Chicago, IL',
      ipAddress: '203.0.113.67',
      time: DateTime.now().subtract(const Duration(days: 10)),
      status: LoginStatus.success,
      browser: 'Samsung Internet',
      os: 'Android 14',
    ),
    LoginActivity(
      device: 'iPad Air',
      location: 'San Francisco, CA',
      ipAddress: '192.168.1.102',
      time: DateTime.now().subtract(const Duration(days: 14)),
      status: LoginStatus.success,
      browser: 'Safari 17.0',
      os: 'iPadOS 17.1',
    ),
    LoginActivity(
      device: 'Unknown Device',
      location: 'Houston, TX',
      ipAddress: '198.51.100.89',
      time: DateTime.now().subtract(const Duration(days: 18)),
      status: LoginStatus.failed,
      browser: 'Chrome 117.0',
      os: 'Windows 10',
    ),
    LoginActivity(
      device: 'Dell Laptop',
      location: 'Boston, MA',
      ipAddress: '203.0.113.12',
      time: DateTime.now().subtract(const Duration(days: 21)),
      status: LoginStatus.success,
      browser: 'Edge 119.0',
      os: 'Windows 11',
    ),
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
              'Login Activity',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.security, color: Colors.white),
                onPressed: _showSecurityTips,
              ),
            ],
          ),
          body: Column(
            children: [
              _buildHeader(themeProvider),
              _buildFilterTabs(themeProvider),
              Expanded(child: _buildLoginList(themeProvider)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeProvider themeProvider) {
    final filteredActivities = _getFilteredActivities();
    final currentSessions = filteredActivities
        .where((a) => a.status == LoginStatus.current)
        .length;
    final totalSessions = filteredActivities.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AdminTheme.primaryPurple, Color(0xFF9C7FD9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Active Sessions',
                  '$currentSessions',
                  Icons.devices,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Total Logins',
                  '$totalSessions',
                  Icons.login,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Last Login',
                  _getLastLoginTime(),
                  Icons.access_time,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Security Score',
                  '94%',
                  Icons.shield,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
                backgroundColor: themeProvider.surfaceColor,
                selectedColor: AdminTheme.primaryPurple.withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  color: isSelected
                      ? AdminTheme.primaryPurple
                      : themeProvider.textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected
                      ? AdminTheme.primaryPurple
                      : themeProvider.borderColor,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLoginList(ThemeProvider themeProvider) {
    final filteredActivities = _getFilteredActivities();

    if (filteredActivities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: themeProvider.subtitleColor),
            const SizedBox(height: 16),
            Text(
              'No login activity found',
              style: TextStyle(
                color: themeProvider.subtitleColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredActivities.length,
      itemBuilder: (context, index) {
        final activity = filteredActivities[index];
        return _buildLoginItem(activity, themeProvider);
      },
    );
  }

  Widget _buildLoginItem(LoginActivity activity, ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: themeProvider.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showLoginDetails(activity),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStatusIcon(activity.status),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              activity.device,
                              style: TextStyle(
                                color: themeProvider.textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (activity.status == LoginStatus.current)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Current',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${activity.location} • ${_formatTime(activity.time)}',
                        style: TextStyle(
                          color: themeProvider.subtitleColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${activity.browser} • ${activity.os}',
                        style: TextStyle(
                          color: themeProvider.subtitleColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: themeProvider.subtitleColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(LoginStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case LoginStatus.current:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case LoginStatus.success:
        icon = Icons.check;
        color = Colors.blue;
        break;
      case LoginStatus.failed:
        icon = Icons.error;
        color = Colors.orange;
        break;
      case LoginStatus.blocked:
        icon = Icons.block;
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  List<LoginActivity> _getFilteredActivities() {
    switch (selectedFilter) {
      case 'Current Session':
        return loginActivities
            .where((a) => a.status == LoginStatus.current)
            .toList();
      case 'Successful':
        return loginActivities
            .where((a) => a.status == LoginStatus.success)
            .toList();
      case 'Failed':
        return loginActivities
            .where((a) => a.status == LoginStatus.failed)
            .toList();
      case 'Blocked':
        return loginActivities
            .where((a) => a.status == LoginStatus.blocked)
            .toList();
      default:
        return loginActivities;
    }
  }

  String _getLastLoginTime() {
    if (loginActivities.isEmpty) return 'Never';
    final lastLogin = loginActivities.first.time;
    final now = DateTime.now();
    final difference = now.difference(lastLogin);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  }

  void _showLoginDetails(LoginActivity activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: themeProvider.surfaceColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: themeProvider.subtitleColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildStatusIcon(activity.status),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Login Details',
                                style: TextStyle(
                                  color: themeProvider.textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildDetailItem(
                          'Device',
                          activity.device,
                          Icons.devices,
                          themeProvider,
                        ),
                        _buildDetailItem(
                          'Location',
                          activity.location,
                          Icons.location_on,
                          themeProvider,
                        ),
                        _buildDetailItem(
                          'IP Address',
                          activity.ipAddress,
                          Icons.language,
                          themeProvider,
                        ),
                        _buildDetailItem(
                          'Browser',
                          activity.browser,
                          Icons.web,
                          themeProvider,
                        ),
                        _buildDetailItem(
                          'Operating System',
                          activity.os,
                          Icons.computer,
                          themeProvider,
                        ),
                        _buildDetailItem(
                          'Time',
                          _formatTime(activity.time),
                          Icons.access_time,
                          themeProvider,
                        ),
                        _buildDetailItem(
                          'Status',
                          _getStatusText(activity.status),
                          Icons.info,
                          themeProvider,
                        ),
                        const SizedBox(height: 24),
                        if (activity.status == LoginStatus.blocked ||
                            activity.status == LoginStatus.failed)
                          _buildActionButtons(activity, themeProvider),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value,
    IconData icon,
    ThemeProvider themeProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
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
                  label,
                  style: TextStyle(
                    color: themeProvider.subtitleColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: themeProvider.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    LoginActivity activity,
    ThemeProvider themeProvider,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _blockDevice(activity),
            icon: const Icon(Icons.block, size: 18),
            label: const Text('Block This Device'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _reportSuspicious(activity),
            icon: const Icon(Icons.report, size: 18),
            label: const Text('Report Suspicious Activity'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange,
              side: const BorderSide(color: Colors.orange),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  String _getStatusText(LoginStatus status) {
    switch (status) {
      case LoginStatus.current:
        return 'Current Session';
      case LoginStatus.success:
        return 'Successful Login';
      case LoginStatus.failed:
        return 'Failed Login Attempt';
      case LoginStatus.blocked:
        return 'Blocked Login Attempt';
    }
  }

  void _blockDevice(LoginActivity activity) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Device ${activity.device} has been blocked'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _reportSuspicious(LoginActivity activity) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Suspicious activity reported for ${activity.device}'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showSecurityTips() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Row(
                children: [
                  Icon(Icons.security, color: AdminTheme.primaryPurple),
                  const SizedBox(width: 8),
                  Text(
                    'Security Tips',
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
                    _buildSecurityTip(
                      'Review login activity regularly',
                      Icons.visibility,
                    ),
                    _buildSecurityTip(
                      'Enable two-factor authentication',
                      Icons.security,
                    ),
                    _buildSecurityTip(
                      'Use strong, unique passwords',
                      Icons.lock,
                    ),
                    _buildSecurityTip(
                      'Log out from unused devices',
                      Icons.logout,
                    ),
                    _buildSecurityTip(
                      'Report suspicious activity immediately',
                      Icons.report,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Got it',
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

  Widget _buildSecurityTip(String tip, IconData icon) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(icon, color: AdminTheme.primaryPurple, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tip,
                  style: TextStyle(
                    color: themeProvider.textColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Models
class LoginActivity {
  final String device;
  final String location;
  final String ipAddress;
  final DateTime time;
  final LoginStatus status;
  final String browser;
  final String os;

  LoginActivity({
    required this.device,
    required this.location,
    required this.ipAddress,
    required this.time,
    required this.status,
    required this.browser,
    required this.os,
  });
}

enum LoginStatus { current, success, failed, blocked }
