import 'package:flutter/material.dart';
import '../themes/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B6B9E).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.settings_rounded,
                      color: Color(0xFF5B6B9E),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Manage your preferences',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Settings List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSectionHeader('Account'),
                  _buildSettingItem(
                    icon: Icons.person_outline,
                    title: 'Profile Settings',
                    subtitle: 'Update your personal information',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage notification preferences',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.security_outlined,
                    title: 'Privacy & Security',
                    subtitle: 'Control your privacy settings',
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader('App Settings'),
                  _buildSettingItem(
                    icon: Icons.storage_outlined,
                    title: 'Data & Storage',
                    subtitle: 'Manage app data and cache',
                    trailing: const Text(
                      '124 MB',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.devices_outlined,
                    title: 'Connected Devices',
                    subtitle: 'Manage linked devices',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.battery_saver_outlined,
                    title: 'Power Saving',
                    subtitle: 'Optimize battery usage',
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                      activeThumbColor: AppColors.redButton,
                    ),
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.language_outlined,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader('Support'),
                  _buildSettingItem(
                    icon: Icons.help_outline,
                    title: 'FAQ',
                    subtitle: 'Frequently asked questions',
                    onTap: () {
                      _showFAQBottomSheet(context);
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.question_answer_outlined,
                    title: 'Ask a Question',
                    subtitle: 'Get help from our support team',
                    onTap: () {
                      _showAskQuestionDialog(context);
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'Version 1.0.0',
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader('Legal'),
                  _buildSettingItem(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    subtitle: 'Read our terms',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'How we handle your data',
                    onTap: () {},
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B6B9E).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFF5B6B9E), size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade400,
                      size: 24,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFAQBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFAQItem(
                    'How do I reserve a parking spot?',
                    'Navigate to the Parking tab, select your desired location, choose an available slot, and complete the booking process.',
                  ),
                  _buildFAQItem(
                    'What payment methods are accepted?',
                    'We accept MTN Mobile Money, Airtel Money, Africell Money, M-Cash, and cash payments at the parking location.',
                  ),
                  _buildFAQItem(
                    'Can I cancel my reservation?',
                    'Yes, you can cancel up to 30 minutes before your scheduled time for a full refund.',
                  ),
                  _buildFAQItem(
                    'How do I extend my parking time?',
                    'Go to your active reservation and tap "Extend Time" to add more hours to your booking.',
                  ),
                  _buildFAQItem(
                    'Is my vehicle insured while parked?',
                    'All parking lots have 24/7 security and CCTV monitoring. Additional insurance can be purchased during booking.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            question,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconColor: Colors.black87,
          collapsedIconColor: Colors.grey.shade600,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAskQuestionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Ask a Question',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: Colors.black87),
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Type your question here...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF5B6B9E),
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Question submitted! We\'ll respond soon.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redButton,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
