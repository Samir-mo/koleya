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
import 'package:gate_buddy/features/flights/data/models/flight_model.dart';
import 'package:gate_buddy/features/main_navigation/ui/main_scaffold.dart';
import 'package:gate_buddy/features/tracked_flight/logic/cubit/tracked_flight_cubit.dart';
import 'package:gate_buddy/features/tracked_flight/logic/cubit/tracked_flight_state.dart';
import 'package:get_it/get_it.dart';

class TrackedFlightScreen extends StatelessWidget {
  final FlightModel? flight;
  const TrackedFlightScreen({super.key, this.flight});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = GetIt.instance<TrackedFlightCubit>();
        if (flight != null) {
          cubit.setFlight(flight!);
        } else {
          cubit.loadAll();
        }
        return cubit;
      },
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrackedFlightCubit, TrackedFlightState>(
      listenWhen: (prev, curr) => curr.isCancelled && !prev.isCancelled,
      listener: (context, state) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('tracked_flight.cancelled'.tr()),
          backgroundColor: context.customColors.success,
          behavior: SnackBarBehavior.floating,
        ));
      },
      builder: (context, state) {
        if (state.isLoading) return const _LoadingView();
        if (state.isFailure) {
          return _ErrorView(
            error: state.error ?? 'errors.unknown'.tr(),
            onRetry: () => context.read<TrackedFlightCubit>().loadAll(),
          );
        }
        if (state.isSuccess && state.flight == null) {
          return const _NoTrackingView();
        }
        if (state.isSuccess || state.isCancelling) {
          return _DetailView(flight: state.flight!, state: state);
        }
        return const _LoadingView();
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Detail View
// ═══════════════════════════════════════════════════════════════════════════════

class _DetailView extends StatelessWidget {
  final FlightModel flight;
  final TrackedFlightState state;
  const _DetailView({required this.flight, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary200,
      body: CustomScrollView(
        slivers: [
          _AppBar(flight: flight),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(rw(16), rh(8), rw(16), rh(110)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RouteHero(flight: flight),
                  verticalSpacing(16),
                  _StatusCard(status: flight.status),
                  verticalSpacing(16),
                  _ScheduleRow(flight: flight),
                  verticalSpacing(16),
                  _DepartureCard(flight: flight),
                  verticalSpacing(16),
                  _ArrivalCard(flight: flight),
                  if (state.updates.isNotEmpty) ...[
                    verticalSpacing(16),
                    _UpdatesCard(updates: state.updates),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomBar(flight: flight),
    );
  }
}

// ─── App Bar ──────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  final FlightModel flight;
  const _AppBar({required this.flight});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: rh(220),
      pinned: true,
      backgroundColor: AppColors.primary300,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: EdgeInsets.all(rw(8)),
          child: CircleAvatar(
            backgroundColor: AppColors.white.withValues(alpha: 0.12),
            radius: rw(16),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.white, size: rw(14)),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: rw(16), top: rh(8), bottom: rh(8)),
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: rw(12), vertical: rh(6)),
            decoration: BoxDecoration(
              color: AppColors.secondary200.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(rr(20)),
              border: Border.all(
                  color: AppColors.secondary200.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bookmark_rounded,
                    size: rw(13), color: AppColors.secondary200),
                horizontalSpacing(5),
                Text('tracked_flight.tracking'.tr(),
                    style: AppTextStyles.font12Medium
                        .copyWith(color: AppColors.secondary200)),
              ],
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding:
            EdgeInsets.fromLTRB(rw(56), 0, rw(100), rh(14)),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(flight.flightNumber,
                style: AppTextStyles.font16Bold
                    .copyWith(color: AppColors.white)),
            Text(flight.airline.name,
                style: AppTextStyles.font12Regular
                    .copyWith(color: AppColors.primary50)),
          ],
        ),
        background: _AppBarBg(flight: flight),
      ),
    );
  }
}

