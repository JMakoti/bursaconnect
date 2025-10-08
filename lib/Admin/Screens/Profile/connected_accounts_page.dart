import 'package:flutter/material.dart';

class ConnectedAccountsPage extends StatefulWidget {
  const ConnectedAccountsPage({super.key});

  @override
  State<ConnectedAccountsPage> createState() => _ConnectedAccountsPageState();
}

class _ConnectedAccountsPageState extends State<ConnectedAccountsPage> {
  // Mock data for connected accounts
  List<ConnectedAccount> connectedAccounts = [
    ConnectedAccount(
      name: 'Google',
      email: 'sarah.johnson@gmail.com',
      icon: Icons.g_mobiledata,
      isConnected: true,
      color: Colors.red,
    ),
    ConnectedAccount(
      name: 'Facebook',
      email: 'sarah.johnson@facebook.com',
      icon: Icons.facebook,
      isConnected: true,
      color: Colors.blue,
    ),
    ConnectedAccount(
      name: 'Twitter',
      email: 'Not connected',
      icon: Icons.alternate_email,
      isConnected: false,
      color: Colors.lightBlue,
    ),
    ConnectedAccount(
      name: 'LinkedIn',
      email: 'sarah.johnson@linkedin.com',
      icon: Icons.business,
      isConnected: true,
      color: Colors.indigo,
    ),
    ConnectedAccount(
      name: 'GitHub',
      email: 'Not connected',
      icon: Icons.code,
      isConnected: false,
      color: Colors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB19CD9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Connected Accounts',
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
            const Text(
              'Manage your connected accounts',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Connected Accounts List
            ...connectedAccounts.map((account) => _buildAccountCard(account)),

            const SizedBox(height: 32),

            // Add Account Button
            _buildAddAccountButton(),

            const SizedBox(height: 100), // Extra padding for scrolling
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(ConnectedAccount account) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF404040), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: account.isConnected ? null : () => _connectAccount(account),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive layout based on available width
                if (constraints.maxWidth < 300) {
                  // Narrow layout - stack vertically
                  return Column(
                    children: [
                      Row(
                        children: [
                          _buildAccountIcon(account),
                          const SizedBox(width: 16),
                          Expanded(child: _buildAccountInfo(account)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildActionButton(account),
                    ],
                  );
                } else {
                  // Wide layout - horizontal
                  return Row(
                    children: [
                      _buildAccountIcon(account),
                      const SizedBox(width: 16),
                      Expanded(child: _buildAccountInfo(account)),
                      const SizedBox(width: 16),
                      _buildActionButton(account),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountIcon(ConnectedAccount account) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: account.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(account.icon, color: account.color, size: 24),
    );
  }

  Widget _buildAccountInfo(ConnectedAccount account) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          account.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          account.email,
          style: TextStyle(
            color: account.isConnected ? Colors.grey : Colors.orange,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        if (account.isConnected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Connected',
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton(ConnectedAccount account) {
    if (account.isConnected) {
      return PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Colors.grey),
        color: const Color(0xFF2A2A2A),
        onSelected: (value) {
          if (value == 'disconnect') {
            _showDisconnectDialog(account);
          } else if (value == 'refresh') {
            _refreshConnection(account);
          }
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<String>(
            value: 'refresh',
            child: Row(
              children: [
                Icon(Icons.refresh, color: Color(0xFF8B5CF6), size: 20),
                SizedBox(width: 12),
                Text('Refresh', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'disconnect',
            child: Row(
              children: [
                Icon(Icons.link_off, color: Colors.red, size: 20),
                SizedBox(width: 12),
                Text('Disconnect', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      );
    } else {
      return ElevatedButton(
        onPressed: () => _connectAccount(account),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B5CF6),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Connect',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );
    }
  }

  Widget _buildAddAccountButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8B5CF6), width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _showAddAccountDialog,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Color(0xFF8B5CF6)),
                SizedBox(width: 12),
                Text(
                  'Add New Account',
                  style: TextStyle(
                    color: Color(0xFF8B5CF6),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _connectAccount(ConnectedAccount account) {
    // Simulate connection process
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.of(context).pop(); // Close loading dialog

      setState(() {
        account.isConnected = true;
        account.email = 'sarah.johnson@${account.name.toLowerCase()}.com';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${account.name} connected successfully'),
          backgroundColor: const Color(0xFF8B5CF6),
        ),
      );
    });
  }

  void _showDisconnectDialog(ConnectedAccount account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: Text(
            'Disconnect ${account.name}',
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to disconnect your ${account.name} account? You can reconnect it anytime.',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _disconnectAccount(account);
              },
              child: const Text(
                'Disconnect',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _disconnectAccount(ConnectedAccount account) {
    setState(() {
      account.isConnected = false;
      account.email = 'Not connected';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${account.name} disconnected'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _refreshConnection(ConnectedAccount account) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${account.name} connection refreshed'),
        backgroundColor: const Color(0xFF8B5CF6),
      ),
    );
  }

  void _showAddAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: const Text(
            'Add New Account',
            style: TextStyle(color: Colors.white),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Connect additional social media or service accounts to enhance your profile.',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Available integrations:',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                '• Microsoft\n• Apple ID\n• Discord\n• Slack\n• Dropbox',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Feature coming soon!'),
                    backgroundColor: Color(0xFF8B5CF6),
                  ),
                );
              },
              child: const Text(
                'Request Integration',
                style: TextStyle(color: Color(0xFF8B5CF6)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ConnectedAccount {
  final String name;
  String email;
  final IconData icon;
  bool isConnected;
  final Color color;

  ConnectedAccount({
    required this.name,
    required this.email,
    required this.icon,
    required this.isConnected,
    required this.color,
  });
}
