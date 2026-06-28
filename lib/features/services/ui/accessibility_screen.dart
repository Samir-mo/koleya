import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('services.accessibility_coming_soon'.tr())),
    );
  }
}
