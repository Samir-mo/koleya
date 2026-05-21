// --- Restaurant List View ---
import 'package:flutter/material.dart';
import 'package:gate_buddy/features/restaurants_and_shops/ui/widgets/place_card.dart';

import '../../data/models/place_of_service_model.dart';

class PlaceListView extends StatelessWidget {
  const PlaceListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PlaceOfServiceModel> restaurants = [
      PlaceOfServiceModel(
        id: 1,
        name: 'Sky Dine Lounge',
        type: 'Restaurant – Terminal 2',
        rating: 4.6,
        openHours: '24 Hours',
        cuisine: 'International & Egyptian',
        imagePath: 'assets/images/6.png',
      ),
      PlaceOfServiceModel(
        id: 2,
        name: 'SkyBite Café',
        type: 'Coffee & Snacks – Terminal 3',
        rating: 4.7,
        openHours: '24 Hours',
        cuisine: 'Sandwiches, coffee.',
        imagePath: 'assets/images/6.png',
      ),
      PlaceOfServiceModel(
        id: 2,
        name: 'Hyper one',
        type: 'Market',
        rating: 4.8,
        openHours: '24 Hours',
        cuisine: 'Sandwiches, coffee.',
        imagePath: 'assets/images/6.png',
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return PlaceCard(
          restaurant: restaurant,
          onViewDetails: () {
            // Navigate to details screen
            debugPrint('Navigating to ${restaurant.name}');
          },
        );
      },
    );
  }
}
