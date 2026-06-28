import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/features/explore_places/logic/explore_cubit.dart';
import 'package:gate_buddy/features/explore_places/logic/explore_state.dart';
import 'package:gate_buddy/features/explore_places/ui/widgets/featured_place_card.dart';
import 'package:gate_buddy/features/explore_places/ui/widgets/place_card.dart';
import 'package:gate_buddy/features/explore_places/ui/widgets/service_type_chip.dart';

class ExplorePlacesScreen extends StatefulWidget {
  const ExplorePlacesScreen({super.key});

  @override
  State<ExplorePlacesScreen> createState() => _ExplorePlacesScreenState();
}

class _ExplorePlacesScreenState extends State<ExplorePlacesScreen> {
  final _searchController = TextEditingController();
  bool _showSearch = false;

  // Values must match the backend's 'category' field exactly (uppercase)
  static const _types = [
    (label: 'All', value: null, icon: Icons.grid_view_rounded),
    (
      label: 'Restaurants',
      value: 'RESTAURANTS',
      icon: Icons.restaurant_rounded,
    ),
    (label: 'Shops', value: 'SHOPS', icon: Icons.shopping_bag_rounded),
    (label: 'VIP', value: 'VIP_SERVICES', icon: Icons.stars_rounded),
    (
      label: 'Financial',
      value: 'FINANCIAL',
      icon: Icons.account_balance_rounded,
    ),
    (
      label: 'Counters',
      value: 'COUNTERS',
      icon: Icons.confirmation_number_rounded,
    ),
    (
      label: 'Accessibility',
      value: 'ACCESSIBILITY',
      icon: Icons.accessibility_new_rounded,
    ),
  ];

  static const _financialSubCategories = [
    (label: 'All', value: null),
    (label: 'ATMs', value: 'ATMs'),
    (label: 'Currency Exchange', value: 'Currency Exchange'),
    (label: 'Insurance', value: 'Insurance'),
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
                if (state is ExploreLoaded) {
                  return _buildContent(context, state);
                }
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
            // Title row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore Airport',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Discover services & places',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.7),
                            fontSize: 13.sp,
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
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        _showSearch ? Icons.close : Icons.search_rounded,
                        color: AppColors.white,
                        size: 22.r,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search bar (animated)
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _showSearch
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            hintText: 'Search restaurants, lounges…',
                            hintStyle: TextStyle(
                              color: AppColors.grey400,
                              fontSize: 14.sp,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: AppColors.grey400,
                              size: 20.r,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 14.h,
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
        // Category chips
        SliverToBoxAdapter(child: _buildTypeFilter(context, state)),

        // Featured / Top Rated
        if (state.searchQuery.isEmpty && state.topRated.isNotEmpty)
          SliverToBoxAdapter(child: _buildFeaturedSection(context, state)),

        // All places header
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _sectionTitle(state),
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: context.customColors.textPrimary,
                  ),
                ),
                if (state.isSearching)
                  SizedBox(
                    width: 16.r,
                    height: 16.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
        ),

        // Places list
        if (state.displayedPlaces.isEmpty)
          SliverToBoxAdapter(child: _buildEmpty(context))
        else
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverList.builder(
              itemCount: state.displayedPlaces.length,
              itemBuilder: (_, i) => PlaceCard(place: state.displayedPlaces[i]),
            ),
          ),

        SliverToBoxAdapter(child: SizedBox(height: 100.h)),
      ],
    );
  }

  Widget _buildTypeFilter(BuildContext context, ExploreLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main category chips
        SizedBox(
          height: 52.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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

        // Subcategory row — only shown for FINANCIAL
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
          height: 44.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            itemCount: _financialSubCategories.length,
            itemBuilder: (_, i) {
              final sub = _financialSubCategories[i];
              final isSelected = state.selectedSubCategory == sub.value;
              return GestureDetector(
                onTap: () =>
                    context.read<ExploreCubit>().selectSubCategory(sub.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondary200 : colors.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondary200
                          : colors.border,
                    ),
                  ),
                  child: Text(
                    sub.label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected ? AppColors.white : colors.textPrimary,
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
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: AppColors.secondary200,
                  size: 18.r,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Top Rated',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: context.customColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 220.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: state.topRated.length,
              itemBuilder: (_, i) =>
                  FeaturedPlaceCard(place: state.topRated[i]),
            ),
          ),
          SizedBox(height: 8.h),
          Divider(
            color: context.customColors.divider,
            height: 1,
            indent: 20.w,
            endIndent: 20.w,
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(48.r),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 56.r,
            color: context.customColors.iconSecondary,
          ),
          SizedBox(height: 16.h),
          Text(
            'No places found',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: context.customColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try a different search or category',
            style: TextStyle(
              fontSize: 13.sp,
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
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 56.r, color: AppColors.red200),
            SizedBox(height: 16.h),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.customColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: () => context.read<ExploreCubit>().loadPlaces(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary200,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _sectionTitle(ExploreLoaded state) {
    if (state.searchQuery.isNotEmpty) {
      return 'Results (${state.displayedPlaces.length})';
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
    return 'All Services';
  }
}
