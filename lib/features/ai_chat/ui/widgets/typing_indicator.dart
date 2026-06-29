import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/utils/spacing.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => TypingIndicatorState();
}

class TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: rh(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: rw(32),
            height: rh(32),
            decoration: const BoxDecoration(
              color: AppColors.primary200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smart_toy_rounded,
              color: AppColors.secondary200,
              size: rr(16),
            ),
          ),
          horizontalSpacing(8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(12)),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(rr(16)),
                topRight: Radius.circular(rr(16)),
                bottomRight: Radius.circular(rr(16)),
                bottomLeft: Radius.circular(rr(4)),
              ),
              border: Border.all(color: AppColors.grey100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => _Dot(controller: _controller, delay: i * 0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final AnimationController controller;
  final double delay;

  const _Dot({required this.controller, required this.delay});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = ((controller.value - delay) % 1.0).clamp(0.0, 1.0);
        final offset = t < 0.5 ? t * 2 : (1.0 - t) * 2;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: rw(3)),
          width: rw(7),
          height: rh(7) + offset * rh(4),
          decoration: BoxDecoration(
            color: AppColors.primary200.withValues(alpha: 0.4 + offset * 0.6),
            borderRadius: BorderRadius.circular(rr(4)),
          ),
        );
      },
    );
  }
}
