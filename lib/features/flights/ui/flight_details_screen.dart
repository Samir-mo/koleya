import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/core/widgets/custom_text_button.dart';
import 'package:gate_buddy/features/tracked_flight/ui/tracked_flight_screen.dart';

import '../data/models/flight_model.dart';
import '../logic/cubit/flights_cubit.dart';
import '../logic/cubit/flights_state.dart';

class FlightDetailsScreen extends StatelessWidget {
  final FlightModel flight;

  const FlightDetailsScreen({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FlightsCubit, FlightsState, FlightModel>(
      selector: (state) {
        final all = [...state.departures, ...state.arrivals, ...state.searchResults];
        return all.firstWhere((f) => f.id == flight.id, orElse: () => flight);
      },
      builder: (context, current) => _FlightDetailsView(flight: current),
    );
  }
}

class _FlightDetailsView extends StatelessWidget {
  final FlightModel flight;
  const _FlightDetailsView({required this.flight});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final isTracking = context.select<FlightsCubit, bool>(
      (c) => c.state.trackingFlightId == flight.id,
    );

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        slivers: [
          _DetailAppBar(flight: flight, isTracking: isTracking),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(rw(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatusCard(flight: flight),
                  SizedBox(height: rh(16)),
                  _RouteCard(flight: flight, colors: colors),
                  SizedBox(height: rh(16)),
                  _ScheduleSection(
                    title: 'flights.departure'.tr(),
                    icon: Icons.flight_takeoff_rounded,
                    schedule: flight.departure,
                    colors: colors,
                  ),
                  SizedBox(height: rh(12)),
                  _ScheduleSection(
                    title: 'flights.arrival'.tr(),
                    icon: Icons.flight_land_rounded,
                    schedule: flight.arrival,
                    colors: colors,
                  ),
                  if (flight.updates.isNotEmpty) ...[
                    SizedBox(height: rh(16)),
                    _UpdatesSection(updates: flight.updates, colors: colors),
                  ],
                  SizedBox(height: rh(100)),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _TrackBar(flight: flight, isTracking: isTracking),
    );
  }
}

// ── Sliver App Bar ────────────────────────────────────────────────────────────

class _DetailAppBar extends StatelessWidget {
  final FlightModel flight;
  final bool isTracking;

