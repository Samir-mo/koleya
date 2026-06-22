import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_cubit.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_state.dart';
import 'package:latlong2/latlong.dart';

import '../data/models/service_location_model.dart';
import 'widgets/map_category_filter.dart';
import 'widgets/navigation_panel.dart';
import 'widgets/service_detail_sheet.dart';
import 'widgets/user_position_marker.dart';

class IndoorMapScreen extends StatelessWidget {
  const IndoorMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _IndoorMapView();
  }
}

class _IndoorMapView extends StatefulWidget {
  const _IndoorMapView();

  @override
  State<_IndoorMapView> createState() => _IndoorMapViewState();
}

class _IndoorMapViewState extends State<_IndoorMapView> {
  late final MapController _mapController;

  static const _primaryBlue = Color(0xFF013F82);
  static const _accentGold = Color(0xFFF3A623);

  // Airport center — based on real service coordinates
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

  // ─── Fit map to show entire route ─────────────────────────────────────────

  void _fitRoute(List<LatLng> points) {
    if (points.isEmpty) return;
    final bounds = LatLngBounds.fromPoints(points);
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)),
    );
  }

  // ─── Marker icon by category ──────────────────────────────────────────────

  Color _markerColor(String category) {
    return switch (category.toUpperCase()) {
      'SHOPS' => const Color(0xFF7C3AED),
      'RESTAURANTS' => const Color(0xFFEA580C),
      'VIP' => const Color(0xFFF3A623),
      'SERVICES' => const Color(0xFF059669),
      _ => _primaryBlue,
    };
  }

  IconData _markerIcon(String category) {
    return switch (category.toUpperCase()) {
      'SHOPS' => Icons.storefront_rounded,
      'RESTAURANTS' => Icons.restaurant_rounded,
      'VIP' => Icons.workspace_premium_rounded,
      'SERVICES' => Icons.miscellaneous_services_rounded,
      _ => Icons.place_rounded,
    };
  }

  // ─── Build a service marker ───────────────────────────────────────────────

  Marker _buildServiceMarker(
    ServiceLocationModel service,
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isSelected ? 44 : 34,
                height: isSelected ? 44 : 34,
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: isSelected ? 0 : 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(isSelected ? 0.45 : 0.25),
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
              // Pin tip
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryBlue,
      body: BlocConsumer<IndoorMapCubit, IndoorMapState>(
        // Only rebuild map layer when route changes, not on every sim tick
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
                // ── App bar ───────────────────────────────────────────────
                _buildAppBar(context, state),

                // ── Map + overlays ────────────────────────────────────────
                Expanded(
                  child: Stack(
                    children: [
                      _buildMap(context, state),

                      // Category filter chips — hidden during navigation
                      if (state is IndoorMapLoaded && !state.isNavigating)
                        Positioned(
                          top: 12,
                          left: 0,
                          right: 0,
                          child: MapCategoryFilter(
                            selected: state.selectedCategory,
                            onSelected: (cat) => context
                                .read<IndoorMapCubit>()
                                .filterByCategory(cat),
                          ),
                        ),

                      // Legend (bottom-left)
                      if (state is IndoorMapLoaded && !state.isNavigating)
                        Positioned(bottom: 14, left: 12, child: _buildLegend()),

                      // Bottom sheet area
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
      color: _primaryBlue,
      child: Row(
        children: [
          const SizedBox(width: 12),
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
                    fontSize: 16,
                  ),
                ),
                if (state is IndoorMapLoaded)
                  Text(
                    isNav
                        ? 'Navigation mode'
                        : '${state.filteredServices.length} services nearby',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          // Re-center button
          GestureDetector(
            onTap: () => _mapController.move(_airportCenter, _defaultZoom),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.my_location_rounded,
                color: _accentGold,
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
        // OSM tile layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.gate_buddy.app',
        ),

        // Route polyline
        if (loaded?.activeRoute != null)
          PolylineLayer(
            polylines: [
              // Background shadow line
              Polyline(
                points: loaded!.activeRoute!.polylinePoints,
                strokeWidth: 9,
                color: _primaryBlue.withOpacity(0.18),
              ),
              // Main route line
              Polyline(
                points: loaded.activeRoute!.polylinePoints,
                strokeWidth: 5,
                color: _primaryBlue,
                strokeCap: StrokeCap.round,
                strokeJoin: StrokeJoin.round,
              ),
              // Animated dashes on top
              Polyline(
                points: loaded.activeRoute!.polylinePoints,
                strokeWidth: 3,
                color: _accentGold.withOpacity(0.85),
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

        // User position dot
        if (loaded != null)
          MarkerLayer(markers: [buildUserMarker(loaded.userPosition)]),

        // Destination marker when navigating
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
                        color: _accentGold,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _accentGold.withOpacity(0.45),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.place_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Container(width: 2, height: 10, color: _accentGold),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  // ─── Bottom sheet area ────────────────────────────────────────────────────

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
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 10),
            Expanded(
              child: Text(state.message, style: const TextStyle(fontSize: 13)),
            ),
            TextButton(
              onPressed: () => context.read<IndoorMapCubit>().retry(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is! IndoorMapLoaded) return const SizedBox.shrink();

    // Navigation panel takes priority
    if (state.isNavigating) {
      return NavigationPanel(
        state: state,
        onCancel: () => context.read<IndoorMapCubit>().cancelNavigation(),
        onNextStep: () => context.read<IndoorMapCubit>().nextStep(),
      );
    }

    // Service detail sheet
    if (state.selectedService != null) {
      return ServiceDetailSheet(
        service: state.selectedService!,
        onClose: () => context.read<IndoorMapCubit>().clearSelection(),
        onNavigate: () => context.read<IndoorMapCubit>().startNavigation(
          state.selectedService!,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // ─── Legend ───────────────────────────────────────────────────────────────

  Widget _buildLegend() {
    final items = [
      ('Shops', const Color(0xFF7C3AED)),
      ('Food', const Color(0xFFEA580C)),
      ('VIP', const Color(0xFFF3A623)),
      ('Services', const Color(0xFF059669)),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
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
                        color: item.$2,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.$1,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A2E),
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
