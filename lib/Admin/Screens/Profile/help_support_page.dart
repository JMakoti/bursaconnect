import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../theme/theme_provider.dart';
import 'services/animation_service.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final TextEditingController _messageController = TextEditingController();
  String selectedCategory = 'General';

  final List<String> categories = [
    'General',
    'Account Issues',
    'Technical Support',
    'Billing',
    'Feature Request',
    'Bug Report',
  ];

  final List<FAQItem> faqItems = [
    FAQItem(
      question: 'How do I change my password?',
      answer:
          'Go to Settings > Account Settings > Change Password. Enter your current password and your new password.',
      category: 'Account Issues',
    ),
    FAQItem(
      question: 'How do I enable two-factor authentication?',
      answer:
          'Navigate to Settings > Security Settings > Two-Factor Authentication and toggle it on. Follow the setup instructions.',
      category: 'Account Issues',
    ),
    FAQItem(
      question: 'How do I change my profile picture?',
      answer:
          'Go to your profile, tap Edit Profile, then tap the camera icon on your profile picture to take a new photo or choose from gallery.',
      category: 'General',
    ),
    FAQItem(
      question: 'How do I manage notification preferences?',
      answer:
          'Go to Settings > Other Preferences > Notification Preferences to customize which notifications you receive.',
      category: 'General',
    ),
    FAQItem(
      question: 'How do I connect social media accounts?',
      answer:
          'Navigate to Settings > Account Settings > Connected Accounts and tap Connect next to the account you want to link.',
      category: 'Account Issues',
    ),
    FAQItem(
      question: 'The app is running slowly, what should I do?',
      answer:
          'Try closing and reopening the app. If the issue persists, restart your device or contact support.',
      category: 'Technical Support',
    ),
    FAQItem(
      question: 'How do I delete my account?',
      answer:
          'Go to Settings > Account Settings > Delete Account. Note: This action cannot be undone.',
      category: 'Account Issues',
    ),
    FAQItem(
      question: 'How do I change the app theme?',
      answer:
          'Go to Settings > Appearance and select your preferred theme: Light, Dark, or System.',
      category: 'General',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
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
              'Help & Support',
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
              children: AnimationService.staggeredList(
                children: [
                  // Quick Actions Section
                  _buildSectionTitle('Quick Actions'),
                  const SizedBox(height: 12),
                  _buildQuickActionsCard(),

                  const SizedBox(height: 24),

                  // FAQ Section
                  _buildSectionTitle('Frequently Asked Questions'),
                  const SizedBox(height: 12),
                  _buildFAQSection(),

                  const SizedBox(height: 24),

                  // Contact Support Section
                  _buildSectionTitle('Contact Support'),
                  const SizedBox(height: 12),
                  _buildContactSupportCard(),

                  const SizedBox(height: 100),
                ],
                staggerDelay: const Duration(milliseconds: 50),
              ),
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

  Widget _buildQuickActionsCard() {
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
              _buildQuickActionItem(
                icon: Icons.help_outline,
                title: 'User Guide',
                subtitle: 'Learn how to use the app',
                onTap: () => _showUserGuide(),
              ),
              _buildDivider(),
              _buildQuickActionItem(
                icon: Icons.video_library,
                title: 'Video Tutorials',
                subtitle: 'Watch step-by-step guides',
                onTap: () => _showVideoTutorials(),
              ),
              _buildDivider(),
              _buildQuickActionItem(
                icon: Icons.bug_report,
                title: 'Report a Bug',
                subtitle: 'Help us improve the app',
                onTap: () => _showBugReportDialog(),
              ),
              _buildDivider(),
              _buildQuickActionItem(
                icon: Icons.feedback,
                title: 'Send Feedback',
                subtitle: 'Share your thoughts',
                onTap: () => _showFeedbackDialog(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFAQSection() {
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
              // Category Filter
              Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      final isSelected = selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          selectedColor: AdminTheme.primaryPurple.withValues(
                            alpha: 0.2,
                          ),
                          checkmarkColor: AdminTheme.primaryPurple,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AdminTheme.primaryPurple
                                : themeProvider.textColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // FAQ Items
              ...faqItems
                  .where(
                    (item) =>
                        selectedCategory == 'General' ||
                        item.category == selectedCategory,
                  )
                  .map((item) => _buildFAQItem(item)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactSupportCard() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: themeProvider.borderColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need more help?',
                  style: TextStyle(
                    color: themeProvider.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Our support team is here to help you',
                  style: TextStyle(
                    color: themeProvider.subtitleColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),

                // Contact Methods
                Row(
                  children: [
                    Expanded(
                      child: _buildContactMethod(
                        icon: Icons.email,
                        title: 'Email',
                        subtitle: 'support@yourapp.com',
                        onTap: () => _contactViaEmail(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildContactMethod(
                        icon: Icons.chat,
                        title: 'Live Chat',
                        subtitle: 'Available 24/7',
                        onTap: () => _startLiveChat(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Message Form
                Text(
                  'Send us a message',
                  style: TextStyle(
                    color: themeProvider.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: themeProvider.subtitleColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: themeProvider.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: themeProvider.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AdminTheme.primaryPurple,
                      ),
                    ),
                  ),
                  dropdownColor: themeProvider.surfaceColor,
                  style: TextStyle(color: themeProvider.textColor),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Message TextField
                TextFormField(
                  controller: _messageController,
                  maxLines: 4,
                  style: TextStyle(color: themeProvider.textColor),
                  decoration: InputDecoration(
                    labelText: 'Describe your issue',
                    labelStyle: TextStyle(color: themeProvider.subtitleColor),
                    hintText: 'Please provide as much detail as possible...',
                    hintStyle: TextStyle(
                      color: themeProvider.subtitleColor.withValues(alpha: 0.7),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: themeProvider.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: themeProvider.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AdminTheme.primaryPurple,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Send Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _sendSupportMessage,
                    icon: const Icon(Icons.send),
                    label: const Text('Send Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminTheme.primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
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

  Widget _buildFAQItem(FAQItem item) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ExpansionTile(
          title: Text(
            item.question,
            style: TextStyle(
              color: themeProvider.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconColor: AdminTheme.primaryPurple,
          collapsedIconColor: themeProvider.subtitleColor,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                item.answer,
                style: TextStyle(
                  color: themeProvider.subtitleColor,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeProvider.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: themeProvider.borderColor),
            ),
            child: Column(
              children: [
                Icon(icon, color: AdminTheme.primaryPurple, size: 32),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: themeProvider.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: themeProvider.subtitleColor,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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

  // Action Methods
  void _showUserGuide() {
    showDialog(
      context: context,
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return AlertDialog(
            backgroundColor: themeProvider.surfaceColor,
            title: Text(
              'User Guide',
              style: TextStyle(color: themeProvider.textColor),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome to the Admin Dashboard!',
                    style: TextStyle(
                      color: themeProvider.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '1. Profile Management: Edit your personal information, change your profile picture, and manage account settings.\n\n'
                    '2. Security: Enable two-factor authentication, manage connected accounts, and review login history.\n\n'
                    '3. Preferences: Customize your theme, language, and notification settings.\n\n'
                    '4. Support: Access help resources and contact our support team.',
                    style: TextStyle(
                      color: themeProvider.subtitleColor,
                      height: 1.5,
                    ),
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
      ),
    );
  }

  void _showVideoTutorials() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video tutorials feature coming soon!'),
        backgroundColor: AdminTheme.primaryPurple,
      ),
    );
  }

  void _showBugReportDialog() {
    showDialog(
      context: context,
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return AlertDialog(
            backgroundColor: themeProvider.surfaceColor,
            title: Text(
              'Report a Bug',
              style: TextStyle(color: themeProvider.textColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Help us improve by reporting bugs you encounter.',
                  style: TextStyle(color: themeProvider.textColor),
                ),
                const SizedBox(height: 16),
                TextField(
                  maxLines: 3,
                  style: TextStyle(color: themeProvider.textColor),
                  decoration: InputDecoration(
                    hintText: 'Describe the bug...',
                    hintStyle: TextStyle(color: themeProvider.subtitleColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
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
                      content: Text('Bug report submitted. Thank you!'),
                      backgroundColor: AdminTheme.primaryPurple,
                    ),
                  );
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: AdminTheme.primaryPurple),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return AlertDialog(
            backgroundColor: themeProvider.surfaceColor,
            title: Text(
              'Send Feedback',
              style: TextStyle(color: themeProvider.textColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'We value your feedback! Let us know how we can improve.',
                  style: TextStyle(color: themeProvider.textColor),
                ),
                const SizedBox(height: 16),
                TextField(
                  maxLines: 3,
                  style: TextStyle(color: themeProvider.textColor),
                  decoration: InputDecoration(
                    hintText: 'Your feedback...',
                    hintStyle: TextStyle(color: themeProvider.subtitleColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
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
                      content: Text('Feedback submitted. Thank you!'),
                      backgroundColor: AdminTheme.primaryPurple,
                    ),
                  );
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: AdminTheme.primaryPurple),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _contactViaEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening email client...'),
        backgroundColor: AdminTheme.primaryPurple,
      ),
    );
  }

  void _startLiveChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Live chat feature coming soon!'),
        backgroundColor: AdminTheme.primaryPurple,
      ),
    );
  }

  void _sendSupportMessage() {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a message'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Simulate sending message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Support message sent successfully!'),
        backgroundColor: AdminTheme.primaryPurple,
      ),
    );

    _messageController.clear();
  }
}

// FAQ Item Model
class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}