class _AppBarBg extends StatelessWidget {
  final FlightModel flight;
  const _AppBarBg({required this.flight});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primary400,
            AppColors.primary300,
            AppColors.primary200,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -rw(40),
            top: -rw(40),
            child: Container(
              width: rw(200),
              height: rw(200),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            right: rw(10),
            top: rh(20),
            child: Container(
              width: rw(100),
              height: rw(100),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(rw(20)),
              child: Row(
                children: [
                  Container(
                    width: rw(68),
                    height: rw(68),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(rr(16)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(rr(15)),
                      child: flight.airline.logo.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: flight.airline.logo,
                              fit: BoxFit.contain,
                              errorWidget: (_, __, ___) => Icon(
                                Icons.flight,
                                color: AppColors.primary200,
                                size: rw(30),
                              ),
                            )
                          : Icon(Icons.flight,
                              color: AppColors.primary200, size: rw(30)),
                    ),
                  ),
                  horizontalSpacing(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(flight.airline.name,
                            style: AppTextStyles.font18Bold
                                .copyWith(color: AppColors.white)),
                        verticalSpacing(6),
                        Row(
                          children: [
                            _Badge(
                                label: flight.flightNumber,
                                color: AppColors.secondary200),
                            if (flight.type.isNotEmpty) ...[
                              horizontalSpacing(8),
                              _Badge(
                                  label: flight.type.toUpperCase(),
                                  color: AppColors.primary50),
                            ],
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

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(10), vertical: rh(3)),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(rr(6)),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          style: AppTextStyles.font12Medium.copyWith(color: color)),
    );
  }
}

// ─── Route Hero ───────────────────────────────────────────────────────────────

class _RouteHero extends StatelessWidget {
  final FlightModel flight;
  const _RouteHero({required this.flight});

  @override
  Widget build(BuildContext context) {
    final dep = flight.departure;
    final arr = flight.arrival;
    final depTime = dep.estimatedTime ?? dep.scheduledTime;
    final arrTime = arr.estimatedTime ?? arr.scheduledTime;

    return Container(
      padding: EdgeInsets.all(rw(20)),
      decoration: BoxDecoration(
        color: AppColors.primary300,
        borderRadius: BorderRadius.circular(rr(20)),
        border: Border.all(
            color: AppColors.primary100.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Departure
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(flight.route.fromCode,
                        style: AppTextStyles.font24Bold
                            .copyWith(color: AppColors.white)),
                    verticalSpacing(2),
                    Text(flight.route.from,
                        style: AppTextStyles.font12Regular
                            .copyWith(color: AppColors.primary50),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    if (depTime != null) ...[
                      verticalSpacing(6),
                      Text(formatHm(depTime),
                          style: AppTextStyles.font20Bold
                              .copyWith(color: AppColors.secondary200)),
                    ],
                  ],
                ),
              ),

              // Flight path center
              Padding(
                padding: EdgeInsets.symmetric(horizontal: rw(12)),
                child: Column(
                  children: [
                    _DashedLine(),
                    verticalSpacing(4),
                    Container(
                      width: rw(42),
                      height: rw(42),
                      decoration: BoxDecoration(
                        color: AppColors.secondary200,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondary200
                                .withValues(alpha: 0.35),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(Icons.flight_rounded,
                          color: AppColors.white, size: rw(22)),
                    ),
                    verticalSpacing(4),
                    _DashedLine(),
                  ],
                ),
              ),

              // Arrival
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(flight.route.toCode,
                        style: AppTextStyles.font24Bold
                            .copyWith(color: AppColors.white)),
                    verticalSpacing(2),
                    Text(flight.route.to,
                        style: AppTextStyles.font12Regular
                            .copyWith(color: AppColors.primary50),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end),
                    if (arrTime != null) ...[
                      verticalSpacing(6),
                      Text(formatHm(arrTime),
                          style: AppTextStyles.font20Bold
                              .copyWith(color: AppColors.white)),
                    ],
                  ],
                ),
              ),
            ],
          ),

