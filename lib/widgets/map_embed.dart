// Web-only: renders the Google Maps <iframe> inside Flutter.
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import '../data/data.dart';

const _viewType = 'firm-map-iframe';
bool _registered = false;

void _register() {
  if (_registered) return;
  _registered = true;
  ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
    return web.HTMLIFrameElement()
      ..src = mapEmbedUrl
      ..title = 'Map showing the office of $firmName'
      ..allowFullscreen = true
      ..loading = 'lazy'
      ..referrerPolicy = 'strict-origin-when-cross-origin'
      ..style.border = '0'
      ..style.width = '100%'
      ..style.height = '100%';
  });
}

class MapEmbed extends StatelessWidget {
  final double height;
  const MapEmbed({super.key, this.height = 380});

  @override
  Widget build(BuildContext context) {
    _register();
    return Semantics(
      label: 'Map showing the office location',
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: const HtmlElementView(viewType: _viewType),
      ),
    );
  }
}
