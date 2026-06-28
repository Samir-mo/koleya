import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gate_buddy/core/shared/models/service_model.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_cubit.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_state.dart';
import 'package:latlong2/latlong.dart';

import 'widgets/map_category_filter.dart';
import 'widgets/navigation_panel.dart';
import 'widgets/service_detail_sheet.dart';
import 'widgets/user_position_marker.dart';

class IndoorMapScreen extends StatelessWidget {
  const IndoorMapScreen({super.key});

  @override
  Widget build(BuildContext context) => const _IndoorMapView();
}

class _IndoorMapView extends StatefulWidget {
  const _IndoorMapView();

  @override
  State<_IndoorMapView> createState() => _IndoorMapViewState();
}

class _IndoorMapViewState extends State<_IndoorMapView> {
  late final MapController _mapController;

  static const _airportCenter = LatLng(52.3090, 4.7620);
  static const _defaultZoom = 16.5;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _fitRoute(List<LatLng> points) {
    if (points.isEmpty) return;
    final bounds = LatLngBounds.fromPoints(points);
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)),
    );
  }

  // ─── Marker appearance by category ───────────────────────────────────────

  Color _markerColor(String category) => switch (category.toUpperCase()) {
        'RESTAURANTS' => const Color(0xFFEA580C),
        'SHOPS' => const Color(0xFF7C3AED),
        'VIP_SERVICES' => AppColors.secondary200,
        'FINANCIAL' => const Color(0xFF059669),
        'COUNTERS' => const Color(0xFF0284C7),
        'ACCESSIBILITY' => const Color(0xFF0891B2),
        _ => AppColors.primary200,
      };

  IconData _markerIcon(String category) => switch (category.toUpperCase()) {
        'RESTAURANTS' => Icons.restaurant_rounded,
        'SHOPS' => Icons.storefront_rounded,
        'VIP_SERVICES' => Icons.workspace_premium_rounded,
        'FINANCIAL' => Icons.account_balance_rounded,
        'COUNTERS' => Icons.confirmation_number_rounded,
        'ACCESSIBILITY' => Icons.accessibility_new_rounded,
        _ => Icons.place_rounded,
      };

  Marker _buildServiceMarker(
    ServiceModel service,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final color = _markerColor(service.category);
    return Marker(
      point: LatLng(service.latitude, service.longitude),
      width: isSelected ? 52 : 40,
      height: isSelected ? 62 : 50,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 44 : 34,
              height: isSelected ? 44 : 34,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: isSelected ? 0 : 2.5),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: isSelected ? 0.45 : 0.25),
                    blurRadius: isSelected ? 14 : 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                _markerIcon(service.category),
                size: isSelected ? 22 : 17,
                color: isSelected ? Colors.white : color,
              ),
            ),
            Container(
              width: 2,
              height: isSelected ? 10 : 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary200,
      body: BlocConsumer<IndoorMapCubit, IndoorMapState>(
        listenWhen: (prev, curr) {
          if (prev is IndoorMapLoaded && curr is IndoorMapLoaded) {
            return prev.activeRoute != curr.activeRoute;
          }
          return false;
        },
        listener: (context, state) {
          if (state is IndoorMapLoaded && state.activeRoute != null) {
            _fitRoute(state.activeRoute!.polylinePoints);
          }
        },
        builder: (context, state) {
          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildAppBar(context, state),
                Expanded(
                  child: Stack(
                    children: [
                      _buildMap(context, state),
                      if (state is IndoorMapLoaded && !state.isNavigating)
                        Positioned(
                          top: 12,
                          left: 0,
                          right: 0,
                          child: MapCategoryFilter(
                            selected: state.selectedCategory,
                            onSelected: (cat) =>
                                context.read<IndoorMapCubit>().filterByCategory(cat),
                          ),
                        ),
                      if (state is IndoorMapLoaded && !state.isNavigating)
                        Positioned(
                          bottom: 14,
                          left: 12,
                          child: _buildLegend(),
                        ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: _buildBottomArea(context, state),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── App bar ──────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context, IndoorMapState state) {
    final isNav = state is IndoorMapLoaded && state.isNavigating;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.primary200,
      child: Row(
        children: [
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Indoor Map',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    letterSpacing: 0.2,
                  ),
                ),
                if (state is IndoorMapLoaded)
                  Text(
                    isNav
                        ? 'Navigation active'
                        : '${state.filteredServices.length} services nearby',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _mapController.move(_airportCenter, _defaultZoom),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                Icons.my_location_rounded,
                color: AppColors.secondary200,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Map ──────────────────────────────────────────────────────────────────

  Widget _buildMap(BuildContext context, IndoorMapState state) {
    final loaded = state is IndoorMapLoaded ? state : null;

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _airportCenter,
        initialZoom: _defaultZoom,
        minZoom: 14,
        maxZoom: 19,
        onTap: (_, __) {
          if (loaded != null && !loaded.isNavigating) {
            context.read<IndoorMapCubit>().clearSelection();
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.gate_buddy.app',
        ),

        // Route polyline layers
        if (loaded?.activeRoute != null)
          PolylineLayer(
            polylines: [
              Polyline(
                points: loaded!.activeRoute!.polylinePoints,
                strokeWidth: 9,
                color: AppColors.primary200.withValues(alpha: 0.18),
              ),
              Polyline(
                points: loaded.activeRoute!.polylinePoints,
                strokeWidth: 5,
                color: AppColors.primary200,
                strokeCap: StrokeCap.round,
                strokeJoin: StrokeJoin.round,
              ),
              Polyline(
                points: loaded.activeRoute!.polylinePoints,
                strokeWidth: 3,
                color: AppColors.secondary200.withValues(alpha: 0.85),
                pattern: StrokePattern.dashed(segments: [12, 8]),
                strokeCap: StrokeCap.round,
              ),
            ],
          ),

        // Service markers
        if (loaded != null)
          MarkerLayer(
            markers: loaded.filteredServices.map((service) {
              final isSelected = loaded.selectedService?.id == service.id;
              return _buildServiceMarker(
                service,
                isSelected,
                () => context.read<IndoorMapCubit>().selectService(service),
              );
            }).toList(),
          ),

        // User position
        if (loaded != null)
          MarkerLayer(markers: [buildUserMarker(loaded.userPosition)]),

        // Destination pin
        if (loaded?.navigationDestination != null)
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  loaded!.navigationDestination!.latitude,
                  loaded.navigationDestination!.longitude,
                ),
                width: 44,
                height: 54,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.secondary200,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondary200.withValues(alpha: 0.45),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.place_rounded,
                          color: Colors.white, size: 20),
                    ),
                    Container(width: 2, height: 10, color: AppColors.secondary200),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  // ─── Bottom area ──────────────────────────────────────────────────────────

  Widget _buildBottomArea(BuildContext context, IndoorMapState state) {
    if (state is IndoorMapLoading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (state is IndoorMapError) {
      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.red200),
            const SizedBox(width: 10),
            Expanded(
                child: Text(state.message,
                    style: const TextStyle(fontSize: 13))),
            TextButton(
              onPressed: () => context.read<IndoorMapCubit>().retry(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is! IndoorMapLoaded) return const SizedBox.shrink();

    if (state.isNavigating) {
      return NavigationPanel(
        state: state,
        onCancel: () => context.read<IndoorMapCubit>().cancelNavigation(),
        onNextStep: () => context.read<IndoorMapCubit>().nextStep(),
      );
    }

    if (state.selectedService != null) {
      return ServiceDetailSheet(
        service: state.selectedService!,
        onClose: () => context.read<IndoorMapCubit>().clearSelection(),
        onNavigate: () =>
            context.read<IndoorMapCubit>().startNavigation(state.selectedService!),
      );
    }

    return const SizedBox.shrink();
  }

  // ─── Legend ───────────────────────────────────────────────────────────────

  Widget _buildLegend() {
    final items = [
      ('Dining', const Color(0xFFEA580C)),
      ('Shops', const Color(0xFF7C3AED)),
      ('VIP', AppColors.secondary200),
      ('Finance', const Color(0xFF059669)),
      ('Counters', const Color(0xFF0284C7)),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: item.$2, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.$1,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary200,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
