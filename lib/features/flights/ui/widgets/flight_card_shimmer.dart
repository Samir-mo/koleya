import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';

class FlightCardShimmer extends StatefulWidget {
  const FlightCardShimmer({super.key});

  @override
  State<FlightCardShimmer> createState() => _FlightCardShimmerState();
}

class _FlightCardShimmerState extends State<FlightCardShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.grey100),
        ),
        child: Column(
          children: [
            _shimmerBox(width: double.infinity, height: 5,
                radius: const BorderRadius.vertical(top: Radius.circular(14))),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _shimmerBox(width: 44, height: 44, radius: BorderRadius.circular(10)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _shimmerBox(width: 120, height: 14),
                            const SizedBox(height: 6),
                            _shimmerBox(width: 70, height: 12),
                          ],
                        ),
                      ),
                      _shimmerBox(width: 70, height: 26, radius: BorderRadius.circular(8)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _shimmerBox(width: 50, height: 40),
                      const Spacer(),
                      _shimmerBox(width: 50, height: 40),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _shimmerBox(width: 70, height: 26, radius: BorderRadius.circular(8)),
                      const SizedBox(width: 8),
                      _shimmerBox(width: 50, height: 26, radius: BorderRadius.circular(8)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    BorderRadius? radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius ?? BorderRadius.circular(4),
        gradient: LinearGradient(
          begin: Alignment(_animation.value - 1, 0),
          end: Alignment(_animation.value + 1, 0),
          colors: const [
            AppColors.grey50,
            AppColors.grey100,
            AppColors.grey50,
          ],
        ),
      ),
    );
  }
}
