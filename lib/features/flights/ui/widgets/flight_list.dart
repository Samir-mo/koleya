import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/core/widgets/custom_text_button.dart';
import 'package:gate_buddy/core/widgets/empty_state.dart';
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
      return EmptyState(
        icon: Icons.flight_rounded,
        title: 'flights.empty_title'.tr(),
        description: emptyMessage,
      );
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
          Icon(
            Icons.wifi_off_rounded,
            size: rw(56),
            color: colors.iconSecondary,
          ),
          verticalSpacing(16),
          Text(
            'flights.failed_load'.tr(),
            style: AppTextStyles.font16SemiBold.copyWith(
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          verticalSpacing(8),
          CustomTextButton.text(
            text: 'errors.error_screen_button'.tr(),
            onPressed: onRetry,
            size: CustomButtonSize.small,
            isFullWidth: false,
          ),
        ],
      ),
    );
  }
}
