import 'package:flutter/material.dart';

const mobileBreakpoint = 820.0;

bool isMobile(BuildContext c) => MediaQuery.of(c).size.width < mobileBreakpoint;
