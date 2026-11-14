import 'package:flutter/material.dart';
import '../data/data.dart';
import '../layout/footer.dart';
import '../layout/site_app_bar.dart';
import '../layout/site_drawer.dart';
import '../sections/about_section.dart';
import '../sections/contact_section.dart';
import '../sections/hero_section.dart';
import '../sections/insights_section.dart';
import '../sections/services_section.dart';
import '../sections/stats_section.dart';
import '../sections/team_section.dart';
import '../sections/testimonials_section.dart';
import '../sections/why_us_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final keys = {for (final i in [...navItems, 'Insights']) i: GlobalKey()};

  void go(String id) {
    final c = keys[id]?.currentContext;
    if (c != null) {
      Scrollable.ensureVisible(c, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: SiteAppBar(items: navItems, onNav: go),
        endDrawer: SiteDrawer(items: navItems, onNav: go),
        body: SingleChildScrollView(
          child: Column(children: [
            HeroSection(key: keys['Home'], onBook: () => go('Contact Us'), onExplore: () => go('Practice Areas')),
            AboutSection(key: keys['About Us']),
            ServicesSection(key: keys['Practice Areas']),
            const StatsSection(),
            const WhyUsSection(),
            TeamSection(key: keys['Our Team']),
            const TestimonialsSection(),
            InsightsSection(key: keys['Insights']),
            ContactSection(key: keys['Contact Us']),
            Footer(links: footerLinks, onNav: go),
          ]),
        ),
      );
}
