import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gate_buddy/core/di/dependency_injection.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/shared/models/service_model.dart';
import 'package:gate_buddy/features/explore_places/logic/explore_cubit.dart';
import 'package:gate_buddy/features/explore_places/logic/explore_state.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final ServiceModel place;
  const PlaceDetailsScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    // Own ExploreCubit instance just for rating actions on this screen
    return BlocProvider(
      create: (_) => getIt<ExploreCubit>(),
      child: _PlaceDetailsView(place: place),
    );
  }
}

class _PlaceDetailsView extends StatelessWidget {
  final ServiceModel place;
  const _PlaceDetailsView({required this.place});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return BlocListener<ExploreCubit, ExploreState>(
      listener: (context, state) {
        if (state is ExploreLoaded) {
          if (state.ratingSuccess) {
            context.showSuccessSnackBar('Thank you for your rating!');
            context.read<ExploreCubit>().clearRatingResult();
          }
          if (state.ratingError != null) {
            context.showErrorSnackBar(state.ratingError!);
            context.read<ExploreCubit>().clearRatingResult();
          }
        }
      },
      child: Scaffold(
        backgroundColor: colors.background,
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNameRow(context, colors),
                    SizedBox(height: 16.h),
                    _buildInfoTiles(colors),
                    SizedBox(height: 20.h),
                    Divider(color: colors.divider, height: 1),
                    SizedBox(height: 20.h),
                    _buildSection(
                      context,
                      title: 'About',
                      child: Text(
                        place.description.isNotEmpty
                            ? place.description
                            : 'No description available for this location.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ),
                    if (place.hours != null) ...[
                      SizedBox(height: 20.h),
                      _buildSection(
                        context,
                        title: 'Opening Hours',
                        child: _buildHoursRow(colors),
                      ),
                    ],
                    if (place.cuisine.isNotEmpty) ...[
                      SizedBox(height: 20.h),
                      _buildSection(
                        context,
                        title: 'Cuisine',
                        child: Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children:
                              place.cuisine.map((c) => _Chip(label: c)).toList(),
                        ),
                      ),
                    ],
                    SizedBox(height: 20.h),
                    _buildSection(
                      context,
                      title: 'Amenities',
                      child: _buildAmenities(colors),
                    ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomBar(context, colors),
      ),
    );
  }

  // ─── Sliver App Bar ────────────────────────────────────────────────────────

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280.h,
      pinned: true,
      backgroundColor: AppColors.primary200,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.white, size: 18.r),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: place.primaryImage ?? '',
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: AppColors.grey800),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.grey800,
                child: Icon(Icons.storefront_outlined,
                    size: 60.r, color: AppColors.grey600),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Name Row ──────────────────────────────────────────────────────────────

  Widget _buildNameRow(BuildContext context, dynamic colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                place.name,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StatusBadge(isOpen: place.isOpen),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.star_rounded,
                        color: AppColors.secondary200, size: 16.r),
                    SizedBox(width: 4.w),
                    Text(
                      place.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            _TypeBadge(label: place.categoryLabel),
            SizedBox(width: 10.w),
            ...List.generate(
              4,
              (i) => Text(
                '\$',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: i < place.priceLevel
                      ? AppColors.secondary200
                      : colors.textDisabled,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Info tiles ────────────────────────────────────────────────────────────

  Widget _buildInfoTiles(dynamic colors) {
    return Column(
      children: [
        if (place.airport.isNotEmpty)
          _InfoTile(
              icon: Icons.flight_rounded,
              label: 'Airport',
              value: place.airport),
        if (place.terminal.isNotEmpty)
          _InfoTile(
              icon: Icons.location_on_rounded,
              label: 'Terminal',
              value: 'Terminal ${place.terminal}'),
        if (place.hours != null)
          _InfoTile(
              icon: Icons.access_time_rounded,
              label: 'Hours',
              value: place.hours!),
      ],
    );
  }

  Widget _buildHoursRow(dynamic colors) {
    return Row(
      children: [
        _StatusBadge(isOpen: place.isOpen),
        SizedBox(width: 12.w),
        Text(
          place.hours!,
          style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildAmenities(dynamic colors) {
    final amenities = <(IconData, String)>[
      if (place.hasWifi == true) (Icons.wifi_rounded, 'WiFi'),
      if (place.hasUsb == true) (Icons.usb_rounded, 'USB Charging'),
    ];

    if (amenities.isEmpty) {
      return Text(
        'No amenity information available.',
        style: TextStyle(fontSize: 13.sp, color: colors.textHint),
      );
    }
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children:
          amenities.map((a) => _AmenityChip(icon: a.$1, label: a.$2)).toList(),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: context.customColors.textPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        child,
      ],
    );
  }

  // ─── Bottom bar ────────────────────────────────────────────────────────────

  Widget _buildBottomBar(BuildContext context, dynamic colors) {
    return BlocBuilder<ExploreCubit, ExploreState>(
      builder: (context, state) {
        final isRating = state is ExploreLoaded && state.isRating;
        return SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
            decoration: BoxDecoration(
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.map_rounded, size: 18.r),
                    label: const Text('Directions'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary200,
                      side: const BorderSide(color: AppColors.primary200),
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isRating
                        ? null
                        : () => _showRatingSheet(context),
                    icon: isRating
                        ? SizedBox(
                            width: 16.r,
                            height: 16.r,
                            child: const CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.white),
                          )
                        : Icon(Icons.star_rounded, size: 18.r),
                    label: Text(isRating ? 'Submitting…' : 'Rate Place'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary200,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRatingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.customColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ExploreCubit>(),
        child: _RatingSheet(place: place),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Rating Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _RatingSheet extends StatefulWidget {
  final ServiceModel place;
  const _RatingSheet({required this.place});

  @override
  State<_RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<_RatingSheet> {
  int _selected = 0;
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.divider,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Rate ${widget.place.name}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Your feedback helps other travelers',
              style:
                  TextStyle(fontSize: 13.sp, color: colors.textSecondary),
            ),
            SizedBox(height: 24.h),

            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _selected = i + 1),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Icon(
                      i < _selected
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      size: 44.r,
                      color: i < _selected
                          ? AppColors.secondary200
                          : colors.iconSecondary,
                    ),
                  ),
                );
              }),
            ),
            if (_selected > 0) ...[
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  _ratingLabel(_selected),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary200,
                  ),
                ),
              ),
            ],
            SizedBox(height: 20.h),

            // Review field
            Container(
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: TextField(
                controller: _reviewController,
                maxLines: 3,
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: 'Share your experience (optional)…',
                  hintStyle:
                      TextStyle(color: colors.textHint, fontSize: 13.sp),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(14.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selected == 0
                    ? null
                    : () {
                        context.read<ExploreCubit>().ratePlace(
                              place: widget.place,
                              rating: _selected,
                              review: _reviewController.text.trim().isEmpty
                                  ? null
                                  : _reviewController.text.trim(),
                            );
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary200,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor: colors.border,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r)),
                ),
                child: Text(
                  'Submit Rating',
                  style: TextStyle(
                      fontSize: 15.sp, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _ratingLabel(int r) {
    switch (r) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent!';
      default:
        return '';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small reusable widgets
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final bool isOpen;
  const _StatusBadge({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: (isOpen ? AppColors.green200 : AppColors.red200)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        isOpen ? 'Open Now' : 'Closed',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: isOpen ? AppColors.green200 : AppColors.red200,
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String label;
  const _TypeBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.secondary200.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.secondary200,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primary200.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 18.r, color: AppColors.primary200),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: colors.textHint,
                      fontWeight: FontWeight.w500)),
              Text(value,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.secondary200.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary200)),
      );
}

class _AmenityChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _AmenityChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary200.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12.r),
        border:
            Border.all(color: AppColors.primary200.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.r, color: AppColors.primary200),
          SizedBox(width: 6.w),
          Text(label,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary)),
        ],
      ),
    );
  }
}
