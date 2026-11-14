import 'package:flutter/material.dart';
import '../core/core.dart';

class ConsultationBanner extends StatelessWidget {
  const ConsultationBanner({super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: lagoon,
        padding: EdgeInsets.all(isMobile(context) ? 28 : 48),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Free consultation', style: serif(isMobile(context) ? 32 : 42, c: Colors.white)),
          const SizedBox(height: 8),
          Text('Need legal advice?', style: serif(24, c: brass, w: FontWeight.w500)),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Contact us today to schedule a confidential consultation. Our team is ready to provide practical legal solutions tailored to your needs.',
              style: sans(16, c: Colors.white.withOpacity(.85)),
            ),
          ),
        ]),
      );
}
