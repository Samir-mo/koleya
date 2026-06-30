import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/utils/extensions/context_ext.dart';
import '../../../core/utils/spacing.dart';
import '../../../core/widgets/custom_text_button.dart';
import '../logic/explore_cubit.dart';
import '../logic/explore_state.dart';
import 'widgets/featured_place_card.dart';
import 'widgets/place_card.dart';
import 'widgets/service_type_chip.dart';

class ExplorePlacesScreen extends StatefulWidget {
  const ExplorePlacesScreen({super.key});

  @override
  State<ExplorePlacesScreen> createState() => _ExplorePlacesScreenState();
}

class _ExplorePlacesScreenState extends State<ExplorePlacesScreen> {
  final _searchController = TextEditingController();
  bool _showSearch = false;

  // Values must match the backend's 'category' field exactly (uppercase)
  late final _types = [
    (
      label: 'explore_places.category_all'.tr(),
      value: null,
      icon: Icons.grid_view_rounded,
    ),
    (
      label: 'explore_places.category_restaurants'.tr(),
      value: 'RESTAURANTS',
      icon: Icons.restaurant_rounded,
    ),
    (
      label: 'explore_places.category_shops'.tr(),
      value: 'SHOPS',
      icon: Icons.shopping_bag_rounded,
    ),
    (
      label: 'explore_places.category_vip'.tr(),
      value: 'VIP_SERVICES',
      icon: Icons.stars_rounded,
    ),
    (
      label: 'explore_places.category_financial'.tr(),
      value: 'FINANCIAL',
      icon: Icons.account_balance_rounded,
    ),
    (
      label: 'explore_places.category_counters'.tr(),
      value: 'COUNTERS',
      icon: Icons.confirmation_number_rounded,
    ),
    (
      label: 'explore_places.category_accessibility'.tr(),
      value: 'ACCESSIBILITY',
      icon: Icons.accessibility_new_rounded,
    ),
  ];

