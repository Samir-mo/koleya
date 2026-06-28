import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/home/data/models/home_model.dart';

class MetricsStrip extends StatelessWidget {
  final MetricsModel metrics;
  const MetricsStrip({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    final items = [
      _MetricData(
        icon: Icons.people_outline_rounded,
        value: _compact(metrics.activeUsers),
        label: 'home.metrics_users'.tr(),
        color: AppColors.primary200,
      ),
      _MetricData(
        icon: Icons.flight_outlined,
        value: _compact(metrics.flightsTracked),
        label: 'home.metrics_tracked'.tr(),
        color: AppColors.blue200,
      ),
      _MetricData(
        icon: Icons.schedule_rounded,
        value: metrics.delays.toString(),
        label: 'home.metrics_delays'.tr(),
        color: AppColors.amber200,
      ),
      _MetricData(
        icon: Icons.star_rounded,
        value: metrics.userRating,
        label: 'home.metrics_rating'.tr(),
        color: AppColors.secondary200,
      ),
    ];

    return SizedBox(
      height: rh(88),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: rw(20)),
        itemCount: items.length,
        separatorBuilder: (_, __) => horizontalSpacing(12),
        itemBuilder: (_, i) => _MetricCard(data: items[i]),
      ),
    );
  }

  String _compact(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}

class _MetricData {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _MetricData({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
}

class _MetricCard extends StatelessWidget {
  final _MetricData data;
  const _MetricCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      width: rw(90),
      padding: EdgeInsets.symmetric(horizontal: rw(12), vertical: rh(10)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(14)),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: rw(28),
            height: rw(28),
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(rr(8)),
            ),
            child: Icon(data.icon, size: rw(14), color: data.color),
          ),
          verticalSpacing(4),
          Text(
            data.value,
            style: AppTextStyles.font14SemiBold
                .copyWith(color: colors.textPrimary),
          ),
          Text(
            data.label,
            style: AppTextStyles.font12Regular
                .copyWith(color: colors.textHint),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

