import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../theme/theme_provider.dart';
import 'services/responsive_service.dart';

class LoginHistoryPage extends StatefulWidget {
  const LoginHistoryPage({super.key});

  @override
  State<LoginHistoryPage> createState() => _LoginHistoryPageState();
}

class _LoginHistoryPageState extends State<LoginHistoryPage> {
  String selectedFilter = 'All';
  String selectedTimeRange = 'Last 30 days';

  final List<String> filterOptions = [
    'All',
    'Success',
    'Failed',
    'Blocked',
    'Current',
  ];
  final List<String> timeRangeOptions = [
    'Last 7 days',
    'Last 30 days',
    'Last 3 months',
    'Last 6 months',
    'Last year',
  ];

  List<Map<String, dynamic>> loginHistory = [
    {
      'device': 'iPhone 14 Pro',
      'browser': 'Safari 17.0',
      'location': 'New York, NY, USA',
      'ip': '192.168.1.100',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'current',
      'sessionDuration': '2h 15m',
    },
    {
      'device': 'MacBook Pro',
      'browser': 'Chrome 119.0',
      'location': 'New York, NY, USA',
      'ip': '192.168.1.101',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'success',
      'sessionDuration': '4h 32m',
    },
    {
      'device': 'Windows PC',
      'browser': 'Edge 119.0',
      'location': 'Los Angeles, CA, USA',
      'ip': '10.0.0.50',
      'time': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'success',
      'sessionDuration': '1h 45m',
    },
    {
      'device': 'Android Phone',
      'browser': 'Chrome Mobile',
      'location': 'Chicago, IL, USA',
      'ip': '172.16.0.25',
      'time': DateTime.now().subtract(const Duration(days: 5)),
      'status': 'failed',
      'sessionDuration': '0m',
    },
    {
      'device': 'Unknown Device',
      'browser': 'Unknown Browser',
      'location': 'Miami, FL, USA',
      'ip': '203.0.113.45',
      'time': DateTime.now().subtract(const Duration(days: 7)),
      'status': 'blocked',
      'sessionDuration': '0m',
    },
    {
      'device': 'iPad Air',
      'browser': 'Safari Mobile',
      'location': 'Seattle, WA, USA',
      'ip': '198.51.100.30',
      'time': DateTime.now().subtract(const Duration(days: 10)),
      'status': 'success',
      'sessionDuration': '2h 20m',
    },
    {
      'device': 'Linux Desktop',
      'browser': 'Firefox 119.0',
      'location': 'Austin, TX, USA',
      'ip': '203.0.113.78',
      'time': DateTime.now().subtract(const Duration(days: 15)),
      'status': 'success',
      'sessionDuration': '3h 10m',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          appBar: ResponsiveService.responsiveAppBar(
            context,
            title: 'Login History',
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.download, color: Colors.white),
                onPressed: _exportLoginHistory,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _refreshHistory,
              ),
            ],
          ),
          body: ResponsiveService.responsiveLayout(
            context,
            mobile: _buildMobileLayout(themeProvider),
            tablet: _buildTabletLayout(themeProvider),
            desktop: _buildDesktopLayout(themeProvider),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(ThemeProvider themeProvider) {
    return Column(
      children: [
        _buildFilters(themeProvider),
        Expanded(child: _buildLoginList(themeProvider)),
      ],
    );
  }

  Widget _buildTabletLayout(ThemeProvider themeProvider) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: Column(
            children: [
              _buildFilters(themeProvider),
              _buildSecurityInsights(themeProvider),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(child: _buildLoginList(themeProvider)),
      ],
    );
  }

  Widget _buildDesktopLayout(ThemeProvider themeProvider) {
    return Row(
      children: [
        SizedBox(
          width: 350,
          child: Column(
            children: [
              _buildFilters(themeProvider),
              _buildSecurityInsights(themeProvider),
              _buildQuickActions(themeProvider),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(child: _buildLoginList(themeProvider)),
      ],
    );
  }

  Widget _buildFilters(ThemeProvider themeProvider) {
    return ResponsiveService.responsiveCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: TextStyle(
              color: themeProvider.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildFilterDropdown(
            'Status',
            selectedFilter,
            filterOptions,
            (value) => setState(() => selectedFilter = value!),
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildFilterDropdown(
            'Time Range',
            selectedTimeRange,
            timeRangeOptions,
            (value) => setState(() => selectedTimeRange = value!),
            themeProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
    ThemeProvider themeProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: themeProvider.subtitleColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: themeProvider.borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            isExpanded: true,
            underline: Container(),
            dropdownColor: themeProvider.surfaceColor,
            style: TextStyle(color: themeProvider.textColor),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityInsights(ThemeProvider themeProvider) {
    final filteredHistory = _getFilteredHistory();
    final successCount = filteredHistory
        .where((h) => h['status'] == 'success')
        .length;
    final failedCount = filteredHistory
        .where((h) => h['status'] == 'failed')
        .length;
    final blockedCount = filteredHistory
        .where((h) => h['status'] == 'blocked')
        .length;

    return ResponsiveService.responsiveCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Insights',
            style: TextStyle(
              color: themeProvider.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            'Successful Logins',
            successCount.toString(),
            Icons.check_circle,
            Colors.green,
            themeProvider,
          ),
          _buildInsightItem(
            'Failed Attempts',
            failedCount.toString(),
            Icons.error,
            Colors.red,
            themeProvider,
          ),
          _buildInsightItem(
            'Blocked Attempts',
            blockedCount.toString(),
            Icons.block,
            Colors.orange,
            themeProvider,
          ),
          _buildInsightItem(
            'Unique Locations',
            _getUniqueLocations().toString(),
            Icons.location_on,
            Colors.blue,
            themeProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeProvider themeProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                  value,
                  style: TextStyle(
                    color: themeProvider.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: themeProvider.subtitleColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeProvider themeProvider) {
    return ResponsiveService.responsiveCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              color: themeProvider.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            'Sign Out All Devices',
            Icons.logout,
            Colors.orange,
            _signOutAllDevices,
            themeProvider,
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            'Block Suspicious IPs',
            Icons.block,
            Colors.red,
            _blockSuspiciousIPs,
            themeProvider,
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            'Enable 2FA',
            Icons.security,
            Colors.green,
            _enable2FA,
            themeProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    ThemeProvider themeProvider,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
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
          ],
        ),
      ),
    );
  }

  Widget _buildLoginList(ThemeProvider themeProvider) {
    final filteredHistory = _getFilteredHistory();

    return Container(
      padding: ResponsiveService.responsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Login Activity (${filteredHistory.length})',
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (ResponsiveService.isDesktop(context))
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.view_list,
                        color: themeProvider.subtitleColor,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.view_module,
                        color: themeProvider.subtitleColor,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHistory.length,
              itemBuilder: (context, index) {
                return _buildLoginHistoryCard(
                  filteredHistory[index],
                  themeProvider,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginHistoryCard(
    Map<String, dynamic> login,
    ThemeProvider themeProvider,
  ) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (login['status']) {
      case 'current':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Current Session';
        break;
      case 'success':
        statusColor = Colors.blue;
        statusIcon = Icons.check;
        statusText = 'Successful';
        break;
      case 'failed':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        statusText = 'Failed';
        break;
      case 'blocked':
        statusColor = Colors.orange;
        statusIcon = Icons.block;
        statusText = 'Blocked';
        break;
      default:
        statusColor = themeProvider.subtitleColor;
        statusIcon = Icons.help;
        statusText = 'Unknown';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: themeProvider.surfaceColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ResponsiveService.responsiveRowColumn(
          context,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(statusIcon, color: statusColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              login['device'],
                              style: TextStyle(
                                color: themeProvider.textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              login['browser'],
                              style: TextStyle(
                                color: themeProvider.subtitleColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ResponsiveService.responsiveWrap(
                    context,
                    children: [
                      _buildInfoChip(
                        Icons.location_on,
                        login['location'],
                        themeProvider,
                      ),
                      _buildInfoChip(
                        Icons.access_time,
                        _formatDateTime(login['time']),
                        themeProvider,
                      ),
                      _buildInfoChip(
                        Icons.timer,
                        login['sessionDuration'],
                        themeProvider,
                      ),
                      _buildInfoChip(
                        Icons.computer,
                        login['ip'],
                        themeProvider,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (ResponsiveService.isDesktop(context))
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: themeProvider.subtitleColor),
                color: themeProvider.surfaceColor,
                onSelected: (value) => _handleLoginAction(value, login),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'details',
                    child: Row(
                      children: [
                        Icon(Icons.info, size: 16),
                        SizedBox(width: 8),
                        Text('View Details'),
                      ],
                    ),
                  ),
                  if (login['status'] != 'current')
                    const PopupMenuItem(
                      value: 'block_ip',
                      child: Row(
                        children: [
                          Icon(Icons.block, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Block IP'),
                        ],
                      ),
                    ),
                  if (login['status'] == 'current')
                    const PopupMenuItem(
                      value: 'sign_out',
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: 16, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Sign Out'),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    IconData icon,
    String text,
    ThemeProvider themeProvider,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: themeProvider.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: themeProvider.subtitleColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: themeProvider.subtitleColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredHistory() {
    return loginHistory.where((login) {
      if (selectedFilter != 'All' &&
          login['status'] != selectedFilter.toLowerCase()) {
        return false;
      }
      // Add time range filtering logic here
      return true;
    }).toList();
  }

  int _getUniqueLocations() {
    return loginHistory.map((h) => h['location']).toSet().length;
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  void _handleLoginAction(String action, Map<String, dynamic> login) {
    switch (action) {
      case 'details':
        _showLoginDetails(login);
        break;
      case 'block_ip':
        _blockIP(login['ip']);
        break;
      case 'sign_out':
        _signOutSession(login);
        break;
    }
  }

  void _showLoginDetails(Map<String, dynamic> login) {
    showDialog(
      context: context,
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return AlertDialog(
            backgroundColor: themeProvider.surfaceColor,
            title: Text(
              'Login Details',
              style: TextStyle(color: themeProvider.textColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Device', login['device'], themeProvider),
                _buildDetailRow('Browser', login['browser'], themeProvider),
                _buildDetailRow('Location', login['location'], themeProvider),
                _buildDetailRow('IP Address', login['ip'], themeProvider),
                _buildDetailRow(
                  'Time',
                  login['time'].toString(),
                  themeProvider,
                ),
                _buildDetailRow(
                  'Duration',
                  login['sessionDuration'],
                  themeProvider,
                ),
                _buildDetailRow('Status', login['status'], themeProvider),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(color: AdminTheme.primaryPurple),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    ThemeProvider themeProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                color: themeProvider.subtitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: themeProvider.textColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _exportLoginHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting login history...'),
        backgroundColor: AdminTheme.primaryPurple,
      ),
    );
  }

  void _refreshHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshing login history...'),
        backgroundColor: AdminTheme.primaryPurple,
      ),
    );
  }

  void _signOutAllDevices() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signing out all devices...'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _blockSuspiciousIPs() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Blocking suspicious IP addresses...'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _enable2FA() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Redirecting to 2FA setup...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _blockIP(String ip) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Blocked IP address: $ip'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _signOutSession(Map<String, dynamic> login) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signed out session on ${login['device']}'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
