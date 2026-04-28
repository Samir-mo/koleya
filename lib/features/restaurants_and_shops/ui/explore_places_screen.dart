import 'package:flutter/material.dart';
import 'package:koleya/features/restaurants_and_shops/ui/widgets/custom_app_bar.dart';
import 'package:koleya/features/restaurants_and_shops/ui/widgets/filter_chip_row.dart';
import 'package:koleya/features/restaurants_and_shops/ui/widgets/place_list_view.dart';
import 'package:koleya/features/restaurants_and_shops/ui/widgets/search_field.dart';
import 'package:koleya/features/restaurants_and_shops/ui/widgets/top_picks_of_the_day.dart';

class ExplorePlacesScreen extends StatelessWidget {
  const ExplorePlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Color(0xFF002D6B),
      child: SafeArea(
        child: SingleChildScrollView(
          child: ColoredBox(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(appBarTitle: 'Gate buddy'),
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    top: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIntroText(),
                      SizedBox(height: 24),
                      SearchField(),
                      SizedBox(height: 24),
                      FilterChipRow(),
                      SizedBox(height: 24),
                      TopPicksOfTheDay(),
                      SizedBox(height: 24),
                      PlaceListView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroText() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Color(0xFF002D6B)),
        children: [
          const TextSpan(
            text: 'Explore Shops & Restaurants\n',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          const TextSpan(
            text:
                'Discover dining and shopping options available at NIA Airport.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
