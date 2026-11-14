import 'package:flutter/material.dart';

class Service {
  final String title, slug;
  final IconData icon;
  final String? blurb;
  final List<String> items;
  const Service(this.title, this.slug, this.icon, {this.blurb, this.items = const []});

  String get snippet => blurb ?? '${items.take(3).join(', ')}, and more.';
}
