import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../utils/spacing.dart';

/// Reusable rating stars widget
/// Displays 0-5 stars to represent a rating
/// Optionally interactive for user rating
///
/// Usage (display only):
///   RatingStars(rating: 4.5)
///   RatingStars(rating: 3, size: 24)
///   RatingStars(
///     rating: 4,
///     interactive: true,
///     onRatingChanged: (newRating) {},
///   )
class RatingStars extends StatefulWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.size = 18,
    this.interactive = false,
    this.onRatingChanged,
    this.color,
    this.count = 5,
  });

  final double rating;
  final double size;
  final bool interactive;
  final ValueChanged<double>? onRatingChanged;
  final Color? color;
  final int count;

  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  late double _hoverRating;

  @override
  void initState() {
    super.initState();
    _hoverRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    final displayRating = widget.interactive ? _hoverRating : widget.rating;
    final starColor = widget.color ?? AppColors.secondary200;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.count, (index) {
        final starValue = index + 1.0;
        final isFilled = starValue <= displayRating;
        final isHalf = displayRating > index && displayRating < starValue;

        return GestureDetector(
          onTap: widget.interactive
              ? () {
                  setState(() => _hoverRating = starValue);
                  widget.onRatingChanged?.call(starValue);
                }
              : null,
          onHorizontalDragUpdate: widget.interactive
              ? (details) {
                  final newRating = (index +
                          (details.localPosition.dx / widget.size))
                      .clamp(0.0, widget.count.toDouble());
                  setState(() => _hoverRating = newRating);
                }
              : null,
          onHorizontalDragEnd: widget.interactive
              ? (_) => widget.onRatingChanged?.call(_hoverRating)
              : null,
          child: Padding(
            padding: EdgeInsets.only(right: rw(2)),
            child: Stack(
              children: [
                Icon(
                  Icons.star_rounded,
                  size: widget.size,
                  color: starColor.withValues(alpha: 0.3),
                ),
                if (isHalf)
                  ClipRect(
                    clipper: _HalfClipper(),
                    child: Icon(
                      Icons.star_rounded,
                      size: widget.size,
                      color: starColor,
                    ),
                  )
                else if (isFilled)
                  Icon(
                    Icons.star_rounded,
                    size: widget.size,
                    color: starColor,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(_HalfClipper oldClipper) => false;
}