          if (dep.gate != null ||
              dep.terminal != null ||
              arr.gate != null ||
              arr.terminal != null) ...[
            verticalSpacing(16),
            Divider(color: AppColors.primary100.withValues(alpha: 0.3)),
            verticalSpacing(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (dep.gate != null)
                  _QuickChip(
                      icon: Icons.door_sliding_outlined,
                      label: '${"flights.gate".tr()} ${dep.gate}',
                      sub: 'flights.departure'.tr()),
                if (dep.terminal != null)
                  _QuickChip(
                      icon: Icons.business_outlined,
                      label: 'T${dep.terminal}',
                      sub: 'flights.terminal'.tr()),
                if (arr.gate != null)
                  _QuickChip(
                      icon: Icons.door_sliding_outlined,
                      label: '${"flights.gate".tr()} ${arr.gate}',
                      sub: 'flights.arrival'.tr()),
                if (arr.terminal != null)
                  _QuickChip(
                      icon: Icons.business_outlined,
                      label: 'T${arr.terminal}',
                      sub: 'flights.terminal'.tr()),
              ],
            ),
          ],
        ],
      ),
    );
  }

}

class _DashedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: rw(28),
      height: 1,
      child: CustomPaint(painter: _DashPainter()),
    );
  }
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary100.withValues(alpha: 0.5)
      ..strokeWidth = 1.5;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + 4, 0), paint);
      x += 7;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _QuickChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  const _QuickChip(
      {required this.icon, required this.label, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: rw(14), color: AppColors.secondary200),
        verticalSpacing(3),
        Text(label,
            style: AppTextStyles.font14SemiBold
                .copyWith(color: AppColors.white)),
        Text(sub,
            style: AppTextStyles.font12Regular
                .copyWith(color: AppColors.primary50)),
      ],
    );
  }
}

// ─── Status Card ─────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  final String status;
  const _StatusCard({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final color = _statusColor(status, colors);
    final label = status.replaceAll('_', ' ');

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: rw(20), vertical: rh(14)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(rr(16)),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: rw(44),
            height: rw(44),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(flightStatusIcon(status), color: color, size: rw(22)),
          ),
          horizontalSpacing(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('tracked_flight.flight_status'.tr(),
                    style: AppTextStyles.font12Regular
                        .copyWith(color: AppColors.primary50)),
                Text(label,
                    style:
                        AppTextStyles.font18Bold.copyWith(color: color)),
              ],
            ),
          ),
          Container(
            width: rw(10),
            height: rw(10),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: color.withValues(alpha: 0.6),
                    blurRadius: 8,
                    spreadRadius: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Color _statusColor(String s, dynamic colors) {
    switch (s.toUpperCase()) {
      case 'ON_TIME':
      case 'LANDED':
        return colors.success as Color;
      case 'DELAYED':
        return colors.warning as Color;
      case 'CANCELLED':
        return colors.error as Color;
      case 'BOARDING':
      case 'SCHEDULED':
        return colors.info as Color;
      default:
        return AppColors.grey400;
    }
  }

}

// ─── Schedule Row ─────────────────────────────────────────────────────────────

