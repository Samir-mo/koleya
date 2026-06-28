import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FinancialServicesScreen extends StatelessWidget {
  const FinancialServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('services.financial_services_coming_soon'.tr())),
    );
  }
}
