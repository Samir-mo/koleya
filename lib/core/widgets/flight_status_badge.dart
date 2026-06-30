import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/helpers/flight_status_helpers.dart';
import 'package:gate_buddy/core/utils/spacing.dart';

export 'package:gate_buddy/core/utils/helpers/flight_status_helpers.dart';

/// Colored pill showing a flight status string with a leading dot indicator.
///
/// Usage:
/// ```dart
/// FlightStatusBadge(status: flight.status)
/// FlightStatusBadge(status: flight.status, showBorder: false)
/// ```
class FlightStatusBadge extends StatelessWidget {
  final String status;

  /// Whether to draw a thin border matching the status color.
  final bool showBorder;

  const FlightStatusBadge({
    super.key,
    required this.status,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = flightStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(10), vertical: rh(5)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(rr(20)),
        border: showBorder
            ? Border.all(color: color.withValues(alpha: 0.4))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: rw(6),
            height: rw(6),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          horizontalSpacing(5),
          Text(
            flightStatusLabel(status),
            style: AppTextStyles.font12Medium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
