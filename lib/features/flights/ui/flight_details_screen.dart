import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/helpers/flight_status_helpers.dart';
import 'package:gate_buddy/core/utils/helpers/flight_time_helpers.dart';
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
                  verticalSpacing(16),
                  _RouteCard(flight: flight, colors: colors),
                  verticalSpacing(16),
                  _ScheduleSection(
                    title: 'flights.departure'.tr(),
                    icon: Icons.flight_takeoff_rounded,
                    schedule: flight.departure,
                    colors: colors,
                  ),
                  verticalSpacing(12),
                  _ScheduleSection(
                    title: 'flights.arrival'.tr(),
                    icon: Icons.flight_land_rounded,
                    schedule: flight.arrival,
                    colors: colors,
                  ),
                  if (flight.updates.isNotEmpty) ...[
                    verticalSpacing(16),
                    _UpdatesSection(updates: flight.updates, colors: colors),
                  ],
                  verticalSpacing(100),
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
        child: Padding(
          padding: EdgeInsets.all(rw(8)),
          child: CircleAvatar(
            backgroundColor: AppColors.primary300,
            radius: rr(16),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.white, size: rw(14)),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: _AppBarBackground(flight: flight),
        titlePadding: EdgeInsets.fromLTRB(rw(56), 0, rw(16), rh(14)),
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
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.flight_rounded,
              size: rw(160),
              color: AppColors.primary300.withValues(alpha: 0.4),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(rw(20)),
              child: Row(
                children: [
                  Container(
                    width: rw(64),
                    height: rw(64),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(rr(14)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(rr(13)),
                      child: flight.airline.logo.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: flight.airline.logo,
                              fit: BoxFit.contain,
                              errorWidget: (_, __, ___) => Icon(
                                Icons.flight,
                                color: AppColors.grey400,
                                size: rw(28),
                              ),
                            )
                          : Icon(Icons.flight,
                              color: AppColors.grey400, size: rw(28)),
                    ),
                  ),
                  horizontalSpacing(16),
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
                        verticalSpacing(4),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: rw(8), vertical: rh(3)),
                              decoration: BoxDecoration(
                                color: AppColors.primary300,
                                borderRadius: BorderRadius.circular(rr(6)),
                              ),
                              child: Text(
                                flight.flightNumber,
                                style: AppTextStyles.font12Medium.copyWith(
                                  color: AppColors.secondary200,
                                ),
                              ),
                            ),
                            horizontalSpacing(8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: rw(8), vertical: rh(3)),
                              decoration: BoxDecoration(
                                color: AppColors.primary300,
                                borderRadius: BorderRadius.circular(rr(6)),
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
    final color = flightStatusColor(flight.status);
    final label = flight.status.replaceAll('_', ' ');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: rw(20), vertical: rh(16)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(rr(14)),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: rw(44),
            height: rw(44),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(flightStatusIcon(flight.status), color: color, size: rw(22)),
          ),
          horizontalSpacing(14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'flights.flight_status'.tr(),
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
            width: rw(10),
            height: rw(10),
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
      padding: EdgeInsets.all(rw(20)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(16)),
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
              _AirportBlock(
                code: flight.route.fromCode,
                time: formatHmOrDash(dep.estimatedTime ?? dep.scheduledTime),
                label: dep.terminal != null
                    ? '${'flights.terminal'.tr()} ${dep.terminal}'
                    : '',
                colors: colors,
                align: CrossAxisAlignment.start,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: rh(10)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _DashedLine()),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: rw(8)),
                            child: Container(
                              width: rw(36),
                              height: rw(36),
                              decoration: const BoxDecoration(
                                color: AppColors.secondary200,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.flight_rounded,
                                  color: AppColors.white, size: rw(18)),
                            ),
                          ),
                          Expanded(child: _DashedLine()),
                        ],
                      ),
                      verticalSpacing(4),
                      Text(
                        flight.direction == 'departure'
                            ? 'flights.departure'.tr()
                            : 'flights.arrival'.tr(),
                        style: AppTextStyles.font12Regular.copyWith(
                          color: colors.textHint,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              _AirportBlock(
                code: flight.route.toCode,
                time: formatHmOrDash(arr.estimatedTime ?? arr.scheduledTime),
                label: arr.terminal != null
                    ? '${'flights.terminal'.tr()} ${arr.terminal}'
                    : '',
                colors: colors,
                align: CrossAxisAlignment.end,
              ),
            ],
          ),

          verticalSpacing(16),
          Divider(color: colors.divider),
          verticalSpacing(12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _QuickInfo(
                icon: Icons.door_front_door_outlined,
                label: 'flights.dep_gate'.tr(),
                value: dep.gate ?? '—',
                colors: colors,
              ),
              _Divider(),
              _QuickInfo(
                icon: Icons.business_outlined,
                label: 'flights.dep_terminal'.tr(),
                value: dep.terminal ?? '—',
                colors: colors,
              ),
              _Divider(),
              _QuickInfo(
                icon: Icons.door_front_door_outlined,
                label: 'flights.arr_gate'.tr(),
                value: arr.gate ?? '—',
                colors: colors,
              ),
            ],
          ),
        ],
      ),
    );
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
        Icon(icon, size: rw(18), color: AppColors.primary200),
        verticalSpacing(4),
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
    return Container(
        width: 1, height: rh(40), color: context.customColors.divider);
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
      padding: EdgeInsets.all(rw(16)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(14)),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: rw(32),
                height: rw(32),
                decoration: const BoxDecoration(
                  color: AppColors.primary50,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: rw(16), color: AppColors.primary200),
              ),
              horizontalSpacing(10),
              Text(title,
                  style: AppTextStyles.font16SemiBold.copyWith(
                      color: colors.textPrimary)),
            ],
          ),
          verticalSpacing(14),
          _TimeRow(
            label: 'flights.scheduled'.tr(),
            time: schedule.scheduledTime,
            colors: colors,
            isHighlighted: false,
          ),
          if (schedule.estimatedTime != null) ...[
            verticalSpacing(8),
            _TimeRow(
              label: 'flights.estimated'.tr(),
              time: schedule.estimatedTime,
              colors: colors,
              isHighlighted: true,
            ),
          ],
          if (schedule.actualTime != null) ...[
            verticalSpacing(8),
            _TimeRow(
              label: 'flights.actual'.tr(),
              time: schedule.actualTime,
              colors: colors,
              isHighlighted: false,
            ),
          ],
          if (schedule.gate != null || schedule.terminal != null) ...[
            verticalSpacing(12),
            Divider(color: colors.divider),
            verticalSpacing(10),
            Row(
              children: [
                if (schedule.gate != null)
                  _InfoTag(
                    label: '${'flights.gate'.tr()} ${schedule.gate}',
                    color: AppColors.secondary200,
                  ),
                if (schedule.gate != null && schedule.terminal != null)
                  horizontalSpacing(8),
                if (schedule.terminal != null)
                  _InfoTag(
                    label: '${'flights.terminal'.tr()} ${schedule.terminal}',
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
    final formatted = formatHmDate(time);
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

}

class _InfoTag extends StatelessWidget {
  final String label;
  final Color color;
  const _InfoTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(12), vertical: rh(5)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(rr(8)),
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
      padding: EdgeInsets.all(rw(16)),
      decoration: BoxDecoration(
        color: AppColors.amber0,
        borderRadius: BorderRadius.circular(rr(14)),
        border: Border.all(color: AppColors.amber100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.update_rounded, size: rw(18), color: AppColors.amber300),
              horizontalSpacing(8),
              Text('flights.recent_updates'.tr(),
                  style: AppTextStyles.font14SemiBold.copyWith(
                      color: AppColors.amber400)),
            ],
          ),
          verticalSpacing(12),
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
    final fieldLabel = '${field[0].toUpperCase()}${field.substring(1)} updated';
    return Padding(
      padding: EdgeInsets.only(bottom: rh(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: rw(6),
            height: rw(6),
            margin: EdgeInsets.only(top: rh(5)),
            decoration: const BoxDecoration(
              color: AppColors.amber300,
              shape: BoxShape.circle,
            ),
          ),
          horizontalSpacing(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fieldLabel,
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
            ? _TrackedButtons(
                key: const ValueKey('tracked'),
                flight: flight,
                isLoading: isTracking)
            : _TrackButton(
                key: const ValueKey('untracked'),
                flight: flight,
                isLoading: isTracking),
      ),
    );
  }
}

class _TrackButton extends StatelessWidget {
  final FlightModel flight;
  final bool isLoading;
  const _TrackButton(
      {super.key, required this.flight, required this.isLoading});

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
  const _TrackedButtons(
      {super.key, required this.flight, required this.isLoading});

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
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).push(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    TrackedFlightScreen(flight: flight),
                transitionsBuilder: (_, animation, __, child) =>
                    SlideTransition(
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
