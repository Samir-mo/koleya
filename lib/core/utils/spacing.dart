import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─── Spacing Widgets ──────────────────────────────────────────────────────
SizedBox verticalSpacing(final double height) => SizedBox(height: height.h);
SizedBox horizontalSpacing(final double width) => SizedBox(width: width.w);

// ─── Responsive Values ────────────────────────────────────────────────────
double rw(final double width) => width.w;
double rh(final double height) => height.h;
double rr(final double radius) => radius.r;
double rf(final double fontSize) => fontSize.sp;

// ─── Responsive Padding ───────────────────────────────────────────────────
EdgeInsets responsivePaddingAll(final double value) =>
    EdgeInsets.all(value.r);

EdgeInsets responsivePaddingSymmetric({
  final double horizontal = 0,
  final double vertical = 0,
}) =>
    EdgeInsets.symmetric(
      horizontal: horizontal.w,
      vertical: vertical.h,
    );

EdgeInsets responsivePaddingFromLTRB(
  final double left,
  final double top,
  final double right,
  final double bottom,
) =>
    EdgeInsets.fromLTRB(
      left.w,
      top.h,
      right.w,
      bottom.h,
    );

// ─── Responsive Border Radius ─────────────────────────────────────────────
BorderRadius responsiveBorderRadiusAll(final double radius) =>
    BorderRadius.circular(radius.r);

BorderRadius responsiveBorderRadiusOnly({
  final double topLeft = 0,
  final double topRight = 0,
  final double bottomLeft = 0,
  final double bottomRight = 0,
}) =>
    BorderRadius.only(
      topLeft: Radius.circular(topLeft.r),
      topRight: Radius.circular(topRight.r),
      bottomLeft: Radius.circular(bottomLeft.r),
      bottomRight: Radius.circular(bottomRight.r),
    );
