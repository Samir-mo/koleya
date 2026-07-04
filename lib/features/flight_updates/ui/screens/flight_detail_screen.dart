import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/helpers/flight_time_helpers.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../core/widgets/flight_status_badge.dart';
import '../../../flights/data/models/flight_model.dart';
import '../../../home/ui/widgets/flight_update_entry_card.dart';

class FlightDetailScreen extends StatelessWidget {
  final String flightId;
  final FlightModel? flight;

  const FlightDetailScreen({
    super.key,
    required this.flightId,
    this.flight,
  });

  @override
  Widget build(BuildContext context) {
    if (flight == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary300,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.white,
              size: rw(18),
            ),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.secondary200,
          ),
        ),
      );
    }

    return _DetailView(flight: flight!);
  }
}

class _DetailView extends StatefulWidget {
  final FlightModel flight;
  const _DetailView({required this.flight});

  @override
  State<_DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<_DetailView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final flight = widget.flight;

    return Scaffold(
      backgroundColor: AppColors.primary200,
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────
          _Header(flight: flight),

          // ── Tabs ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.primary300,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.secondary200,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.primary50,
                labelStyle: AppTextStyles.font14SemiBold,
                tabs: [
                  Tab(text: 'flight_updates.departure'.tr()),
                  Tab(text: 'flight_updates.arrival'.tr()),
                  Tab(text: 'flight_updates.updates_history'.tr()),
                ],
              ),
            ),
          ),

          // ── Tab Views ────────────────────────────────────────────
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: colors.background,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _DepartureTab(flight: flight),
                  _ArrivalTab(flight: flight),
                  _UpdatesTab(flight: flight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final FlightModel flight;
  const _Header({required this.flight});

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
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.white,
              size: rw(14),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.fromLTRB(rw(56), 0, rw(100), rh(14)),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              flight.flightNumber,
              style: AppTextStyles.font16Bold.copyWith(
                color: AppColors.white,
              ),
            ),
            Text(
              flight.airline.name,
              style: AppTextStyles.font12Regular.copyWith(
                color: AppColors.primary50,
              ),
            ),
          ],
        ),
        background: _Background(flight: flight),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final FlightModel flight;
  const _Background({required this.flight});

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
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(rw(20)),
              child: Row(
                children: [
                  Container(
                    width: rw(60),
                    height: rw(60),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(rr(12)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(rr(11)),
                      child: flight.airline.logo.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: flight.airline.logo,
                              fit: BoxFit.contain,
                              errorWidget: (_, __, ___) => Icon(
                                Icons.flight,
                                color: AppColors.primary200,
                                size: rw(28),
                              ),
                            )
                          : Icon(
                              Icons.flight,
                              color: AppColors.primary200,
                              size: rw(28),
                            ),
                    ),
                  ),
                  horizontalSpacing(14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${flight.route.fromCode} → ${flight.route.toCode}',
                          style: AppTextStyles.font16Bold.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        verticalSpacing(4),
                        Text(
                          '${flight.route.from} → ${flight.route.to}',
                          style: AppTextStyles.font12Regular.copyWith(
                            color: AppColors.primary50,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        verticalSpacing(8),
                        FlightStatusBadge(status: flight.status),
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

class _DepartureTab extends StatelessWidget {
  final FlightModel flight;
  const _DepartureTab({required this.flight});

  @override
  Widget build(BuildContext context) {
    final dep = flight.departure;
    return SingleChildScrollView(
      padding: EdgeInsets.all(rw(20)),
      child: _InfoCard(
        title: 'flight_updates.departure_info'.tr(),
        icon: Icons.flight_takeoff_rounded,
        children: [
          _DetailRow(
            label: 'flight_updates.scheduled'.tr(),
            value: formatHmDate(dep.scheduledTime),
          ),
          if (dep.estimatedTime != null)
            _DetailRow(
              label: 'flight_updates.estimated'.tr(),
              value: formatHmDate(dep.estimatedTime),
              highlight: true,
            ),
          if (dep.actualTime != null)
            _DetailRow(
              label: 'flight_updates.actual'.tr(),
              value: formatHmDate(dep.actualTime),
            ),
          if (dep.gate != null)
            _DetailRow(
              label: 'flight_updates.gate'.tr(),
              value: dep.gate!,
              highlight: true,
            ),
          if (dep.terminal != null)
            _DetailRow(
              label: 'flight_updates.terminal'.tr(),
              value: dep.terminal!,
            ),
        ],
      ),
    );
  }
}

class _ArrivalTab extends StatelessWidget {
  final FlightModel flight;
  const _ArrivalTab({required this.flight});

  @override
  Widget build(BuildContext context) {
    final arr = flight.arrival;
    return SingleChildScrollView(
      padding: EdgeInsets.all(rw(20)),
      child: _InfoCard(
        title: 'flight_updates.arrival_info'.tr(),
        icon: Icons.flight_land_rounded,
        children: [
          _DetailRow(
            label: 'flight_updates.scheduled'.tr(),
            value: formatHmDate(arr.scheduledTime),
          ),
          if (arr.estimatedTime != null)
            _DetailRow(
              label: 'flight_updates.estimated'.tr(),
              value: formatHmDate(arr.estimatedTime),
              highlight: true,
            ),
          if (arr.actualTime != null)
            _DetailRow(
              label: 'flight_updates.actual'.tr(),
              value: formatHmDate(arr.actualTime),
            ),
          if (arr.gate != null)
            _DetailRow(
              label: 'flight_updates.gate'.tr(),
              value: arr.gate!,
              highlight: true,
            ),
          if (arr.terminal != null)
            _DetailRow(
              label: 'flight_updates.terminal'.tr(),
              value: arr.terminal!,
            ),
        ],
      ),
    );
  }
}

class _UpdatesTab extends StatelessWidget {
  final FlightModel flight;
  const _UpdatesTab({required this.flight});

  @override
  Widget build(BuildContext context) {
    if (flight.updates.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(rw(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: rw(56),
                color: AppColors.primary200,
              ),
              verticalSpacing(16),
              Text(
                'flight_updates.no_updates_yet'.tr(),
                style: AppTextStyles.font14Regular.copyWith(
                  color: context.customColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(rw(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...flight.updates.map(
            (u) => Padding(
              padding: EdgeInsets.only(bottom: rh(10)),
              child: FlightUpdateEntryCard(update: u),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(rw(16)),
      decoration: BoxDecoration(
        color: AppColors.primary300,
        borderRadius: BorderRadius.circular(rr(16)),
        border: Border.all(color: AppColors.primary100.withValues(alpha: 0.25)),
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
                  color: AppColors.secondary200.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: rw(16),
                  color: AppColors.secondary200,
                ),
              ),
              horizontalSpacing(10),
              Text(
                title,
                style: AppTextStyles.font16SemiBold.copyWith(
                  color: AppColors.white,
                ),
              ),
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

  const _DetailRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: rh(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.font12Regular.copyWith(
              color: AppColors.primary50,
            ),
          ),
          Text(
            value,
            style: highlight
                ? AppTextStyles.font12Bold.copyWith(
                    color: AppColors.secondary200,
                  )
                : AppTextStyles.font12Regular.copyWith(
                    color: AppColors.white,
                  ),
          ),
        ],
      ),
    );
  }
}
