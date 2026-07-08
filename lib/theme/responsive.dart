import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 700;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 700;
  }

  static double quoteSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 380) return 24;
    if (width < 700) return 30;
    if (width < 1200) return 40;

    return 48;
  }

  static double titleSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 700) return 14;
    if (width < 1200) return 18;

    return 20;
  }

  static double imageSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 700) return 80;
    if (width < 1200) return 110;

    return 130;
  }

  static double cardPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 400) return 18;
    if (width < 700) return 24;
    if (width < 1200) return 32;

    return 40;
  }

  static double maxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 1200) {
      return double.infinity;
    }

    return 1400;
  }
}