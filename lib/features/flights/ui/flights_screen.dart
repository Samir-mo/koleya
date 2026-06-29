import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/di/dependency_injection.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/flights/ui/widgets/custom_tab_bar.dart';
import 'package:gate_buddy/features/flights/ui/widgets/flight_list.dart';
import 'package:gate_buddy/features/flights/ui/widgets/search_field.dart';

import '../logic/cubit/flights_cubit.dart';
import '../logic/cubit/flights_state.dart';

class FlightsScreen extends StatelessWidget {
  const FlightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlightsCubit(repo: getIt())..loadFlights(),
      child: const _FlightsView(),
    );
  }
}

class _FlightsView extends StatefulWidget {
  const _FlightsView();

  @override
  State<_FlightsView> createState() => _FlightsViewState();
}

class _FlightsViewState extends State<_FlightsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() => _showSearch = !_showSearch);
    if (!_showSearch) {
      _searchController.clear();
      context.read<FlightsCubit>().clearSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      backgroundColor: colors.background,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          _FlightsAppBar(
            showSearch: _showSearch,
            onSearchToggle: _toggleSearch,
            searchController: _searchController,
          ),
          CustomTabBar(controller: _tabController),
          Expanded(
            child: BlocBuilder<FlightsCubit, FlightsState>(
              builder: (context, state) {
                if (state.isSearching) {
                  return FlightList(
                    flights: state.searchResults,
                    status: state.status,
                    emptyMessage: 'flights.empty_search'.tr(),
                  );
                }
                return TabBarView(
                  controller: _tabController,
                  children: [
                    FlightList(
                      flights: state.departures,
                      status: state.status,
                      emptyMessage: 'flights.empty_departures'.tr(),
                    ),
                    FlightList(
                      flights: state.arrivals,
                      status: state.status,
                      emptyMessage: 'flights.empty_arrivals'.tr(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── App Bar ──────────────────────────────────────────────────────────────────

class _FlightsAppBar extends StatelessWidget {
  final bool showSearch;
  final VoidCallback onSearchToggle;
  final TextEditingController searchController;

  const _FlightsAppBar({
    required this.showSearch,
    required this.onSearchToggle,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Container(
      color: AppColors.primary200,
      padding: EdgeInsets.only(top: top),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(14)),
            child: Row(
              children: [
                Icon(
                  Icons.flight_takeoff_rounded,
                  color: AppColors.secondary200,
                  size: rw(24),
                ),
                horizontalSpacing(10),
                Expanded(
                  child: Text(
                    'flights.title'.tr(),
                    style: AppTextStyles.font20Bold.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onSearchToggle,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      showSearch ? Icons.close_rounded : Icons.search_rounded,
                      key: ValueKey(showSearch),
                      color: AppColors.white,
                      size: rw(26),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: showSearch
                ? Padding(
                    padding: EdgeInsets.fromLTRB(rw(16), 0, rw(16), rh(14)),
                    child: SearchField(controller: searchController),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
