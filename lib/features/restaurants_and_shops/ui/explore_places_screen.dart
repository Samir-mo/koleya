import 'package:flutter/material.dart';
import 'package:gate_buddy/features/restaurants_and_shops/ui/widgets/custom_app_bar.dart';
import 'package:gate_buddy/features/restaurants_and_shops/ui/widgets/filter_chip_row.dart';
import 'package:gate_buddy/features/restaurants_and_shops/ui/widgets/place_list_view.dart';
import 'package:gate_buddy/features/restaurants_and_shops/ui/widgets/search_field.dart';
import 'package:gate_buddy/features/restaurants_and_shops/ui/widgets/top_picks_of_the_day.dart';

class ExplorePlacesScreen extends StatelessWidget {
  const ExplorePlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002D6B),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar - Outside the scroll view (Recommended)
            const CustomAppBar(appBarTitle: 'Gate Buddy'),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIntroText(),
                      const SizedBox(height: 24),
                      const SearchField(),
                      const SizedBox(height: 24),
                      const FilterChipRow(),
                      const SizedBox(height: 24),
                      const TopPicksOfTheDay(),
                      const SizedBox(height: 24),
                      const PlaceListView(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroText() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(color: Color(0xFF002D6B)),
        children: [
          TextSpan(
            text: 'Explore Shops & Restaurants\n',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          TextSpan(
            text:
                'Discover dining and shopping options available at NIA Airport.',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
