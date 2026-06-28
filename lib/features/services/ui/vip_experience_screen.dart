import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class VipExperienceScreen extends StatelessWidget {
  const VipExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('services.vip_experience_coming_soon'.tr())),
    );
  }
}
