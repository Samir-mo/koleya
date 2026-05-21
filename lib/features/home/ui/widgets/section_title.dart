import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  final bool showDot;
  final Widget? leading;

  const SectionTitle({
    super.key,
    required this.title,
    required this.color,
    this.showDot = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    Widget? effectiveLeading = leading;
    if (showDot && leading == null) {
      effectiveLeading = Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.only(right: 6),
        decoration: const BoxDecoration(color: Color(0xFFF3A623), shape: BoxShape.circle),
      );
    }

    return Row(
      children: [
        if (effectiveLeading != null) ...[effectiveLeading, const SizedBox(width: 6)],
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: color),
        ),
      ],
    );
  }
}
