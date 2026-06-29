import 'package:flutter/material.dart';
import 'package:gate_buddy/core/utils/spacing.dart';

class HomeSection extends StatelessWidget {
  final Widget header;
  final Widget child;
  const HomeSection({super.key, required this.header, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: rw(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [header, verticalSpacing(12), child],
      ),
    );
  }
}