class _ScheduleRow extends StatelessWidget {
  final FlightModel flight;
  const _ScheduleRow({required this.flight});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ScheduleCard(
            title: 'flights.departure'.tr(),
            icon: Icons.flight_takeoff_rounded,
            schedule: flight.departure,
          ),
        ),
        horizontalSpacing(12),
        Expanded(
          child: _ScheduleCard(
            title: 'flights.arrival'.tr(),
            icon: Icons.flight_land_rounded,
            schedule: flight.arrival,
          ),
        ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final FlightScheduleModel schedule;
  const _ScheduleCard(
      {required this.title, required this.icon, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(rw(14)),
      decoration: BoxDecoration(
        color: AppColors.primary300,
        borderRadius: BorderRadius.circular(rr(16)),
        border: Border.all(
            color: AppColors.primary100.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: rw(14), color: AppColors.secondary200),
              horizontalSpacing(6),
              Flexible(
                child: Text(title,
                    style: AppTextStyles.font12Medium
                        .copyWith(color: AppColors.primary50)),
              ),
            ],
          ),
          verticalSpacing(10),
          _TimeEntry(
            label: 'tracked_flight.scheduled'.tr(),
            value: formatHmOrDash(schedule.scheduledTime),
            highlight: false,
          ),
          if (schedule.estimatedTime != null) ...[
            verticalSpacing(6),
            _TimeEntry(
              label: 'tracked_flight.estimated'.tr(),
              value: formatHmOrDash(schedule.estimatedTime),
              highlight: true,
            ),
          ],
          if (schedule.actualTime != null) ...[
            verticalSpacing(6),
            _TimeEntry(
              label: 'tracked_flight.actual'.tr(),
              value: formatHmOrDash(schedule.actualTime),
              highlight: false,
            ),
          ],
          if (schedule.gate != null || schedule.terminal != null) ...[
            verticalSpacing(10),
            Wrap(
              spacing: rw(6),
              runSpacing: rh(6),
              children: [
                if (schedule.gate != null)
                  _MiniTag(
                      label: 'G${schedule.gate}',
                      color: AppColors.secondary200),
                if (schedule.terminal != null)
                  _MiniTag(
                      label: 'T${schedule.terminal}',
                      color: AppColors.primary50),
              ],
            ),
          ],
        ],
      ),
    );
  }

}

class _TimeEntry extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _TimeEntry(
      {required this.label, required this.value, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(label,
              style: AppTextStyles.font12Regular
                  .copyWith(color: AppColors.primary50)),
        ),
        Text(
          value,
          style: highlight
              ? AppTextStyles.font14Bold
                  .copyWith(color: AppColors.secondary200)
              : AppTextStyles.font14Regular
                  .copyWith(color: AppColors.white),
        ),
      ],
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String label;
  final Color color;
  const _MiniTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(8), vertical: rh(3)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(rr(6)),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: AppTextStyles.font12Medium.copyWith(color: color)),
    );
  }
}

// ─── Departure Card ───────────────────────────────────────────────────────────

class _DepartureCard extends StatelessWidget {
  final FlightModel flight;
  const _DepartureCard({required this.flight});

  @override
  Widget build(BuildContext context) {
    final dep = flight.departure;
    return _InfoCard(
      icon: Icons.flight_takeoff_rounded,
      title: 'tracked_flight.departure_info'.tr(),
      children: [
        _DetailRow(
            label: 'tracked_flight.scheduled'.tr(),
            value: formatHmDate(dep.scheduledTime)),
        if (dep.estimatedTime != null)
          _DetailRow(
              label: 'tracked_flight.estimated'.tr(),
              value: formatHmDate(dep.estimatedTime),
              highlight: true),
        if (dep.actualTime != null)
          _DetailRow(
              label: 'tracked_flight.actual'.tr(),
              value: formatHmDate(dep.actualTime)),
        if (dep.gate != null)
          _DetailRow(
              label: 'tracked_flight.gate'.tr(),
              value: dep.gate!,
              highlight: true),
        if (dep.terminal != null)
          _DetailRow(
              label: 'tracked_flight.terminal'.tr(),
              value: dep.terminal!),
      ],
    );
  }

}

// ─── Arrival Card ─────────────────────────────────────────────────────────────

class _ArrivalCard extends StatelessWidget {
  final FlightModel flight;
  const _ArrivalCard({required this.flight});