  const _DetailAppBar({required this.flight, required this.isTracking});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primary200,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: AppColors.primary300,
            radius: 16,
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.white, size: 14),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: _AppBarBackground(flight: flight),
        titlePadding: const EdgeInsets.fromLTRB(56, 0, 16, 14),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              flight.flightNumber,
              style: AppTextStyles.font16Bold.copyWith(color: AppColors.white),
            ),
            Text(
              flight.airline.name,
              style: AppTextStyles.font12Regular.copyWith(
                color: AppColors.primary50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBarBackground extends StatelessWidget {
  final FlightModel flight;
  const _AppBarBackground({required this.flight});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary300, AppColors.primary200],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.flight_rounded,
              size: 160,
              color: AppColors.primary300.withValues(alpha: 0.4),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Airline logo
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: flight.airline.logo.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: flight.airline.logo,
                              fit: BoxFit.contain,
                              errorWidget: (_, __, ___) => const Icon(
                                Icons.flight,
                                color: AppColors.grey400,
                              ),
                            )
                          : const Icon(Icons.flight, color: AppColors.grey400),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          flight.airline.name,
                          style: AppTextStyles.font18Bold.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary300,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                flight.flightNumber,
                                style: AppTextStyles.font12Medium.copyWith(
                                  color: AppColors.secondary200,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary300,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                flight.type.toUpperCase(),
                                style: AppTextStyles.font12Regular.copyWith(
                                  color: AppColors.primary50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Status Card ───────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  final FlightModel flight;
  const _StatusCard({required this.flight});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(flight.status);
    final label = flight.status.replaceAll('_', ' ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(_statusIcon(flight.status), color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flight Status',
                style: AppTextStyles.font12Regular.copyWith(
                  color: color.withValues(alpha: 0.8),
                ),
              ),
              Text(
                label,
                style: AppTextStyles.font18Bold.copyWith(color: color),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Color _statusColor(String s) {
    switch (s.toUpperCase()) {
      case 'ON_TIME': return AppColors.green200;
      case 'DELAYED': return AppColors.amber200;
      case 'CANCELLED': return AppColors.red200;
      case 'BOARDING': return AppColors.blue200;
      case 'DEPARTED': return AppColors.grey400;
      case 'LANDED': return AppColors.success;
      default: return AppColors.grey300;
    }
  }

  static IconData _statusIcon(String s) {
    switch (s.toUpperCase()) {
      case 'ON_TIME': return Icons.check_circle_outline_rounded;
      case 'DELAYED': return Icons.schedule_rounded;
      case 'CANCELLED': return Icons.cancel_outlined;
      case 'BOARDING': return Icons.door_back_door_outlined;
      case 'DEPARTED': return Icons.flight_takeoff_rounded;
      case 'LANDED': return Icons.flight_land_rounded;
      default: return Icons.info_outline_rounded;
    }
  }
}

// ── Route Card ────────────────────────────────────────────────────────────────

class _RouteCard extends StatelessWidget {
  final FlightModel flight;
  final dynamic colors;
  const _RouteCard({required this.flight, required this.colors});

  @override
  Widget build(BuildContext context) {
    final dep = flight.departure;
    final arr = flight.arrival;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // From
              _AirportBlock(
                code: flight.route.fromCode,
                time: _fmt(dep.estimatedTime ?? dep.scheduledTime),
                label: dep.terminal != null ? 'Terminal ${dep.terminal}' : '',
                colors: colors,
                align: CrossAxisAlignment.start,
              ),

              // Flight path visualizer
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _DashedLine()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: AppColors.secondary200,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.flight_rounded,
                                  color: AppColors.white, size: 18),
                            ),
                          ),
                          Expanded(child: _DashedLine()),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        flight.direction == 'departure'
                            ? 'Departure'
                            : 'Arrival',
                        style: AppTextStyles.font12Regular.copyWith(
                          color: colors.textHint,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // To
              _AirportBlock(
                code: flight.route.toCode,
                time: _fmt(arr.estimatedTime ?? arr.scheduledTime),
                label: arr.terminal != null ? 'Terminal ${arr.terminal}' : '',
                colors: colors,
                align: CrossAxisAlignment.end,
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: colors.divider),
          const SizedBox(height: 12),

          // Gate row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _QuickInfo(
                icon: Icons.door_front_door_outlined,
                label: 'Dep. Gate',
                value: dep.gate ?? '—',
                colors: colors,
              ),
              _Divider(),
              _QuickInfo(
                icon: Icons.business_outlined,
                label: 'Dep. Terminal',
                value: dep.terminal ?? '—',
                colors: colors,
              ),
              _Divider(),
              _QuickInfo(
                icon: Icons.door_front_door_outlined,
                label: 'Arr. Gate',
                value: arr.gate ?? '—',
                colors: colors,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return '—';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _AirportBlock extends StatelessWidget {
  final String code;
  final String time;
  final String label;
  final dynamic colors;
  final CrossAxisAlignment align;

  const _AirportBlock({
    required this.code,
    required this.time,
    required this.label,
    required this.colors,
    required this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(code,
            style: AppTextStyles.font24Bold.copyWith(
                color: AppColors.primary200)),
        Text(time,
            style: AppTextStyles.font16SemiBold.copyWith(
                color: colors.textPrimary)),
        if (label.isNotEmpty)
          Text(label,
              style: AppTextStyles.font12Regular.copyWith(
                  color: colors.textHint)),
      ],
    );
  }
}

class _QuickInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final dynamic colors;

  const _QuickInfo({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.primary200),
        const SizedBox(height: 4),
        Text(value,
            style: AppTextStyles.font14Bold.copyWith(
                color: colors.textPrimary)),
        Text(label,
            style: AppTextStyles.font12Regular.copyWith(
                color: colors.textHint)),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final borderColor = context.customColors.border;
    return LayoutBuilder(
      builder: (_, constraints) {
        final count = (constraints.maxWidth / 6).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            count,
            (_) => Container(width: 3, height: 1.5, color: borderColor),
          ),
        );
      },
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: context.customColors.divider);
  }
}

// ── Schedule Section ──────────────────────────────────────────────────────────

