import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import '../../data/models/flight_model.dart';
import '../../logic/cubit/flights_cubit.dart';

class FlightCard extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback? onTap;

  const FlightCard({super.key, required this.flight, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final isTracking = context.select<FlightsCubit, bool>(
      (c) => c.state.trackingFlightId == flight.id,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14),
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
            // ── Status bar ──────────────────────────────────────────────────
            Container(
              height: 5,
              decoration: BoxDecoration(
                color: _statusColor(flight.status),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // ── Row 1: Airline + track button ────────────────────────
                  Row(
                    children: [
                      _AirlineLogo(logoUrl: flight.airline.logo),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              flight.airline.name,
                              style: AppTextStyles.font14SemiBold.copyWith(
                                color: colors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              flight.flightNumber,
                              style: AppTextStyles.font12Regular.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _StatusBadge(status: flight.status),
                      const SizedBox(width: 8),
                      _TrackButton(
                        flight: flight,
                        isLoading: isTracking,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Row 2: Route ─────────────────────────────────────────
                  _RouteRow(flight: flight, colors: colors),

                  const SizedBox(height: 12),

                  // ── Row 3: Gate / Terminal / Type ────────────────────────
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.door_front_door_outlined,
                        label:
                            'Gate ${flight.departure.gate ?? flight.arrival.gate ?? '—'}',
                        colors: colors,
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.business_outlined,
                        label:
                            'T${flight.departure.terminal ?? flight.arrival.terminal ?? '—'}',
                        colors: colors,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          flight.type.toUpperCase(),
                          style: AppTextStyles.font12Regular.copyWith(
                            color: AppColors.primary200,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Updates badge ────────────────────────────────────────
                  if (flight.updates.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _UpdatesBadge(update: flight.updates.first),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ON_TIME':
        return AppColors.green200;
      case 'DELAYED':
        return AppColors.amber200;
      case 'CANCELLED':
        return AppColors.red200;
      case 'BOARDING':
        return AppColors.blue200;
      case 'DEPARTED':
        return AppColors.grey400;
      case 'LANDED':
        return AppColors.success;
      default:
        return AppColors.grey300;
    }
  }
}

// ── Airline Logo ─────────────────────────────────────────────────────────────

class _AirlineLogo extends StatelessWidget {
  final String logoUrl;
  const _AirlineLogo({required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: logoUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: logoUrl,
                fit: BoxFit.contain,
                errorWidget: (_, __, ___) => const Icon(
                  Icons.flight,
                  color: AppColors.grey400,
                  size: 22,
                ),
              )
            : const Icon(Icons.flight, color: AppColors.grey400, size: 22),
      ),
    );
  }
}

// ── Status Badge ─────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = FlightCard._statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            _label(status),
            style: AppTextStyles.font12Bold.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  String _label(String s) => s.replaceAll('_', ' ');
}

// ── Track Button ─────────────────────────────────────────────────────────────

class _TrackButton extends StatelessWidget {
  final FlightModel flight;
  final bool isLoading;
  const _TrackButton({required this.flight, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () => context.read<FlightsCubit>().toggleTrack(flight),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: flight.isTracked
              ? AppColors.primary200
              : AppColors.primary50,
          shape: BoxShape.circle,
        ),
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary200,
                ),
              )
            : Icon(
                flight.isTracked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                size: 16,
                color: flight.isTracked
                    ? AppColors.white
                    : AppColors.primary200,
              ),
      ),
    );
  }
}

// ── Route Row ────────────────────────────────────────────────────────────────

String _formatTime(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

class _RouteRow extends StatelessWidget {
  final FlightModel flight;
  final dynamic colors;
  const _RouteRow({required this.flight, required this.colors});

  @override
  Widget build(BuildContext context) {
    final depTime = flight.departure.estimatedTime ??
        flight.departure.scheduledTime;
    final arrTime = flight.arrival.estimatedTime ??
        flight.arrival.scheduledTime;

    return Row(
      children: [
        // From
        _TimeBlock(
          code: flight.route.fromCode,
          time: depTime != null ? _formatTime(depTime) : '—',
          label: 'Departure',
          colors: colors,
          align: CrossAxisAlignment.start,
        ),

        // Arrow / duration
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.grey200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.flight,
                      size: 16,
                      color: AppColors.secondary200,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.grey200,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                flight.direction == 'departure' ? 'Departure' : 'Arrival',
                style: AppTextStyles.font12Regular.copyWith(
                  color: colors.textHint,
                ),
              ),
            ],
          ),
        ),

        // To
        _TimeBlock(
          code: flight.route.toCode,
          time: arrTime != null ? _formatTime(arrTime) : '—',
          label: 'Arrival',
          colors: colors,
          align: CrossAxisAlignment.end,
        ),
      ],
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final String code;
  final String time;
  final String label;
  final dynamic colors;
  final CrossAxisAlignment align;

  const _TimeBlock({
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
        Text(
          code,
          style: AppTextStyles.font18Bold.copyWith(
            color: AppColors.primary200,
          ),
        ),
        Text(
          time,
          style: AppTextStyles.font14SemiBold.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Info Chip ────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final dynamic colors;
  const _InfoChip({required this.icon, required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: colors.iconSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.font12Regular.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Updates Badge ────────────────────────────────────────────────────────────

class _UpdatesBadge extends StatelessWidget {
  final FlightUpdateModel update;
  const _UpdatesBadge({required this.update});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.amber0,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.amber100),
      ),
      child: Row(
        children: [
          const Icon(Icons.update_rounded, size: 14, color: AppColors.amber300),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '${update.field.split('.').last} updated',
              style: AppTextStyles.font12Regular.copyWith(
                color: AppColors.amber400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