  @override
  Widget build(BuildContext context) {
    final arr = flight.arrival;
    return _InfoCard(
      icon: Icons.flight_land_rounded,
      title: 'flights.arrival'.tr(),
      children: [
        _DetailRow(
            label: 'tracked_flight.scheduled'.tr(),
            value: formatHmDate(arr.scheduledTime)),
        if (arr.estimatedTime != null)
          _DetailRow(
              label: 'tracked_flight.estimated'.tr(),
              value: formatHmDate(arr.estimatedTime),
              highlight: true),
        if (arr.actualTime != null)
          _DetailRow(
              label: 'tracked_flight.actual'.tr(),
              value: formatHmDate(arr.actualTime)),
        if (arr.gate != null)
          _DetailRow(
              label: 'tracked_flight.gate'.tr(),
              value: arr.gate!,
              highlight: true),
        if (arr.terminal != null)
          _DetailRow(
              label: 'tracked_flight.terminal'.tr(),
              value: arr.terminal!),
      ],
    );
  }

}

// ─── Updates Card ─────────────────────────────────────────────────────────────

class _UpdatesCard extends StatelessWidget {
  final List<FlightUpdateModel> updates;
  const _UpdatesCard({required this.updates});

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.update_rounded,
      title: 'tracked_flight.recent_updates'.tr(),
      iconColor: context.customColors.warning,
      children: updates.map((u) => _UpdateRow(update: u)).toList(),
    );
  }
}

class _UpdateRow extends StatelessWidget {
  final FlightUpdateModel update;
  const _UpdateRow({required this.update});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final field = update.field.split('.').last;
    final label = '${field[0].toUpperCase()}${field.substring(1)}';
    return Padding(
      padding: EdgeInsets.only(bottom: rh(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: rw(6),
            height: rw(6),
            margin: EdgeInsets.only(top: rh(5)),
            decoration: BoxDecoration(
                color: colors.warning, shape: BoxShape.circle),
          ),
          horizontalSpacing(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$label updated',
                    style: AppTextStyles.font12Medium
                        .copyWith(color: colors.warning)),
                Text('${_trim(update.before)} → ${_trim(update.after)}',
                    style: AppTextStyles.font12Regular
                        .copyWith(color: AppColors.primary50)),
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
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return val;
    }
  }
}

// ─── Shared Info Card shell ───────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;
  final Color? iconColor;
  const _InfoCard(
      {required this.icon,
      required this.title,
      required this.children,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    final accent = iconColor ?? AppColors.secondary200;
    return Container(
      padding: EdgeInsets.all(rw(16)),
      decoration: BoxDecoration(
        color: AppColors.primary300,
        borderRadius: BorderRadius.circular(rr(16)),
        border: Border.all(
            color: AppColors.primary100.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: rw(32),
                height: rw(32),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: rw(16), color: accent),
              ),
              horizontalSpacing(10),
              Text(title,
                  style: AppTextStyles.font16SemiBold
                      .copyWith(color: AppColors.white)),
            ],
          ),
          verticalSpacing(14),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _DetailRow(
      {required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: rh(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyles.font14Regular
                  .copyWith(color: AppColors.primary50)),
          Text(value,
              style: highlight
                  ? AppTextStyles.font14Bold
                      .copyWith(color: AppColors.secondary200)
                  : AppTextStyles.font14Regular
                      .copyWith(color: AppColors.white)),
        ],
      ),
    );
  }
}

