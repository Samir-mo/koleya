import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/flights/data/models/flight_model.dart';
import 'package:gate_buddy/features/tracked_flight/logic/cubit/tracked_flight_cubit.dart';
import 'package:gate_buddy/features/tracked_flight/logic/cubit/tracked_flight_state.dart';
import 'package:gate_buddy/features/tracked_flight/ui/tracked_flight_screen.dart';
import 'package:get_it/get_it.dart';

class TrackedFlightsListScreen extends StatelessWidget {
  const TrackedFlightsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<TrackedFlightCubit>()..loadAll(),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary200,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(rw(8)),
            child: CircleAvatar(
              backgroundColor: AppColors.primary300,
              radius: rw(16),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white, size: rw(14)),
            ),
          ),
        ),
        title: Text(
          'tracked_flight.all_tracked'.tr(),
          style: AppTextStyles.font16Bold.copyWith(color: AppColors.white),
        ),
      ),
      body: BlocBuilder<TrackedFlightCubit, TrackedFlightState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary200),
            );
          }
          if (state.isFailure) {
            return _ErrorView(
              error: state.error ?? 'errors.unknown'.tr(),
              onRetry: () => context.read<TrackedFlightCubit>().loadAll(),
            );
          }
          if (state.trackedFlights.isEmpty) {
            return _EmptyView();
          }
          return RefreshIndicator(
            color: AppColors.primary200,
            onRefresh: () => context.read<TrackedFlightCubit>().loadAll(),
            child: ListView.separated(
              padding: EdgeInsets.all(rw(16)),
              itemCount: state.trackedFlights.length,
              separatorBuilder: (_, __) => verticalSpacing(12),
              itemBuilder: (_, i) =>
                  _TrackedCard(flight: state.trackedFlights[i]),
            ),
          );
        },
      ),
    );
  }
}

class _TrackedCard extends StatelessWidget {
  final FlightModel flight;
  const _TrackedCard({required this.flight});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final statusColor = _statusColor(flight.status);
    final dep = flight.departure;
    final depTime = dep.estimatedTime ?? dep.scheduledTime;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              TrackedFlightScreen(flight: flight),
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: Tween(
                    begin: const Offset(1, 0), end: Offset.zero)
                .animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutCubic)),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(rr(16)),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: rw(16), vertical: rh(12)),
              decoration: const BoxDecoration(
                color: AppColors.primary200,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  _AirlineLogo(
                      name: flight.airline.name,
                      logo: flight.airline.logo),
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
                          flight.flightNumber,
                          style: AppTextStyles.font12Regular
                              .copyWith(color: AppColors.primary50),
                        ),
                      ],
                    ),
                  ),
                  if (depTime != null) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.flight_takeoff_rounded,
                            size: rw(13),
                            color: AppColors.secondary200),
                        Text(
                          _fmt(depTime),
                          style: AppTextStyles.font16Bold
                              .copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                    horizontalSpacing(10),
                  ],
                  _StatusBadge(
                      status: flight.status, color: statusColor),
                ],
              ),
            ),

            // Route row
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: rw(16), vertical: rh(14)),
              child: Row(
                children: [
                  _AirportCode(
                      code: flight.route.fromCode,
                      city: flight.route.from,
                      align: CrossAxisAlignment.start),
                  Expanded(
                    child: Column(
                      children: [
                        Icon(Icons.flight_rounded,
                            color: AppColors.secondary200,
                            size: rw(18)),
                        Container(
                            width: double.infinity,
                            height: 1,
                            color: colors.border),
                      ],
                    ),
                  ),
                  _AirportCode(
                      code: flight.route.toCode,
                      city: flight.route.to,
                      align: CrossAxisAlignment.end),
                ],
              ),
            ),

            // Gate / terminal row
            if (dep.gate != null || dep.terminal != null)
              Padding(
                padding: EdgeInsets.fromLTRB(rw(16), 0, rw(16), rh(12)),
                child: Row(
                  children: [
                    if (dep.gate != null)
                      _InfoChip(
                          icon: Icons.door_sliding_outlined,
                          label:
                              '${'tracked_flight.gate'.tr()} ${dep.gate}'),
                    if (dep.gate != null && dep.terminal != null)
                      horizontalSpacing(8),
                    if (dep.terminal != null)
                      _InfoChip(
                          icon: Icons.business_outlined,
                          label:
                              '${'tracked_flight.terminal'.tr()} ${dep.terminal}'),
                    const Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: rw(14), color: colors.textHint),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsets.only(
                    left: rw(16), right: rw(16), bottom: rh(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: rw(14), color: colors.textHint),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Color _statusColor(String s) {
    switch (s.toUpperCase()) {
      case 'ON_TIME':
        return AppColors.green200;
      case 'BOARDING':
        return AppColors.blue200;
      case 'DELAYED':
        return AppColors.amber200;
      case 'CANCELLED':
        return AppColors.red200;
      default:
        return AppColors.grey400;
    }
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _AirlineLogo extends StatelessWidget {
  final String name;
  final String logo;
  const _AirlineLogo({required this.name, required this.logo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: rw(38),
      height: rw(38),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white.withValues(alpha: 0.3)),
      ),
      child: logo.isNotEmpty
          ? ClipOval(
              child: Image.network(logo,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _initial(name)),
            )
          : _initial(name),
    );
  }

  Widget _initial(String n) => Center(
        child: Text(
          n.isNotEmpty ? n[0].toUpperCase() : '✈',
          style:
              AppTextStyles.font14Bold.copyWith(color: AppColors.white),
        ),
      );
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;
  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: rw(8), vertical: rh(4)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(rr(20)),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: rw(5),
            height: rw(5),
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          horizontalSpacing(4),
          Text(
            status.replaceAll('_', ' '),
            style: AppTextStyles.font12Medium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _AirportCode extends StatelessWidget {
  final String code;
  final String city;
  final CrossAxisAlignment align;
  const _AirportCode(
      {required this.code, required this.city, required this.align});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(code,
            style: AppTextStyles.font20Bold
                .copyWith(color: AppColors.primary200)),
        Text(city,
            style: AppTextStyles.font12Regular
                .copyWith(color: colors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: rw(10), vertical: rh(5)),
      decoration: BoxDecoration(
        color: AppColors.primary200.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(rr(8)),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: rw(12), color: AppColors.primary200),
          horizontalSpacing(5),
          Text(label,
              style: AppTextStyles.font12Medium
                  .copyWith(color: context.customColors.textPrimary)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(rw(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: rw(52), color: colors.textHint),
            verticalSpacing(16),
            Text(error,
                style: AppTextStyles.font14Regular
                    .copyWith(color: colors.textSecondary),
                textAlign: TextAlign.center),
            verticalSpacing(24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary200),
              child: Text('errors.error_screen_button'.tr(),
                  style: AppTextStyles.font14SemiBold
                      .copyWith(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.airplanemode_off_rounded,
              size: rw(64), color: colors.textHint),
          verticalSpacing(20),
          Text('tracked_flight.no_tracking'.tr(),
              style: AppTextStyles.font18Bold
                  .copyWith(color: colors.textPrimary)),
          verticalSpacing(10),
          Text('tracked_flight.no_tracking_hint'.tr(),
              style: AppTextStyles.font14Regular
                  .copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
