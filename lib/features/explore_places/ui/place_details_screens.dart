import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/di/dependency_injection.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/core/widgets/custom_text_button.dart';
import 'package:gate_buddy/core/shared/models/service_model.dart';
import 'package:gate_buddy/features/explore_places/logic/explore_cubit.dart';
import 'package:gate_buddy/features/explore_places/logic/explore_state.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final ServiceModel place;
  const PlaceDetailsScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
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
            context.showSuccessSnackBar('explore_places.rating_thanks'.tr());
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
                padding: EdgeInsets.all(rw(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNameRow(context, colors),
                    verticalSpacing(16),
                    _buildInfoTiles(colors),
                    verticalSpacing(20),
                    Divider(color: colors.divider, height: 1),
                    verticalSpacing(20),
                    _buildSection(
                      context,
                      title: 'explore_places.about'.tr(),
                      child: Text(
                        place.description.isNotEmpty
                            ? place.description
                            : 'explore_places.no_description'.tr(),
                        style: AppTextStyles.font14Regular.copyWith(
                          color: colors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ),
                    if (place.hours != null) ...[
                      verticalSpacing(20),
                      _buildSection(
                        context,
                        title: 'explore_places.opening_hours'.tr(),
                        child: _buildHoursRow(colors),
                      ),
                    ],
                    if (place.cuisine.isNotEmpty) ...[
                      verticalSpacing(20),
                      _buildSection(
                        context,
                        title: 'explore_places.cuisine'.tr(),
                        child: Wrap(
                          spacing: rw(8),
                          runSpacing: rh(8),
                          children: place.cuisine.map((c) => _Chip(label: c)).toList(),
                        ),
                      ),
                    ],
                    verticalSpacing(20),
                    _buildSection(
                      context,
                      title: 'explore_places.amenities'.tr(),
                      child: _buildAmenities(colors),
                    ),
                    verticalSpacing(100),
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
      expandedHeight: rh(280),
      pinned: true,
      backgroundColor: AppColors.primary200,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          margin: EdgeInsets.all(rr(8)),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.white, size: rr(18)),
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
                    size: rr(60), color: AppColors.grey600),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.black.withValues(alpha: 0.6),
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
                style: AppTextStyles.font20Bold.copyWith(color: colors.textPrimary),
              ),
            ),
            horizontalSpacing(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StatusBadge(isOpen: place.isOpen),
                verticalSpacing(6),
                Row(
                  children: [
                    Icon(Icons.star_rounded,
                        color: AppColors.secondary200, size: rr(16)),
                    horizontalSpacing(4),
                    Text(
                      place.rating.toStringAsFixed(1),
                      style: AppTextStyles.font12Bold.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        verticalSpacing(8),
        Row(
          children: [
            _TypeBadge(label: place.categoryLabel),
            horizontalSpacing(10),
            ...List.generate(
              4,
              (i) => Text(
                '\$',
                style: AppTextStyles.font14Bold.copyWith(
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
              label: 'explore_places.airport'.tr(),
              value: place.airport),
        if (place.terminal.isNotEmpty)
          _InfoTile(
              icon: Icons.location_on_rounded,
              label: 'flights.terminal'.tr(),
              value: '${"flights.terminal".tr()} ${place.terminal}'),
        if (place.hours != null)
          _InfoTile(
              icon: Icons.access_time_rounded,
              label: 'explore_places.hours'.tr(),
              value: place.hours!),
      ],
    );
  }

  Widget _buildHoursRow(dynamic colors) {
    return Row(
      children: [
        _StatusBadge(isOpen: place.isOpen),
        horizontalSpacing(12),
        Text(
          place.hours!,
          style: AppTextStyles.font14Regular.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildAmenities(dynamic colors) {
    final amenities = <(IconData, String)>[
      if (place.hasWifi == true) (Icons.wifi_rounded, 'explore_places.wifi'.tr()),
      if (place.hasUsb == true) (Icons.usb_rounded, 'explore_places.usb_charging'.tr()),
    ];

    if (amenities.isEmpty) {
      return Text(
        'explore_places.no_amenities'.tr(),
        style: AppTextStyles.font12Regular.copyWith(color: colors.textHint),
      );
    }
    return Wrap(
      spacing: rw(10),
      runSpacing: rh(10),
      children: amenities.map((a) => _AmenityChip(icon: a.$1, label: a.$2)).toList(),
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
          style: AppTextStyles.font16Bold.copyWith(
            color: context.customColors.textPrimary,
          ),
        ),
        verticalSpacing(10),
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
            padding: EdgeInsets.fromLTRB(rw(20), rh(12), rw(20), rh(12)),
            decoration: BoxDecoration(
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextButton.outlined(
                    text: 'explore_places.directions'.tr(),
                    onPressed: () {},
                    prefixIcon: const Icon(Icons.map_rounded),
                  ),
                ),
                horizontalSpacing(12),
                Expanded(
                  child: CustomTextButton(
                    text: isRating
                        ? 'explore_places.submitting'.tr()
                        : 'explore_places.rate_place'.tr(),
                    isLoading: isRating,
                    onPressed: isRating ? null : () => _showRatingSheet(context),
                    prefixIcon: const Icon(Icons.star_rounded),
                    foregroundColor: AppColors.white,
                    backgroundColor: AppColors.secondary200,
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(rr(24))),
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
        padding: EdgeInsets.fromLTRB(rw(24), rh(20), rw(24), rh(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: rw(40),
                height: rh(4),
                decoration: BoxDecoration(
                  color: colors.divider,
                  borderRadius: BorderRadius.circular(rr(4)),
                ),
              ),
            ),
            verticalSpacing(20),
            Text(
              'explore_places.rate_title'.tr(namedArgs: {'name': widget.place.name}),
              style: AppTextStyles.font18Bold.copyWith(color: colors.textPrimary),
            ),
            verticalSpacing(6),
            Text(
              'explore_places.rate_subtitle'.tr(),
              style: AppTextStyles.font12Regular.copyWith(color: colors.textSecondary),
            ),
            verticalSpacing(24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _selected = i + 1),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: rw(6)),
                    child: Icon(
                      i < _selected ? Icons.star_rounded : Icons.star_border_rounded,
                      size: rr(44),
                      color: i < _selected
                          ? AppColors.secondary200
                          : colors.iconSecondary,
                    ),
                  ),
                );
              }),
            ),
            if (_selected > 0) ...[
              verticalSpacing(8),
              Center(
                child: Text(
                  _ratingLabel(_selected),
                  style: AppTextStyles.font14SemiBold.copyWith(
                    color: AppColors.secondary200,
                  ),
                ),
              ),
            ],
            verticalSpacing(20),

            Container(
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(rr(14)),
              ),
              child: TextField(
                controller: _reviewController,
                maxLines: 3,
                style: AppTextStyles.font14Regular,
                decoration: InputDecoration(
                  hintText: 'explore_places.review_hint'.tr(),
                  hintStyle: AppTextStyles.font12Regular.copyWith(
                    color: colors.textHint,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(rr(14)),
                ),
              ),
            ),
            verticalSpacing(20),

            CustomTextButton(
              text: 'explore_places.submit_rating'.tr(),
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
            ),
          ],
        ),
      ),
    );
  }

  String _ratingLabel(int r) {
    switch (r) {
      case 1: return 'explore_places.rating_poor'.tr();
      case 2: return 'explore_places.rating_fair'.tr();
      case 3: return 'explore_places.rating_good'.tr();
      case 4: return 'explore_places.rating_very_good'.tr();
      case 5: return 'explore_places.rating_excellent'.tr();
      default: return '';
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
    final color = isOpen ? AppColors.green200 : AppColors.red200;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(10), vertical: rh(4)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(rr(20)),
      ),
      child: Text(
        isOpen ? 'explore_places.open_now'.tr() : 'explore_places.closed'.tr(),
        style: AppTextStyles.font12Bold.copyWith(color: color),
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
      padding: EdgeInsets.symmetric(horizontal: rw(10), vertical: rh(4)),
      decoration: BoxDecoration(
        color: AppColors.secondary200.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(rr(20)),
      ),
      child: Text(
        label,
        style: AppTextStyles.font12Bold.copyWith(color: AppColors.secondary200),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Padding(
      padding: EdgeInsets.only(bottom: rh(12)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(rr(8)),
            decoration: BoxDecoration(
              color: AppColors.primary200.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(rr(10)),
            ),
            child: Icon(icon, size: rr(18), color: AppColors.primary200),
          ),
          horizontalSpacing(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTextStyles.font12Medium.copyWith(color: colors.textHint)),
              Text(value,
                  style: AppTextStyles.font14SemiBold.copyWith(color: colors.textPrimary)),
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
        padding: EdgeInsets.symmetric(horizontal: rw(12), vertical: rh(6)),
        decoration: BoxDecoration(
          color: AppColors.secondary200.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(rr(20)),
        ),
        child: Text(
          label,
          style: AppTextStyles.font12Medium.copyWith(color: AppColors.secondary200),
        ),
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
      padding: EdgeInsets.symmetric(horizontal: rw(12), vertical: rh(8)),
      decoration: BoxDecoration(
        color: AppColors.primary200.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(rr(12)),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: rr(16), color: AppColors.primary200),
          horizontalSpacing(6),
          Text(
            label,
            style: AppTextStyles.font12Medium.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}
