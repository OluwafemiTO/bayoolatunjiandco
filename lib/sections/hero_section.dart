import 'package:flutter/material.dart';
import '../core/core.dart';
import '../widgets/brand_button.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onBook, onExplore;
  const HeroSection({super.key, required this.onBook, required this.onExplore});

  @override
  Widget build(BuildContext context) {
    final m = isMobile(context);
    final big = serif(m ? 46 : 84, c: Colors.white, w: FontWeight.w500);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      builder: (c, v, child) => Opacity(opacity: v, child: child),
      child: Section(
        bg: lagoon,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: m ? 16 : 48),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Trusted Legal Solutions.', style: big),
            Text('Strategic Advice.', style: big.copyWith(color: Colors.white.withOpacity(.75))),
            Text('Proven Commitment.', style: big.copyWith(color: brass)),
            const SizedBox(height: 32),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Text(
                'We deliver practical, timely, and effective legal solutions to individuals, businesses, financial institutions, investors, and government agencies.',
                style: sans(18, c: Colors.white.withOpacity(.85)),
              ),
            ),
            const SizedBox(height: 36),
            Wrap(spacing: 24, runSpacing: 16, crossAxisAlignment: WrapCrossAlignment.center, children: [
              BrandButton('Book a Consultation', onPressed: onBook),
              BrandButton('Explore Practice Areas', style: BrandButtonStyle.outline, onPressed: onExplore),
              Text('Your Success. Our Commitment.', style: serif(24, c: Colors.white, w: FontWeight.w500)),
            ]),
          ]),
        ),
      ),
    );
  }
}
