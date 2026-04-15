import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHelpSection(
            context,
            title: 'Getting Started',
            items: [
              _HelpItem(
                question: 'How do I find parking?',
                answer:
                    'Go to the Home tab, browse available parking lots, and tap on any lot to see details and book a slot.',
              ),
              _HelpItem(
                question: 'How do I make a reservation?',
                answer:
                    'Select a parking lot, choose your desired time slot, and tap "Reserve Now" to complete your booking.',
              ),
              _HelpItem(
                question: 'How do I pay for parking?',
                answer:
                    'After reserving, go to the Payment tab and select your preferred mobile money provider (MTN, Airtel, or Lyca) to complete payment.',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildHelpSection(
            context,
            title: 'Payments',
            items: [
              _HelpItem(
                question: 'What payment methods are accepted?',
                answer:
                    'We accept MTN Mobile Money, Airtel Money, and Lyca Mobile Money.',
              ),
              _HelpItem(
                question: 'Is my payment information secure?',
                answer:
                    'Yes, all payment transactions are encrypted and processed securely through trusted mobile money providers.',
              ),
              _HelpItem(
                question: 'Can I get a refund?',
                answer:
                    'Refunds are available if you cancel your reservation at least 1 hour before the scheduled time. Contact support for assistance.',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildHelpSection(
            context,
            title: 'Account & Profile',
            items: [
              _HelpItem(
                question: 'How do I edit my profile?',
                answer:
                    'Go to Profile tab, tap the edit icon next to your name, and update your information.',
              ),
              _HelpItem(
                question: 'How do I change my password?',
                answer:
                    'Go to Profile > Account > Change Password and follow the prompts.',
              ),
              _HelpItem(
                question: 'Can I add multiple vehicles?',
                answer:
                    'Yes, you can add and manage multiple vehicles in your profile settings.',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildContactSupport(context),
        ],
      ),
    );
  }

  Widget _buildHelpSection(
    BuildContext context, {
    required String title,
    required List<_HelpItem> items,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        ...items.map((item) => _buildHelpCard(context, item)),
      ],
    );
  }

  Widget _buildHelpCard(BuildContext context, _HelpItem item) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            item.question,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                item.answer,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSupport(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.support_agent,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'Still need help?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Contact our support team',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement contact support
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Support: support@parkflex.com'),
                ),
              );
            },
            icon: const Icon(Icons.email),
            label: const Text('Contact Support'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpItem {
  final String question;
  final String answer;

  _HelpItem({required this.question, required this.answer});
}
