import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/utils/spacing.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_screen.dart';
import '../../../core/widgets/loading_shimmer.dart';
import '../logic/cubit/services_category_cubit.dart';
import '../logic/cubit/services_category_state.dart';
import 'widgets/service_list_item.dart';

class ServicesCategoryScreen extends StatelessWidget {
  final String category;

  const ServicesCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: _titleFor(category),
            leading: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.white,
            ),
            onLeadingPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: BlocBuilder<ServicesCategoryCubit, ServicesCategoryState>(
              builder: (context, state) {
                if (state.isLoading) return _LoadingView();
                if (state.isFailure) {
                  return ErrorScreen(
                    error: state.error,
                    onRetry: () =>
                        context.read<ServicesCategoryCubit>().refresh(),
                  );
                }
                if (state.isSuccess && state.services.isEmpty) {
                  return EmptyState(
                    icon: _iconFor(category),
                    title: 'services_category.empty_title'.tr(),
                    description: 'services_category.empty_description'.tr(),
                  );
                }
                if (state.isSuccess) {
                  return RefreshIndicator(
                    color: AppColors.primary200,
                    onRefresh: () =>
                        context.read<ServicesCategoryCubit>().refresh(),
                    child: ListView.separated(
                      padding: EdgeInsets.all(rw(16)),
                      itemCount: state.services.length,
                      separatorBuilder: (_, __) => verticalSpacing(12),
                      itemBuilder: (_, i) =>
                          ServiceListItem(service: state.services[i]),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(rw(16)),
      itemCount: 6,
      separatorBuilder: (_, __) => verticalSpacing(12),
      itemBuilder: (_, __) =>
          LoadingShimmer.card(width: double.infinity, height: rh(110)),
    );
  }
}

String _titleFor(String category) => switch (category) {
  'RESTAURANTS' => 'services_category.title_restaurants'.tr(),
  'SHOPS' => 'services_category.title_shops'.tr(),
  'VIP_SERVICES' => 'services_category.title_vip'.tr(),
  'FINANCIAL' => 'services_category.title_financial'.tr(),
  'COUNTERS' => 'services_category.title_counters'.tr(),
  'ACCESSIBILITY' => 'services_category.title_accessibility'.tr(),
  _ => category,
};

IconData _iconFor(String category) => switch (category) {
  'RESTAURANTS' => Icons.restaurant_outlined,
  'SHOPS' => Icons.shopping_bag_outlined,
  'VIP_SERVICES' => Icons.star_outline_rounded,
  'FINANCIAL' => Icons.account_balance_outlined,
  'COUNTERS' => Icons.confirmation_number_outlined,
  'ACCESSIBILITY' => Icons.accessible_outlined,
  _ => Icons.storefront_outlined,
};
