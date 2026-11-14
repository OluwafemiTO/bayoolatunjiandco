import 'package:flutter/material.dart';
import '../core/core.dart';

class InquirySuccess extends StatelessWidget {
  final String email;
  final VoidCallback onReset;
  const InquirySuccess({super.key, required this.email, required this.onReset});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(28),
        color: context.pal.alt,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.check_circle, color: context.pal.heading, size: 36),
          const SizedBox(height: 12),
          Text('Inquiry received', style: serif(30, c: context.pal.heading)),
          const SizedBox(height: 8),
          body('Thank you. We will respond to $email shortly.'),
          const SizedBox(height: 16),
          TextButton(onPressed: onReset, child: const Text('Send another inquiry')),
        ]),
      );
}
