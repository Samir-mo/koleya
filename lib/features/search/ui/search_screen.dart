import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/router/routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/utils/extensions/context_ext.dart';
import '../../../core/utils/spacing.dart';
import '../data/models/search_result_model.dart';
import '../logic/cubit/search_cubit.dart';
import '../logic/cubit/search_state.dart';
import 'package:get_it/get_it.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SearchCubit>(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary200,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: rw(16)),
          child: Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: rw(38),
                  height: rw(38),
                  decoration: BoxDecoration(
                    color: AppColors.primary300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.white,
                    size: rw(16),
                  ),
                ),
              ),
              horizontalSpacing(12),

              // Search field
              Expanded(
                child: Container(
                  height: rh(44),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(rr(22)),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      return TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onChanged: (v) =>
                            context.read<SearchCubit>().onQueryChanged(v),
                        style: AppTextStyles.font14Regular.copyWith(
                          color: AppColors.white,
                        ),
                        cursorColor: AppColors.secondary200,
                        decoration: InputDecoration(
                          hintText: 'search.hint'.tr(),
                          hintStyle: AppTextStyles.font14Regular.copyWith(
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: AppColors.secondary200,
                            size: rw(20),
                          ),
                          suffixIcon: state.query.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _controller.clear();
                                    context.read<SearchCubit>().clear();
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: AppColors.white.withValues(
                                      alpha: 0.7,
                                    ),
                                    size: rw(18),
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: rh(12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state.isInitial) return _EmptyPrompt();
          if (state.isLoading) return const _LoadingView();
          if (state.isFailure) return _ErrorView(error: state.error ?? '');
          if (state.results.isEmpty) {
            return _NoResults(query: state.query);
          }
          return _ResultsList(results: state.results);
        },
      ),
    );
  }
}

// ── Empty prompt (quick categories) ──────────────────────────────────────────

class _EmptyPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final categories = [
      _QuickItem(
        icon: Icons.flight_rounded,
        label: 'search.quick_flights'.tr(),
        color: AppColors.primary200,
        route: Routes.flights,
      ),
      _QuickItem(
        icon: Icons.star_outline_rounded,
        label: 'search.quick_vip'.tr(),
        color: AppColors.secondary200,
        route: Routes.servicesCategory,
        args: const {'category': 'VIP_SERVICES'},
      ),
      _QuickItem(
        icon: Icons.restaurant_outlined,
        label: 'search.quick_restaurants'.tr(),
        color: AppColors.red200,
        route: Routes.servicesCategory,
        args: const {'category': 'RESTAURANTS'},
      ),
      _QuickItem(
        icon: Icons.shopping_bag_outlined,
        label: 'search.quick_shops'.tr(),
        color: AppColors.amber200,
        route: Routes.servicesCategory,
        args: const {'category': 'SHOPS'},
      ),
      _QuickItem(
        icon: Icons.account_balance_outlined,
        label: 'search.quick_financial'.tr(),
        color: AppColors.green200,
        route: Routes.servicesCategory,
        args: const {'category': 'FINANCIAL'},
      ),
      _QuickItem(
        icon: Icons.accessible_outlined,
        label: 'search.quick_accessibility'.tr(),
        color: AppColors.blue200,
        route: Routes.servicesCategory,
        args: const {'category': 'ACCESSIBILITY'},
      ),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(rw(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpacing(8),
          Text(
            'search.quick_access'.tr(),
            style: AppTextStyles.font16Bold.copyWith(color: colors.textPrimary),
          ),
          verticalSpacing(16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: rw(12),
              mainAxisSpacing: rh(12),
              childAspectRatio: 2.5,
            ),
            itemCount: categories.length,
            itemBuilder: (_, i) {
              final item = categories[i];
              return GestureDetector(
                onTap: () =>
                    context.pushNamed(item.route, arguments: item.args),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: rw(14),
                    vertical: rh(10),
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(rr(14)),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: rw(34),
                        height: rw(34),
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(rr(10)),
                        ),
                        child: Icon(item.icon, size: rw(17), color: item.color),
                      ),
                      horizontalSpacing(10),
                      Expanded(
                        child: Text(
                          item.label,
                          style: AppTextStyles.font14SemiBold.copyWith(
                            color: colors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuickItem {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  final Map<String, dynamic>? args;
  const _QuickItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
    this.args,
  });
}

// ── Loading ───────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary200),
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String error;
  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(rw(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: rw(52), color: colors.textHint),
            verticalSpacing(16),
            Text(
              'errors.error_screen_title'.tr(),
              style: AppTextStyles.font16Bold.copyWith(
                color: colors.textPrimary,
              ),
            ),
            verticalSpacing(8),
            Text(
              error,
              style: AppTextStyles.font14Regular.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── No results ────────────────────────────────────────────────────────────────

class _NoResults extends StatelessWidget {
  final String query;
  const _NoResults({required this.query});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(rw(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: rw(52),
              color: colors.textHint,
            ),
            verticalSpacing(16),
            Text(
              'search.no_results'.tr(),
              style: AppTextStyles.font16Bold.copyWith(
                color: colors.textPrimary,
              ),
            ),
            verticalSpacing(8),
            Text(
              '"$query"',
              style: AppTextStyles.font14Regular.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Results list ──────────────────────────────────────────────────────────────

class _ResultsList extends StatelessWidget {
  final List<SearchResultModel> results;
  const _ResultsList({required this.results});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(rw(16)),
      itemCount: results.length,
      separatorBuilder: (_, __) => verticalSpacing(10),
      itemBuilder: (_, i) => _ResultCard(result: results[i]),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final SearchResultModel result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final (icon, color) = _iconAndColor(result.type);

    return Container(
      padding: EdgeInsets.all(rw(14)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(14)),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: rw(42),
            height: rw(42),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(rr(12)),
            ),
            child: Icon(icon, size: rw(20), color: color),
          ),
          horizontalSpacing(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.title,
                  style: AppTextStyles.font14SemiBold.copyWith(
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpacing(3),
                Text(
                  result.subtitle,
                  style: AppTextStyles.font12Regular.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (result.badge != null) ...[
            horizontalSpacing(10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: rw(8), vertical: rh(4)),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(rr(20)),
              ),
              child: Text(
                result.badge!,
                style: AppTextStyles.font12Medium.copyWith(color: color),
              ),
            ),
          ],
          horizontalSpacing(8),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: rw(14),
            color: colors.textHint,
          ),
        ],
      ),
    );
  }

  (IconData, Color) _iconAndColor(SearchResultType type) {
    switch (type) {
      case SearchResultType.flight:
        return (Icons.flight_rounded, AppColors.primary200);
      case SearchResultType.service:
        return (Icons.local_airport_rounded, AppColors.secondary200);
      case SearchResultType.place:
        return (Icons.place_rounded, AppColors.red200);
      case SearchResultType.unknown:
        return (Icons.search_rounded, AppColors.grey400);
    }
  }
}
