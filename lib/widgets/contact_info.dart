import 'package:flutter/material.dart';
import '../core/core.dart';
import '../data/data.dart';
import 'info_block.dart';

class ContactInfo extends StatelessWidget {
  const ContactInfo({super.key});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InfoBlock('Address', body('52, James Robertson Street\nOff Alhaji Masha Road\nSurulere\nLagos State\nNigeria')),
        InfoBlock('Email', const LinkText(firmEmail, 'mailto:$firmEmail')),
        InfoBlock('Telephone', const LinkText(firmPhone, firmPhoneUri)),
        InfoBlock('Website', body('www.bayoolatunjiandco.com')),
        InfoBlock('Office hours', body('Monday – Friday: 8:30 AM – 5:30 PM\nSaturday: By Appointment\nSunday: Closed')),
      ]);
}
