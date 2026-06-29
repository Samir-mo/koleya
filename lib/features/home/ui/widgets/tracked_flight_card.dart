import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/core/widgets/custom_text_button.dart';
import 'package:gate_buddy/features/home/data/models/home_model.dart';

class TrackedFlightCard extends StatelessWidget {
  final UserTrackModel track;
  const TrackedFlightCard({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final flight = track.flight;
    final dep = flight.departure;
    final depTime = _fmt(dep.scheduledTime ?? dep.estimatedTime);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(16)),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary200.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: rw(16), vertical: rh(14)),
            decoration: const BoxDecoration(
              color: AppColors.primary200,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                _AirlineLogo(name: flight.airline.name, logo: flight.airline.logo),
                horizontalSpacing(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight.airline.name,
                        style: AppTextStyles.font14SemiBold
                            .copyWith(color: AppColors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${'home.flight_number'.tr()}: ${flight.flightNumber}',
                        style: AppTextStyles.font12Regular
                            .copyWith(color: AppColors.primary50),
                      ),
                    ],
                  ),
                ),
                if (depTime.isNotEmpty) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.flight_takeoff_rounded,
                          size: rw(13), color: AppColors.secondary200),
                      Text(
                        depTime,
                        style: AppTextStyles.font16Bold
                            .copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                  horizontalSpacing(10),
                ],
                _StatusPill(status: flight.status),
              ],
            ),
          ),

          // ── Route row ────────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(rw(16), rh(14), rw(16), rh(14)),
            child: Row(
              children: [
                _AirportInfo(
                  code: flight.route.fromCode,
                  city: flight.route.from,
                  align: CrossAxisAlignment.start,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.flight_rounded,
                          color: AppColors.secondary200, size: rw(18)),
                      Container(
                          width: double.infinity,
                          height: 1,
                          color: colors.border),
                    ],
                  ),
                ),
                _AirportInfo(
                  code: flight.route.toCode,
                  city: flight.route.to,
                  align: CrossAxisAlignment.end,
                ),
              ],
            ),
          ),

          // ── Detail chips (gate, terminal, check-in) ───────────────────────
          if (_hasDetails(dep))
            Padding(
              padding: EdgeInsets.fromLTRB(rw(16), 0, rw(16), rh(12)),
              child: Wrap(
                spacing: rw(8),
                runSpacing: rh(8),
                children: [
                  if (dep.gate != null)
                    _Chip(
                      icon: Icons.door_sliding_outlined,
                      label: 'home.gate'.tr(),
                      value: dep.gate!,
                    ),
                  if (dep.terminal != null)
                    _Chip(
                      icon: Icons.business_outlined,
                      label: 'home.terminal'.tr(),
                      value: dep.terminal!,
                    ),
                  if (dep.boardingTime != null)
                    _Chip(
                      icon: Icons.access_time_rounded,
                      label: 'home.boards_at'.tr(),
                      value: _fmt(dep.boardingTime),
                    ),
                  if (dep.checkInCounter != null)
                    _Chip(
                      icon: Icons.luggage_outlined,
                      label: 'home.check_in'.tr(),
                      value: dep.checkInCounter!,
                    ),
                ],
              ),
            ),

          Divider(height: 1, color: context.customColors.border),

          // ── Action buttons ────────────────────────────────────────────────
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(12)),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: 'home.view_details'.tr(),
                    onPressed: () => Navigator.of(context, rootNavigator: true)
                        .pushNamed(Routes.trackedFlight),
                    size: CustomButtonSize.small,
                    prefixIcon: const Icon(Icons.open_in_new_rounded),
                    textStyle: AppTextStyles.font14SemiBold,
                    borderRadius: rr(10),
                  ),
                ),
                horizontalSpacing(10),
                Expanded(
                  child: CustomTextButton.outlined(
                    text: 'home.explore_destination'.tr(),
                    onPressed: () =>
                        Navigator.pushNamed(context, Routes.explorePlacesScreen),
                    size: CustomButtonSize.small,
                    prefixIcon: const Icon(Icons.explore_rounded),
                    textStyle: AppTextStyles.font14SemiBold,
                    borderColor: AppColors.primary200.withValues(alpha: 0.5),
                    borderRadius: rr(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _hasDetails(DepartureModel dep) =>
      dep.gate != null ||
      dep.terminal != null ||
      dep.boardingTime != null ||
      dep.checkInCounter != null;

  String _fmt(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '—';
    }
  }
}

// ── Airline logo avatar ───────────────────────────────────────────────────────

class _AirlineLogo extends StatelessWidget {
  final String name;
  final String? logo;
  const _AirlineLogo({required this.name, this.logo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: rw(42),
      height: rw(42),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white.withValues(alpha: 0.3)),
      ),
      child: logo != null
          ? ClipOval(
              child: Image.network(
                logo!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _initial(name),
              ),
            )
          : _initial(name),
    );
  }

  Widget _initial(String n) => Center(
        child: Text(
          n.isNotEmpty ? n[0].toUpperCase() : '✈',
          style: AppTextStyles.font16Bold.copyWith(color: AppColors.white),
        ),
      );
}

// ── Airport info column ───────────────────────────────────────────────────────

class _AirportInfo extends StatelessWidget {
  final String code;
  final String city;
  final CrossAxisAlignment align;
  const _AirportInfo(
      {required this.code, required this.city, required this.align});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(code,
            style:
                AppTextStyles.font20Bold.copyWith(color: AppColors.primary200)),
        Text(
          city,
          style: AppTextStyles.font12Regular
              .copyWith(color: colors.textSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ── Detail chip ───────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Chip({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(10), vertical: rh(7)),
      decoration: BoxDecoration(
        color: AppColors.primary200.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(rr(10)),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: rw(13), color: AppColors.primary200),
          horizontalSpacing(5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTextStyles.font12Regular
                      .copyWith(color: colors.textHint)),
              Text(value,
                  style: AppTextStyles.font12Medium
                      .copyWith(color: colors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Status pill ───────────────────────────────────────────────────────────────

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _color(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(10), vertical: rh(5)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(rr(20)),
        border: Border.all(color: color.withValues(alpha: 0.4)),
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
            _label(status),
            style: AppTextStyles.font12Medium.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Color _color(String s) {
    switch (s.toUpperCase()) {
      case 'ON_TIME':
      case 'BOARDING':
        return AppColors.green200;
      case 'DELAYED':
        return AppColors.amber200;
      case 'CANCELLED':
        return AppColors.red200;
      case 'GATE_CHANGED':
        return AppColors.blue200;
      default:
        return AppColors.grey400;
    }
  }

  String _label(String s) {
    switch (s.toUpperCase()) {
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
      default:
        return s;
    }
  }
}
