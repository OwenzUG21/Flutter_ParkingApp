import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../services/language_service.dart';
import '../services/translation_service.dart';
import 'admin_support_bot.dart'; // Import smart support bot

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: theme.colorScheme.surface),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.settings_rounded,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'settings'.tr(context),
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Manage your preferences',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                          fontSize: 14,
                        ),
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
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage notification preferences',
                    onTap: () {
                      Navigator.pushNamed(context, '/notifications-settings');
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.security_outlined,
                    title: 'Privacy & Security',
                    subtitle: 'Control your privacy settings',
                    onTap: () {
                      Navigator.pushNamed(context, '/privacy-security');
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('App Settings'),
                  _buildSettingItem(
                    icon: Icons.bug_report_outlined,
                    title: 'OneSignal Debug',
                    subtitle: 'Test push notifications',
                    onTap: () {
                      Navigator.pushNamed(context, '/onesignal-test');
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.storage_outlined,
                    title: 'Data & Storage',
                    subtitle: 'Manage app data and cache',
                    trailing: Builder(
                      builder: (context) {
                        final theme = Theme.of(context);
                        return Text(
                          '124 MB',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/data-storage');
                    },
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
                  ListenableBuilder(
                    listenable: LanguageService(),
                    builder: (context, _) {
                      return _buildSettingItem(
                        icon: Icons.language_outlined,
                        title: 'language'.tr(context),
                        subtitle: LanguageService().languageName,
                        onTap: () async {
                          await Navigator.pushNamed(context, '/language');
                        },
                      );
                    },
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
                    title: 'Smart Support Chat',
                    subtitle: 'Get instant help with step-by-step guidance',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SupportBotWidget(),
                        ),
                      );
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'Version 1.0.0',
                    onTap: () {
                      Navigator.pushNamed(context, '/about');
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Legal'),
                  _buildSettingItem(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    subtitle: 'Read our terms',
                    onTap: () {
                      Navigator.pushNamed(context, '/terms-of-service');
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'How we handle your data',
                    onTap: () {
                      Navigator.pushNamed(context, '/privacy-policy');
                    },
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
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
          child: Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
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
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: theme.colorScheme.primary,
                        size: 22,
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
                              color: theme.colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing ??
                        Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.4,
                          ),
                          size: 24,
                        ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showFAQBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
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
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? theme.colorScheme.surfaceContainerHighest
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.brightness == Brightness.dark
                  ? theme.colorScheme.outline
                  : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Theme(
            data: ThemeData(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Text(
                question,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              iconColor: theme.colorScheme.onSurface,
              collapsedIconColor: theme.colorScheme.onSurface.withValues(
                alpha: 0.6,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    answer,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 14,
                      height: 1.5,
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
}
