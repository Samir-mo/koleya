import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/flights/data/models/flight_model.dart';
import 'package:gate_buddy/features/flights/logic/cubit/flights_cubit.dart';
import 'package:gate_buddy/features/flights/logic/cubit/flights_state.dart';
import 'package:gate_buddy/features/flights/ui/flight_details_screen.dart';
import 'package:gate_buddy/features/flights/ui/widgets/flight_card.dart';
import 'package:gate_buddy/features/flights/ui/widgets/flight_card_shimmer.dart';

class FlightList extends StatelessWidget {
  final List<FlightModel> flights;
  final FlightsStatus status;
  final String emptyMessage;

  const FlightList({
    super.key,
    required this.flights,
    required this.status,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (status == FlightsStatus.loading && flights.isEmpty) {
      return ListView.builder(
        padding: EdgeInsets.all(rw(16)),
        itemCount: 5,
        itemBuilder: (_, __) => const FlightCardShimmer(),
      );
    }

    if (status == FlightsStatus.failure && flights.isEmpty) {
      return _ErrorState(
        onRetry: () => context.read<FlightsCubit>().loadFlights(),
      );
    }

    if (flights.isEmpty) {
      return _EmptyState(message: emptyMessage);
    }

    return RefreshIndicator(
      color: AppColors.primary200,
      onRefresh: () => context.read<FlightsCubit>().loadFlights(),
      child: ListView.builder(
        padding: EdgeInsets.all(rw(16)),
        itemCount: flights.length,
        itemBuilder: (_, i) => FlightCard(
          flight: flights[i],
          onTap: () {
            final cubit = context.read<FlightsCubit>();
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: FlightDetailsScreen(flight: flights[i]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.flight_rounded,
              color: AppColors.primary200,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Flights Found',
            style: AppTextStyles.font18Bold.copyWith(
              color: AppColors.primary200,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14Regular.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 56,
            color: AppColors.grey300,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load flights',
            style: AppTextStyles.font16SemiBold.copyWith(
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: AppTextStyles.font14SemiBold.copyWith(
                color: AppColors.primary200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
