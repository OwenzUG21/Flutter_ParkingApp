import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last updated: April 8, 2026',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              title: '1. Information We Collect',
              content: 'We collect information you provide directly to us, including:\n\n'
                  '• Account information (name, email, phone number)\n'
                  '• Vehicle information\n'
                  '• Payment information (mobile money numbers)\n'
                  '• Location data when using the app\n'
                  '• Parking history and preferences',
            ),
            
            _buildSection(
              context,
              title: '2. How We Use Your Information',
              content: 'We use the information we collect to:\n\n'
                  '• Provide and maintain our parking services\n'
                  '• Process your reservations and payments\n'
                  '• Send you notifications about your bookings\n'
                  '• Improve our app and services\n'
                  '• Communicate with you about updates and offers\n'
                  '• Ensure security and prevent fraud',
            ),
            
            _buildSection(
              context,
              title: '3. Information Sharing',
              content: 'We do not sell your personal information. We may share your information with:\n\n'
                  '• Parking lot operators to fulfill your reservations\n'
                  '• Payment processors to complete transactions\n'
                  '• Service providers who assist in operating our app\n'
                  '• Law enforcement when required by law',
            ),
            
            _buildSection(
              context,
              title: '4. Data Security',
              content: 'We implement appropriate security measures to protect your personal information. '
                  'However, no method of transmission over the internet is 100% secure. '
                  'We use encryption for sensitive data and regularly update our security practices.',
            ),
            
            _buildSection(
              context,
              title: '5. Your Rights',
              content: 'You have the right to:\n\n'
                  '• Access your personal information\n'
                  '• Correct inaccurate data\n'
                  '• Request deletion of your data\n'
                  '• Opt-out of marketing communications\n'
                  '• Export your data',
            ),
            
            _buildSection(
              context,
              title: '6. Location Data',
              content: 'We collect location data to help you find nearby parking spots. '
                  'You can disable location services in your device settings, but this may limit app functionality.',
            ),
            
            _buildSection(
              context,
              title: '7. Cookies and Tracking',
              content: 'We use cookies and similar technologies to improve your experience, '
                  'analyze app usage, and remember your preferences.',
            ),
            
            _buildSection(
              context,
              title: '8. Children\'s Privacy',
              content: 'Our service is not intended for children under 13. '
                  'We do not knowingly collect information from children under 13.',
            ),
            
            _buildSection(
              context,
              title: '9. Changes to This Policy',
              content: 'We may update this privacy policy from time to time. '
                  'We will notify you of any changes by posting the new policy in the app.',
            ),
            
            _buildSection(
              context,
              title: '10. Contact Us',
              content: 'If you have questions about this privacy policy, please contact us at:\n\n'
                  'Email: privacy@parkflex.com\n'
                  'Phone: +256 700 000 000',
            ),
            
            const SizedBox(height: 32),
            
            // Accept Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'I Understand',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