class _ScheduleSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final FlightScheduleModel schedule;
  final dynamic colors;

  const _ScheduleSection({
    required this.title,
    required this.icon,
    required this.schedule,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primary50,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: AppColors.primary200),
              ),
              const SizedBox(width: 10),
              Text(title,
                  style: AppTextStyles.font16SemiBold.copyWith(
                      color: colors.textPrimary)),
            ],
          ),
          const SizedBox(height: 14),
          _TimeRow(
            label: 'Scheduled',
            time: schedule.scheduledTime,
            colors: colors,
            isHighlighted: false,
          ),
          if (schedule.estimatedTime != null) ...[
            const SizedBox(height: 8),
            _TimeRow(
              label: 'Estimated',
              time: schedule.estimatedTime,
              colors: colors,
              isHighlighted: true,
            ),
          ],
          if (schedule.actualTime != null) ...[
            const SizedBox(height: 8),
            _TimeRow(
              label: 'Actual',
              time: schedule.actualTime,
              colors: colors,
              isHighlighted: false,
            ),
          ],
          if (schedule.gate != null || schedule.terminal != null) ...[
            const SizedBox(height: 12),
            Divider(color: colors.divider),
            const SizedBox(height: 10),
            Row(
              children: [
                if (schedule.gate != null)
                  _InfoTag(
                    label: 'Gate ${schedule.gate}',
                    color: AppColors.secondary200,
                  ),
                if (schedule.gate != null && schedule.terminal != null)
                  const SizedBox(width: 8),
                if (schedule.terminal != null)
                  _InfoTag(
                    label: 'Terminal ${schedule.terminal}',
                    color: AppColors.primary200,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  final String label;
  final DateTime? time;
  final dynamic colors;
  final bool isHighlighted;

  const _TimeRow({
    required this.label,
    required this.time,
    required this.colors,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = _fmtFull(time);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTextStyles.font14Regular.copyWith(
                color: colors.textSecondary)),
        Text(
          formatted,
          style: isHighlighted
              ? AppTextStyles.font14Bold.copyWith(color: AppColors.primary200)
              : AppTextStyles.font14Regular.copyWith(
                  color: colors.textPrimary),
        ),
      ],
    );
  }

  String _fmtFull(DateTime? dt) {
    if (dt == null) return '—';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    return '$h:$m · $day/$month';
  }
}

class _InfoTag extends StatelessWidget {
  final String label;
  final Color color;
  const _InfoTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(label,
          style: AppTextStyles.font12Medium.copyWith(color: color)),
    );
  }
}

// ── Updates Section ───────────────────────────────────────────────────────────

class _UpdatesSection extends StatelessWidget {
  final List<FlightUpdateModel> updates;
  final dynamic colors;

  const _UpdatesSection({required this.updates, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.amber0,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.amber100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.update_rounded,
                  size: 18, color: AppColors.amber300),
              const SizedBox(width: 8),
              Text('Recent Updates',
                  style: AppTextStyles.font14SemiBold.copyWith(
                      color: AppColors.amber400)),
            ],
          ),
          const SizedBox(height: 12),
          ...updates.map((u) => _UpdateTile(update: u, colors: colors)),
        ],
      ),
    );
  }
}

class _UpdateTile extends StatelessWidget {
  final FlightUpdateModel update;
  final dynamic colors;

  const _UpdateTile({required this.update, required this.colors});

  @override
  Widget build(BuildContext context) {
    final field = update.field.split('.').last;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
              color: AppColors.amber300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${field[0].toUpperCase()}${field.substring(1)} updated',
                  style: AppTextStyles.font12Medium.copyWith(
                      color: AppColors.amber400),
                ),
                Text(
                  '${_trim(update.before)} → ${_trim(update.after)}',
                  style: AppTextStyles.font12Regular.copyWith(
                      color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _trim(String val) {
    try {
      final dt = DateTime.parse(val).toLocal();
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } catch (_) {
      return val;
    }
  }
}

// ── Track Bar ─────────────────────────────────────────────────────────────────

class _TrackBar extends StatelessWidget {
  final FlightModel flight;
  final bool isTracking;

  const _TrackBar({required this.flight, required this.isTracking});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final colors = context.customColors;

    return Container(
      padding: EdgeInsets.fromLTRB(rw(16), rh(12), rw(16), bottom + rh(12)),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: flight.isTracked
            ? _TrackedButtons(key: const ValueKey('tracked'), flight: flight, isLoading: isTracking)
            : _TrackButton(key: const ValueKey('untracked'), flight: flight, isLoading: isTracking),
      ),
    );
  }
}

class _TrackButton extends StatelessWidget {
  final FlightModel flight;
  final bool isLoading;
  const _TrackButton({super.key, required this.flight, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      text: 'flights.track_flight'.tr(),
      isLoading: isLoading,
      onPressed: () => context.read<FlightsCubit>().toggleTrack(flight),
      prefixIcon: const Icon(Icons.bookmark_border_rounded),
    );
  }
}

class _TrackedButtons extends StatelessWidget {
  final FlightModel flight;
  final bool isLoading;
  const _TrackedButtons({super.key, required this.flight, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextButton.outlined(
            text: 'flights.stop_tracking'.tr(),
            isLoading: isLoading,
            onPressed: () => context.read<FlightsCubit>().toggleTrack(flight),
            foregroundColor: AppColors.red200,
            borderColor: AppColors.red200,
            prefixIcon: const Icon(Icons.bookmark_remove_rounded),
          ),
        ),
        horizontalSpacing(12),
        Expanded(
          child: CustomTextButton(
            text: 'flights.view_tracked'.tr(),
            onPressed: () => Navigator.of(context, rootNavigator: true).push(
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
            prefixIcon: const Icon(Icons.track_changes_rounded),
          ),
        ),
      ],
    );
  }
}
