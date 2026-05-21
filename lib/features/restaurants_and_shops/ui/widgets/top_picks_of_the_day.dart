import 'package:flutter/material.dart';
import 'package:gate_buddy/features/restaurants_and_shops/ui/widgets/pick_thumbnail.dart';

class TopPicksOfTheDay extends StatelessWidget {
  const TopPicksOfTheDay({super.key});

  final List<String?> imagePaths = const [
    'assets/images/6.png',
    'assets/images/6.png',
    'assets/images/6.png',
    null,
    null,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(),
        const SizedBox(height: 12),
        SizedBox(
          height: 75,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imagePaths.length,
            itemBuilder: (context, index) =>
                PickThumbnail(imagePath: imagePaths[index]),
          ),
        ),
      ],
    );
  }
}

// --- Section Header Widget ---
class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text('⭐', style: TextStyle(fontSize: 18)),
        SizedBox(width: 6),
        Text(
          'Top Picks of the Day',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