// ─── Bottom Bar ───────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final FlightModel flight;
  const _BottomBar({required this.flight});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final colors = context.customColors;
    final isCancelling = context.select<TrackedFlightCubit, bool>(
        (c) => c.state.isCancelling);

    return Container(
      padding:
          EdgeInsets.fromLTRB(rw(16), rh(12), rw(16), bottom + rh(12)),
      decoration: BoxDecoration(
        color: AppColors.primary300,
        border: Border(
            top: BorderSide(
                color: AppColors.primary100.withValues(alpha: 0.25))),
      ),
      child: CustomTextButton.outlined(
        text: 'tracked_flight.cancel_tracking'.tr(),
        isLoading: isCancelling,
        foregroundColor: colors.error,
        borderColor: colors.error,
        onPressed:
            isCancelling ? null : () => _confirmCancel(context, flight.id),
        prefixIcon: const Icon(Icons.cancel_outlined),
      ),
    );
  }

  void _confirmCancel(BuildContext context, String flightId) {
    final colors = context.customColors;
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.primary300,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rr(16))),
        title: Text('tracked_flight.confirm_cancel_title'.tr(),
            style:
                AppTextStyles.font16Bold.copyWith(color: AppColors.white)),
        content: Text('tracked_flight.confirm_cancel_body'.tr(),
            style: AppTextStyles.font14Regular
                .copyWith(color: AppColors.primary50)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('common.cancel'.tr(),
                style: AppTextStyles.font14SemiBold
                    .copyWith(color: AppColors.primary50)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('tracked_flight.stop_tracking'.tr(),
                style: AppTextStyles.font14SemiBold
                    .copyWith(color: colors.error)),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        context.read<TrackedFlightCubit>().cancelTracking(flightId);
      }
    });
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Loading / Error / Empty states
// ═══════════════════════════════════════════════════════════════════════════════

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary200,
      appBar: AppBar(
        backgroundColor: AppColors.primary300,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(rw(8)),
            child: CircleAvatar(
              backgroundColor: AppColors.white.withValues(alpha: 0.12),
              radius: rw(16),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white, size: rw(14)),
            ),
          ),
        ),
        title: Text('tracked_flight.title'.tr(),
            style:
                AppTextStyles.font16Bold.copyWith(color: AppColors.white)),
      ),
      body: const Center(
        child: CircularProgressIndicator(color: AppColors.secondary200),
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
    return Scaffold(
      backgroundColor: AppColors.primary200,
      appBar: AppBar(
        backgroundColor: AppColors.primary300,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(rw(8)),
            child: CircleAvatar(
              backgroundColor: AppColors.white.withValues(alpha: 0.12),
              radius: rw(16),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white, size: rw(14)),
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(rw(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off_rounded,
                  size: rw(56),
                  color: AppColors.white.withValues(alpha: 0.3)),
              verticalSpacing(16),
              Text(error,
                  style: AppTextStyles.font14Regular
                      .copyWith(color: AppColors.primary50),
                  textAlign: TextAlign.center),
              verticalSpacing(24),
              CustomTextButton(
                text: 'errors.error_screen_button'.tr(),
                onPressed: onRetry,
                isFullWidth: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoTrackingView extends StatelessWidget {
  const _NoTrackingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary200,
      appBar: AppBar(
        backgroundColor: AppColors.primary300,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(rw(8)),
            child: CircleAvatar(
              backgroundColor: AppColors.white.withValues(alpha: 0.12),
              radius: rw(16),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white, size: rw(14)),
            ),
          ),
        ),
        title: Text('tracked_flight.title'.tr(),
            style:
                AppTextStyles.font16Bold.copyWith(color: AppColors.white)),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(rw(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: rw(90),
                height: rw(90),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.airplanemode_off_rounded,
                    size: rw(42),
                    color: AppColors.white.withValues(alpha: 0.3)),
              ),
              verticalSpacing(24),
              Text('tracked_flight.no_tracking'.tr(),
                  style: AppTextStyles.font18Bold
                      .copyWith(color: AppColors.white),
                  textAlign: TextAlign.center),
              verticalSpacing(10),
              Text('tracked_flight.no_tracking_hint'.tr(),
                  style: AppTextStyles.font14Regular
                      .copyWith(color: AppColors.primary50),
                  textAlign: TextAlign.center),
              verticalSpacing(32),
              CustomTextButton(
                text: 'tracked_flight.find_flight'.tr(),
                isFullWidth: false,
                onPressed: () =>
                    MainScaffold.jumpToTab(MainScaffold.tabFlights),
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
