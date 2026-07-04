import 'package:flutter/material.dart';

import '../utils/extensions/context_ext.dart';

/// Reusable shimmer loading effect
/// Uses theme-aware surface colors for light/dark mode support.
///
/// Usage:
///   LoadingShimmer.card(width: 100.w, height: 60.h)
///   LoadingShimmer.circular(size: 48.w)
///   LoadingShimmer.line(width: double.infinity, height: 12.h)
class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1200),
  });

  final Widget child;
  final Duration duration;

  /// Rectangular shimmer (default card style)
  factory LoadingShimmer.card({
    required double width,
    required double height,
    double borderRadius = 8,
    Duration duration = const Duration(milliseconds: 1200),
  }) {
    return LoadingShimmer(
      duration: duration,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Circular shimmer
  factory LoadingShimmer.circular({
    required double size,
    Duration duration = const Duration(milliseconds: 1200),
  }) {
    return LoadingShimmer(
      duration: duration,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(shape: BoxShape.circle),
      ),
    );
  }

  /// Line shimmer
  factory LoadingShimmer.line({
    required double width,
    required double height,
    Duration duration = const Duration(milliseconds: 1200),
  }) {
    return LoadingShimmer(
      duration: duration,
      child: Container(width: width, height: height),
    );
  }

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final offset = _controller.value * 2 - 1;
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(offset - 1, 0),
              end: Alignment(offset + 1, 0),
              colors: [
                colors.surfaceVariant,
                colors.surface,
                colors.surfaceVariant,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: Container(
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: _getRadius(widget.child),
              shape: _getShape(widget.child),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }

  BorderRadius? _getRadius(Widget widget) {
    if (widget is Container && widget.decoration is BoxDecoration) {
      final dec = widget.decoration as BoxDecoration;
      return dec.borderRadius as BorderRadius?;
    }
    return null;
  }

  BoxShape _getShape(Widget widget) {
    if (widget is Container && widget.decoration is BoxDecoration) {
      final dec = widget.decoration as BoxDecoration;
      return dec.shape;
    }
    return BoxShape.rectangle;
  }
}
