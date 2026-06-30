// Status color, label, and icon helpers shared across flight-related UI.
//
// flightStatusColor(status)  → Color
// flightStatusLabel(status)  → localized String
// flightStatusIcon(status)   → IconData

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';

Color flightStatusColor(String status) {
  switch (status.toUpperCase()) {
    case 'ON_TIME':
    case 'BOARDING':
      return AppColors.green200;
    case 'DELAYED':
      return AppColors.amber200;
    case 'CANCELLED':
      return AppColors.red200;
    case 'GATE_CHANGED':
      return AppColors.blue200;
    case 'LANDED':
      return AppColors.success;
    case 'DEPARTED':
    case 'SCHEDULED':
    default:
      return AppColors.grey400;
  }
}

String flightStatusLabel(String status) {
  switch (status.toUpperCase()) {
    case 'ON_TIME':
      return 'home.status_on_time'.tr();
    case 'BOARDING':
      return 'home.status_boarding'.tr();
    case 'DELAYED':
      return 'home.status_delayed'.tr();
    case 'CANCELLED':
      return 'home.status_cancelled'.tr();
    case 'GATE_CHANGED':
      return 'home.status_gate_changed'.tr();
    case 'DEPARTED':
      return 'home.status_departed'.tr();
    case 'LANDED':
      return 'home.status_landed'.tr();
    case 'SCHEDULED':
      return 'home.status_scheduled'.tr();
    default:
      return status.replaceAll('_', ' ');
  }
}

IconData flightStatusIcon(String status) {
  switch (status.toUpperCase()) {
    case 'ON_TIME':
      return Icons.check_circle_outline_rounded;
    case 'SCHEDULED':
    case 'DELAYED':
      return Icons.schedule_rounded;
    case 'CANCELLED':
      return Icons.cancel_outlined;
    case 'BOARDING':
      return Icons.door_back_door_outlined;
    case 'DEPARTED':
      return Icons.flight_takeoff_rounded;
    case 'LANDED':
      return Icons.flight_land_rounded;
    default:
      return Icons.info_outline_rounded;
  }
}
