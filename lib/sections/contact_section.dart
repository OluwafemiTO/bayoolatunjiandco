import 'package:flutter/material.dart';
import '../core/core.dart';
import '../widgets/consultation_banner.dart';
import '../widgets/contact_info.dart';
import '../widgets/inquiry_form.dart';
import '../widgets/map_embed.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) => Section(
        bg: context.pal.page,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          heading(context, 'Contact us'),
          const SizedBox(height: 40),
          split(context, const ContactInfo(), const InquiryForm(), fa: 1, fb: 1),
          const SizedBox(height: 56),
          const MapEmbed(),
          const SizedBox(height: 56),
          const ConsultationBanner(),
        ]),
      );
}