  late final _financialSubCategories = [
    (label: 'explore_places.financial_all'.tr(), value: null),
    (label: 'explore_places.financial_atms'.tr(), value: 'ATMs'),
    (
      label: 'explore_places.financial_currency_exchange'.tr(),
      value: 'Currency Exchange',
    ),
    (label: 'explore_places.financial_insurance'.tr(), value: 'Insurance'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: BlocBuilder<ExploreCubit, ExploreState>(
              builder: (context, state) {
                if (state is ExploreLoading) return _buildLoading();
                if (state is ExploreError) return _buildError(context, state);
                if (state is ExploreLoaded)
                  return _buildContent(context, state);
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: rw(20),
                vertical: rh(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'explore_places.title'.tr(),
                          style: AppTextStyles.font20Bold.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        verticalSpacing(2),
                        Text(
                          'explore_places.subtitle'.tr(),
                          style: AppTextStyles.font12Regular.copyWith(
                            color: AppColors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _showSearch = !_showSearch);
                      if (!_showSearch) {
                        _searchController.clear();
                        context.read<ExploreCubit>().onSearchChanged('');
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(rr(10)),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(rr(12)),
                      ),
                      child: Icon(
                        _showSearch ? Icons.close : Icons.search_rounded,
                        color: AppColors.white,
                        size: rr(22),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _showSearch
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(rw(16), 0, rw(16), rh(16)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(rr(14)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          style: AppTextStyles.font14Regular,
                          decoration: InputDecoration(
                            hintText: 'explore_places.search_placeholder'.tr(),
                            hintStyle: AppTextStyles.font14Regular.copyWith(
                              color: AppColors.grey400,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: AppColors.grey400,
                              size: rr(20),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: rh(14),
                            ),
                          ),
                          onChanged: (q) =>
                              context.read<ExploreCubit>().onSearchChanged(q),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ExploreLoaded state) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildTypeFilter(context, state)),

        if (state.searchQuery.isEmpty && state.topRated.isNotEmpty)
          SliverToBoxAdapter(child: _buildFeaturedSection(context, state)),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(rw(20), rh(20), rw(20), rh(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _sectionTitle(state),
                  style: AppTextStyles.font16Bold.copyWith(
                    color: context.customColors.textPrimary,
                  ),
                ),
                if (state.isSearching)
                  SizedBox(
                    width: rr(16),
                    height: rr(16),
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
        ),

        if (state.displayedPlaces.isEmpty)
          SliverToBoxAdapter(child: _buildEmpty(context))
        else
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: rw(20)),
            sliver: SliverList.builder(
              itemCount: state.displayedPlaces.length,
              itemBuilder: (_, i) => PlaceCard(place: state.displayedPlaces[i]),
            ),
          ),

        SliverToBoxAdapter(child: verticalSpacing(100)),
      ],
    );
  }

  Widget _buildTypeFilter(BuildContext context, ExploreLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: rh(52),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(8)),
            itemCount: _types.length,
            itemBuilder: (_, i) {
              final t = _types[i];
              return ServiceTypeChip(
                label: t.label,
                icon: t.icon,
                isSelected: state.selectedType == t.value,
                onTap: () {
                  context.read<ExploreCubit>().selectType(t.value);
                  _searchController.clear();
                  setState(() => _showSearch = false);
                },
              );
            },
          ),
        ),
        if (state.selectedType == 'FINANCIAL')
          _buildSubCategoryRow(context, state),
      ],
    );
  }

  Widget _buildSubCategoryRow(BuildContext context, ExploreLoaded state) {
    final colors = context.customColors;
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: Container(
        color: colors.backgroundSecondary,
        child: SizedBox(
          height: rh(44),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(6)),
            itemCount: _financialSubCategories.length,
            itemBuilder: (_, i) {
              final sub = _financialSubCategories[i];
              final isSelected = state.selectedSubCategory == sub.value;
              return GestureDetector(
                onTap: () =>
                    context.read<ExploreCubit>().selectSubCategory(sub.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: EdgeInsets.only(right: rw(8)),
                  padding: EdgeInsets.symmetric(
                    horizontal: rw(14),
                    vertical: rh(6),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondary200 : colors.surface,
                    borderRadius: BorderRadius.circular(rr(20)),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondary200
                          : colors.border,
                    ),
                  ),
                  child: Text(
                    sub.label,
                    style:
                        (isSelected
                                ? AppTextStyles.font12Bold
                                : AppTextStyles.font12Medium)
                            .copyWith(
                              color: isSelected
                                  ? AppColors.white
                                  : colors.textPrimary,
                            ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(BuildContext context, ExploreLoaded state) {
    return Padding(
      padding: EdgeInsets.only(top: rh(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: rw(20)),
            child: Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: AppColors.secondary200,
                  size: rr(18),
                ),
                horizontalSpacing(6),
                Text(
                  'explore_places.top_rated'.tr(),
                  style: AppTextStyles.font16Bold.copyWith(
                    color: context.customColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          verticalSpacing(12),
          SizedBox(
            height: rh(220),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: rw(20)),
              itemCount: state.topRated.length,
              itemBuilder: (_, i) =>
                  FeaturedPlaceCard(place: state.topRated[i]),
            ),
          ),
          verticalSpacing(8),
          Divider(
            color: context.customColors.divider,
            height: 1,
            indent: rw(20),
            endIndent: rw(20),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(rr(48)),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: rr(56),
            color: context.customColors.iconSecondary,
          ),
          verticalSpacing(16),
          Text(
            'explore_places.empty_title'.tr(),
            style: AppTextStyles.font16SemiBold.copyWith(
              color: context.customColors.textPrimary,
            ),
          ),
          verticalSpacing(8),
          Text(
            'explore_places.empty_desc'.tr(),
            style: AppTextStyles.font12Regular.copyWith(
              color: context.customColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary200),
    );
  }

  Widget _buildError(BuildContext context, ExploreError state) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(rr(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: rr(56), color: AppColors.red200),
            verticalSpacing(16),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14Regular.copyWith(
                color: context.customColors.textSecondary,
              ),
            ),
            verticalSpacing(20),
            CustomTextButton(
              text: 'errors.error_screen_button'.tr(),
              onPressed: () => context.read<ExploreCubit>().loadPlaces(),
              isFullWidth: false,
              prefixIcon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
      ),
    );
  }

  String _sectionTitle(ExploreLoaded state) {
    if (state.searchQuery.isNotEmpty) {
      return 'explore_places.results'.tr(
        namedArgs: {'count': '${state.displayedPlaces.length}'},
      );
    }
    if (state.selectedType == 'FINANCIAL' &&
        state.selectedSubCategory != null) {
      return '${state.selectedSubCategory} (${state.displayedPlaces.length})';
    }
    if (state.selectedType != null) {
      final label = _types
          .firstWhere(
            (t) => t.value == state.selectedType,
            orElse: () => (
              label: state.selectedType!,
              value: state.selectedType,
              icon: Icons.store,
            ),
          )
          .label;
      return '$label (${state.displayedPlaces.length})';
    }
    return 'explore_places.all_services'.tr();
  }
}
