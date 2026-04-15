import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Terms of Service'),
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
              title: '1. Acceptance of Terms',
              content:
                  'By accessing and using ParkFlex, you accept and agree to be bound by the terms and provisions of this agreement. '
                  'If you do not agree to these terms, please do not use our service.',
            ),

            _buildSection(
              context,
              title: '2. Use of Service',
              content:
                  'ParkFlex provides a platform for finding, reserving, and paying for parking spaces. You agree to:\n\n'
                  '• Provide accurate and complete information\n'
                  '• Maintain the security of your account\n'
                  '• Use the service only for lawful purposes\n'
                  '• Not interfere with the proper functioning of the service\n'
                  '• Comply with all applicable laws and regulations',
            ),

            _buildSection(
              context,
              title: '3. Reservations and Payments',
              content: 'When you make a reservation:\n\n'
                  '• You agree to pay the specified parking fees\n'
                  '• Reservations are subject to availability\n'
                  '• Cancellation policies apply as stated\n'
                  '• Payment is processed through secure mobile money providers\n'
                  '• You are responsible for any fees charged by your payment provider',
            ),

            _buildSection(
              context,
              title: '4. Cancellation Policy',
              content:
                  'Cancellations made at least 1 hour before the scheduled time are eligible for a full refund. '
                  'Late cancellations or no-shows may result in charges as per the parking lot\'s policy.',
            ),

            _buildSection(
              context,
              title: '5. User Responsibilities',
              content: 'You are responsible for:\n\n'
                  '• Your vehicle and its contents\n'
                  '• Arriving on time for your reservation\n'
                  '• Following parking lot rules and regulations\n'
                  '• Any damage caused to the parking facility\n'
                  '• Ensuring your vehicle is legally registered and insured',
            ),

            _buildSection(
              context,
              title: '6. Limitation of Liability',
              content:
                  'ParkFlex acts as an intermediary between users and parking lot operators. '
                  'We are not responsible for:\n\n'
                  '• Loss, theft, or damage to vehicles or property\n'
                  '• Actions or omissions of parking lot operators\n'
                  '• Service interruptions or technical issues\n'
                  '• Indirect or consequential damages',
            ),

            _buildSection(
              context,
              title: '7. Intellectual Property',
              content:
                  'All content, features, and functionality of ParkFlex are owned by us and protected by copyright, '
                  'trademark, and other intellectual property laws.',
            ),

            _buildSection(
              context,
              title: '8. Account Termination',
              content:
                  'We reserve the right to suspend or terminate your account if you:\n\n'
                  '• Violate these terms of service\n'
                  '• Engage in fraudulent activity\n'
                  '• Abuse the service or other users\n'
                  '• Fail to pay for services rendered',
            ),

            _buildSection(
              context,
              title: '9. Changes to Terms',
              content:
                  'We may modify these terms at any time. Continued use of the service after changes constitutes acceptance of the new terms. '
                  'We will notify users of significant changes.',
            ),

            _buildSection(
              context,
              title: '10. Governing Law',
              content:
                  'These terms are governed by the laws of Uganda. Any disputes shall be resolved in the courts of Uganda.',
            ),

            _buildSection(
              context,
              title: '11. Contact Information',
              content: 'For questions about these terms, contact us at:\n\n'
                  'Email: legal@parkflex.com\n'
                  'Phone: +256 700 000 000\n'
                  'Address: Kampala, Uganda',
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
                  'I Agree',
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
