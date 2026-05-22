import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/features/indoor_map/data/models/map_service_model.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_cubit.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_state.dart';
import 'package:gate_buddy/features/indoor_map/ui/category_filter_bar.dart';
import 'package:gate_buddy/features/indoor_map/ui/widgets/service_bottom_sheet.dart';
import 'package:gate_buddy/features/indoor_map/ui/widgets/zone_selector.dart';
import 'package:latlong2/latlong.dart';

class IndoorMapScreen extends StatefulWidget {
  const IndoorMapScreen({super.key});

  @override
  State<IndoorMapScreen> createState() => _IndoorMapScreenState();
}

class _IndoorMapScreenState extends State<IndoorMapScreen> {
  final MapController _mapController = MapController();

  // Approximate center of Schiphol airport services
  static const _airportCenter = LatLng(52.3080, 4.7640);

  @override
  void initState() {
    super.initState();
    context.read<IndoorMapCubit>().loadServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<IndoorMapCubit, IndoorMapState>(
        builder: (context, state) {
          if (state is IndoorMapLoading || state is IndoorMapInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is IndoorMapError) {
            debugPrint('Error loading services: ${state.message}');
            return _ErrorView(
              message: state.message,
              onRetry: () => context.read<IndoorMapCubit>().loadServices(),
            );
          }

          if (state is IndoorMapLoaded) {
            return _MapContent(state: state, mapController: _mapController);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _MapContent extends StatelessWidget {
  final IndoorMapLoaded state;
  final MapController mapController;

  const _MapContent({required this.state, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Map ──────────────────────────────────────────────
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: const LatLng(52.3080, 4.7640),
            initialZoom: 16.5,
            minZoom: 14,
            maxZoom: 19,
            onTap: (_, __) =>
                context.read<IndoorMapCubit>().selectService(null),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.gate_buddy',
            ),
            MarkerLayer(
              markers: state.filteredServices
                  .map((s) => _buildMarker(context, s, state.selectedService))
                  .toList(),
            ),
          ],
        ),

        // ── Top bar: title + search-like header ──────────────
        Positioned(top: 0, left: 0, right: 0, child: _MapTopBar()),

        // ── Category filter bar ───────────────────────────────
        Positioned(
          top: 100.h,
          left: 0,
          right: 0,
          child: CategoryFilterBar(
            selectedCategory: state.selectedCategory,
            onCategoryChanged: (cat) =>
                context.read<IndoorMapCubit>().filterByCategory(cat),
          ),
        ),

        // ── Zone selector (right side) ────────────────────────
        Positioned(
          right: 16.w,
          top: 160.h,
          child: ZoneSelector(
            selectedZone: state.selectedZone,
            onZoneChanged: (zone) =>
                context.read<IndoorMapCubit>().filterByZone(zone),
          ),
        ),

        // ── Results count chip ────────────────────────────────
        Positioned(
          left: 16.w,
          top: 160.h,
          child: _ResultsCountChip(count: state.filteredServices.length),
        ),

        // ── Service bottom sheet ──────────────────────────────
        if (state.selectedService != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ServiceBottomSheet(
              service: state.selectedService!,
              onClose: () => context.read<IndoorMapCubit>().selectService(null),
            ),
          ),
      ],
    );
  }

  Marker _buildMarker(
    BuildContext context,
    MapServiceModel service,
    MapServiceModel? selectedService,
  ) {
    final isSelected = selectedService?.id == service.id;
    return Marker(
      point: LatLng(service.latitude, service.longitude),
      width: isSelected ? 48.w : 38.w,
      height: isSelected ? 48.w : 38.w,
      child: GestureDetector(
        onTap: () => context.read<IndoorMapCubit>().selectService(service),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary200 : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppColors.primary200 : Colors.grey[300]!,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: (isSelected ? AppColors.primary200 : Colors.black)
                    .withOpacity(0.25),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(8.r),
          child: Icon(
            _categoryIcon(service.category),
            size: isSelected ? 22.sp : 18.sp,
            color: isSelected ? Colors.white : AppColors.primary200,
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'RESTAURANTS':
        return Icons.restaurant_outlined;
      case 'ATM':
        return Icons.atm_outlined;
      case 'LOUNGE':
        return Icons.weekend_outlined;
      case 'SERVICES':
        return Icons.miscellaneous_services_outlined;
      case 'SHOPS':
      default:
        return Icons.shopping_bag_outlined;
    }
  }
}

// ── Supporting widgets ──────────────────────────────────────────

class _MapTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 52.h, 16.w, 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.95),
            Colors.white.withOpacity(0),
          ],
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.map_outlined, color: AppColors.primary200, size: 22.sp),
          SizedBox(width: 8.w),
          Text('Indoor Map', style: AppTextStyles.font18Bold),
          const Spacer(),
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6),
              ],
            ),
            child: Icon(
              Icons.my_location_rounded,
              size: 20.sp,
              color: AppColors.primary200,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsCountChip extends StatelessWidget {
  final int count;
  const _ResultsCountChip({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6),
        ],
      ),
      child: Text(
        '$count places',
        style: AppTextStyles.font12Bold.copyWith(color: AppColors.primary200),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 64.sp, color: Colors.grey[300]),
            SizedBox(height: 16.h),
            Text('Could not load map', style: AppTextStyles.font18Bold),
            SizedBox(height: 8.h),
            Text(
              message,
              style: AppTextStyles.font14Regular.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              ),
              child: Text(
                'Try Again',
                style: AppTextStyles.font14Bold.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
