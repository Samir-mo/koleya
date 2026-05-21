// --- Restaurant Card Widget ---
import 'package:flutter/material.dart';
import '../../data/models/place_of_service_model.dart';

class PlaceCard extends StatelessWidget {
  final PlaceOfServiceModel restaurant;
  final VoidCallback onViewDetails;

  const PlaceCard({
    super.key,
    required this.restaurant,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE8D9B5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RestaurantImage(imagePath: restaurant.imagePath),
          const SizedBox(width: 12),
          Expanded(
            child: _RestaurantInfo(
              restaurant: restaurant,
              onViewDetails: onViewDetails,
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantImage extends StatelessWidget {
  final String? imagePath;
  const _RestaurantImage({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imagePath != null
          ? Image.asset(
              imagePath!,
              width: 100,
              height: 110,
              fit: BoxFit.cover,
            )
          : Container(
              width: 100,
              height: 110,
              color: Colors.grey.shade200,
              child: Icon(
                Icons.image_outlined,
                color: Colors.grey.shade400,
                size: 32,
              ),
            ),
    );
  }
}

class _RestaurantInfo extends StatelessWidget {
  final PlaceOfServiceModel restaurant;
  final VoidCallback onViewDetails;

  const _RestaurantInfo({
    required this.restaurant,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name: ${restaurant.name}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Type: ${restaurant.type}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
        // const SizedBox(height: 6),
        _InfoRow(icon: '⭐', text: 'Rating: ${restaurant.rating}'),
        _InfoRow(icon: '🕐', text: 'Open: ${restaurant.openHours}'),
        _InfoRow(icon: '🍽️', text: 'Cuisine: ${restaurant.cuisine}'),
        // const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEDB046),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text(
                'View details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002D6B),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
