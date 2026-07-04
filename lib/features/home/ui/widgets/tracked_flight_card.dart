import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/helpers/flight_time_helpers.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../../core/widgets/flight_info_chip.dart';
import '../../../../core/widgets/flight_status_badge.dart';
import '../../data/models/home_model.dart';

class TrackedFlightCard extends StatelessWidget {
  final UserTrackModel track;
  const TrackedFlightCard({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final flight = track.flight;
    final dep = flight.departure;
    final depTime = formatHmFromIso(dep.scheduledTime ?? dep.estimatedTime);

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
            padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(14)),
            decoration: const BoxDecoration(
              color: AppColors.primary200,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                _AirlineLogo(
                  name: flight.airline.name,
                  logo: flight.airline.logo,
                ),
                horizontalSpacing(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight.airline.name,
                        style: AppTextStyles.font14SemiBold.copyWith(
                          color: AppColors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${'home.flight_number'.tr()}: ${flight.flightNumber}',
                        style: AppTextStyles.font12Regular.copyWith(
                          color: AppColors.primary50,
                        ),
                      ),
                    ],
                  ),
                ),
                if (depTime.isNotEmpty) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.flight_takeoff_rounded,
                        size: rw(13),
                        color: AppColors.secondary200,
                      ),
                      Text(
                        depTime,
                        style: AppTextStyles.font16Bold.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  horizontalSpacing(10),
                ],
                FlightStatusBadge(status: flight.status),
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
                      Icon(
                        Icons.flight_rounded,
                        color: AppColors.secondary200,
                        size: rw(18),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: colors.border,
                      ),
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
                    FlightInfoChip(
                      icon: Icons.door_sliding_outlined,
                      label: 'home.gate'.tr(),
                      value: dep.gate!,
                    ),
                  if (dep.terminal != null)
                    FlightInfoChip(
                      icon: Icons.business_outlined,
                      label: 'home.terminal'.tr(),
                      value: dep.terminal!,
                    ),
                  if (dep.boardingTime != null)
                    FlightInfoChip(
                      icon: Icons.access_time_rounded,
                      label: 'home.boards_at'.tr(),
                      value: formatHmFromIso(dep.boardingTime),
                    ),
                  if (dep.checkInCounter != null)
                    FlightInfoChip(
                      icon: Icons.luggage_outlined,
                      label: 'home.check_in'.tr(),
                      value: dep.checkInCounter!,
                    ),
                ],
              ),
            ),

          Divider(height: 1, color: context.customColors.border),

          // ── Action button ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(12)),
            child: CustomTextButton(
              text: 'home.view_details'.tr(),
              onPressed: () => Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed(Routes.trackedFlight),
              isFullWidth: true,
              size: CustomButtonSize.small,
              prefixIcon: const Icon(Icons.open_in_new_rounded),
              textStyle: AppTextStyles.font14SemiBold,
              borderRadius: rr(10),
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
  const _AirportInfo({
    required this.code,
    required this.city,
    required this.align,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          code,
          style: AppTextStyles.font20Bold.copyWith(color: AppColors.primary200),
        ),
        Text(
          city,
          style: AppTextStyles.font12Regular.copyWith(
            color: colors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
