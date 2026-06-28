import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/features/explore_places/ui/widgets/pick_thumbnail.dart';

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
        verticalSpacing(12),
        SizedBox(
          height: rh(75),
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
    return Row(
      children: [
        Text('⭐', style: TextStyle(fontSize: rf(18))),
        SizedBox(width: rw(6)),
        Text(
          'explore_places.top_picks'.tr(),
          style: TextStyle(
            fontSize: rf(16),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
