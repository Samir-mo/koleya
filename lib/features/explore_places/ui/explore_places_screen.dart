// lib/features/explore_places/ui/explore_places_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/explore_places/logic/explore_cubit.dart';
import 'package:gate_buddy/features/explore_places/logic/explore_state.dart';

import '../../../core/widgets/custom_app_bar.dart';
import 'widgets/filter_chip_row.dart';
import 'widgets/place_card.dart'; // Make sure this widget exists or create it
import 'widgets/search_field.dart';
import 'widgets/top_picks_of_the_day.dart';

class ExplorePlacesScreen extends StatelessWidget {
  const ExplorePlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColors.background,
      body: Column(
        children: [
          // Dark Blue Header
          const CustomAppBar(title: "Explore Places"),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpacing(12),

                  // Search Bar
                  const SearchField(),
                  verticalSpacing(16),

                  // Filter Chips
                  const FilterChipRow(),
                  verticalSpacing(24),

                  // Top Picks of the Day
                  const TopPicksOfTheDay(),
                  verticalSpacing(28),

                  // All Places Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "All Places",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.customColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "See all",
                          style: TextStyle(
                            color: context.customColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpacing(12),

                  // Main Places List
                  BlocBuilder<ExploreCubit, ExploreState>(
                    builder: (context, state) {
                      if (state is ExploreLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (state is ExploreError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: AppColors.red200,
                                ),
                                verticalSpacing(12),
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                ),
                                TextButton(
                                  onPressed: () =>
                                      context.read<ExploreCubit>().loadPlaces(),
                                  child: const Text("Retry"),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is ExploreLoaded) {
                        final places = state.filteredPlaces;
                        if (places.isEmpty) {
                          return const Center(child: Text("No places found"));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            return PlaceCard(place: places[index]);
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),

                  verticalSpacing(80), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
