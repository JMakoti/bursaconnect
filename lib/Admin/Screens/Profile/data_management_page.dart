import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../theme/theme_provider.dart';

class DataManagementPage extends StatefulWidget {
  const DataManagementPage({super.key});

  @override
  State<DataManagementPage> createState() => _DataManagementPageState();
}

class _DataManagementPageState extends State<DataManagementPage> {
  bool _isLoading = false;
  DateTime? _lastBackup;
  final String _dataSize = '2.4 MB';

  @override
  void initState() {
    super.initState();
    _lastBackup = DateTime.now().subtract(const Duration(days: 3));
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
              'Data Management',
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
                _buildDataOverview(themeProvider),
                const SizedBox(height: 24),
                _buildBackupSection(themeProvider),
                const SizedBox(height: 24),
                _buildExportSection(themeProvider),
                const SizedBox(height: 24),
                _buildDataCleanup(themeProvider),
                const SizedBox(height: 24),
                _buildPrivacyControls(themeProvider),
                const SizedBox(height: 24),
                _buildDangerZone(themeProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataOverview(ThemeProvider themeProvider) {
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
                child: Icon(
                  Icons.storage,
                  color: AdminTheme.primaryPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Data Overview',
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDataMetric(
                  'Total Size',
                  _dataSize,
                  Icons.folder,
                  Colors.blue,
                  themeProvider,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDataMetric(
                  'Files',
                  '1,247',
                  Icons.description,
                  Colors.green,
                  themeProvider,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDataMetric(
                  'Images',
                  '89',
                  Icons.image,
                  Colors.orange,
                  themeProvider,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDataMetric(
                  'Settings',
                  '23',
                  Icons.settings,
                  Colors.purple,
                  themeProvider,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataMetric(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeProvider themeProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeProvider.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: themeProvider.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(color: themeProvider.subtitleColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupSection(ThemeProvider themeProvider) {
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
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.backup, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Backup & Restore',
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_lastBackup != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Last backup: ${_formatDate(_lastBackup!)}',
                    style: TextStyle(
                      color: themeProvider.textColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _createBackup,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.backup, size: 18),
                  label: Text(_isLoading ? 'Creating...' : 'Create Backup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminTheme.primaryPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _restoreBackup,
                  icon: const Icon(Icons.restore, size: 18),
                  label: const Text('Restore'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AdminTheme.primaryPurple,
                    side: const BorderSide(color: AdminTheme.primaryPurple),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExportSection(ThemeProvider themeProvider) {
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
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.download, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Export Data',
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Download your data in various formats for external use or migration.',
            style: TextStyle(color: themeProvider.subtitleColor, fontSize: 14),
          ),
          const SizedBox(height: 16),
          _buildExportOption(
            'Profile Data (JSON)',
            'Personal information and settings',
            Icons.person,
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildExportOption(
            'Activity History (CSV)',
            'Login history and usage statistics',
            Icons.history,
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildExportOption(
            'Media Files (ZIP)',
            'Profile pictures and uploaded files',
            Icons.folder_zip,
            themeProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildExportOption(
    String title,
    String description,
    IconData icon,
    ThemeProvider themeProvider,
  ) {
    return InkWell(
      onTap: () => _exportData(title),
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
            Icon(icon, color: AdminTheme.primaryPurple, size: 20),
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
            Icon(Icons.download, color: themeProvider.subtitleColor, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCleanup(ThemeProvider themeProvider) {
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
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.cleaning_services,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Data Cleanup',
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCleanupOption(
            'Clear Cache',
            'Remove temporary files (124 KB)',
            Icons.cached,
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildCleanupOption(
            'Delete Old Logs',
            'Remove logs older than 30 days (45 KB)',
            Icons.delete_sweep,
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildCleanupOption(
            'Compress Images',
            'Optimize image files (Save ~500 KB)',
            Icons.compress,
            themeProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildCleanupOption(
    String title,
    String description,
    IconData icon,
    ThemeProvider themeProvider,
  ) {
    return InkWell(
      onTap: () => _performCleanup(title),
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
            Icon(icon, color: Colors.orange, size: 20),
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
      ),
    );
  }

  Widget _buildPrivacyControls(ThemeProvider themeProvider) {
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
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.privacy_tip,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Privacy Controls',
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPrivacyOption(
            'Data Portability Request',
            'Request a copy of all your data',
            Icons.file_download,
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildPrivacyOption(
            'Data Correction',
            'Request correction of inaccurate data',
            Icons.edit,
            themeProvider,
          ),
          const SizedBox(height: 12),
          _buildPrivacyOption(
            'Data Retention Settings',
            'Manage how long data is stored',
            Icons.schedule,
            themeProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyOption(
    String title,
    String description,
    IconData icon,
    ThemeProvider themeProvider,
  ) {
    return InkWell(
      onTap: () => _handlePrivacyAction(title),
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
            Icon(icon, color: Colors.purple, size: 20),
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
      ),
    );
  }

  Widget _buildDangerZone(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.warning, color: Colors.red, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Danger Zone',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'These actions are irreversible. Please proceed with caution.',
            style: TextStyle(color: themeProvider.subtitleColor, fontSize: 14),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _deleteAllData,
              icon: const Icon(Icons.delete_forever, size: 18),
              label: const Text('Delete All Data'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _createBackup() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate backup process
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _lastBackup = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Backup created successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _restoreBackup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Text(
                'Restore Backup',
                style: TextStyle(color: themeProvider.textColor),
              ),
              content: Text(
                'This will restore your data from the last backup. Current data will be overwritten.',
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
                        content: Text('Backup restored successfully'),
                        backgroundColor: AdminTheme.primaryPurple,
                      ),
                    );
                  },
                  child: const Text(
                    'Restore',
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

  void _exportData(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type export started'),
        backgroundColor: AdminTheme.primaryPurple,
      ),
    );
  }

  void _performCleanup(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type completed'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handlePrivacyAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action request submitted'),
        backgroundColor: Colors.purple,
      ),
    );
  }

  void _deleteAllData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: const Text(
                'Delete All Data',
                style: TextStyle(color: Colors.red),
              ),
              content: Text(
                'This action cannot be undone. All your data will be permanently deleted.',
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
                        content: Text('Data deletion cancelled'),
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
}
