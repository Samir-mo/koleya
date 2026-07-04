import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

import '../../../core/shared/models/service_model.dart';

import '../domain/airport_waypoints.dart';

/// Builds indoor routes between the user's position and any service.
/// Uses the predefined waypoint graph to simulate real corridor paths.
class IndoorRoutingService {
  IndoorRoutingService._();

  static const _walkingSpeedMps = 1.2; // average person: 1.2 m/s

  /// Main entry point — builds a route from [userPos] to [destination]
  static IndoorRoute buildRoute({
    required LatLng userPos,
    required ServiceModel destination,
  }) {
    final destLatLng = LatLng(destination.latitude, destination.longitude);

    // Pick the waypoint path based on destination zone / category
    final rawPath = _selectPath(userPos, destLatLng, destination);

    // Build polyline: user → path → destination
    final polyline = [userPos, ...rawPath, destLatLng];

    // Calculate total distance
    final totalDist = _totalDistance(polyline);

    // Build steps
    final steps = _buildSteps(polyline, destination.name, destination.zone);

    final walkSecs = (totalDist / _walkingSpeedMps).round();

    return IndoorRoute(
      polylinePoints: polyline,
      steps: steps,
      totalDistanceMeters: totalDist,
      estimatedWalkingSeconds: walkSecs,
    );
  }

  // ─── Path selection based on destination zone ─────────────────────────────

  static List<LatLng> _selectPath(LatLng from, LatLng to, ServiceModel dest) {
    final zone = dest.zone;
    final category = dest.category.toUpperCase();

    // Zone 0 — main corridor → upper branch
    if (zone == '0' || category == 'SHOPS') {
      return _pathToZone0(from, to);
    }

    // Zone 2 — main corridor → south branch (VIP / services)
    if (zone == '2' || category == 'VIP') {
      return _pathToZone2(from, to);
    }

    // Restaurants — upper corridor
    if (category == 'RESTAURANTS') {
      return _pathToZone0(from, to);
    }

    // Default — straight main corridor
    return _pathMainCorridor(from, to);
  }

  static List<LatLng> _pathToZone0(LatLng from, LatLng to) {
    return [
      AirportWaypoints.corridorA1,
      AirportWaypoints.corridorA2,
      AirportWaypoints.junctionNorth1,
      AirportWaypoints.junctionNorth2,
      AirportWaypoints.junctionNorth3,
      AirportWaypoints.gateD,
    ];
  }

  static List<LatLng> _pathToZone2(LatLng from, LatLng to) {
    return [
      AirportWaypoints.corridorA1,
      AirportWaypoints.corridorA2,
      AirportWaypoints.corridorA3,
      AirportWaypoints.junctionSouth1,
      AirportWaypoints.junctionSouth2,
      AirportWaypoints.vipLounge,
    ];
  }

  static List<LatLng> _pathMainCorridor(LatLng from, LatLng to) {
    return [
      AirportWaypoints.corridorA1,
      AirportWaypoints.corridorA2,
      AirportWaypoints.corridorA3,
      AirportWaypoints.corridorA4,
    ];
  }

  // ─── Step generation ──────────────────────────────────────────────────────

  static List<RouteStep> _buildSteps(
    List<LatLng> points,
    String destinationName,
    String zone,
  ) {
    if (points.length < 2) return [];

    final steps = <RouteStep>[];

    // Step 1 — always start
    steps.add(
      RouteStep(
        instruction: 'Head towards the main terminal corridor',
        point: points[0],
        distanceMeters: _distanceBetween(points[0], points[1]),
      ),
    );

    if (points.length > 3) {
      final midDist = _distanceBetween(points[1], points[2]);
      steps.add(
        RouteStep(
          instruction: 'Continue straight through the main hall',
          point: points[1],
          distanceMeters: midDist,
        ),
      );
    }

    if (points.length > 4) {
      steps.add(
        RouteStep(
          instruction: _turnInstruction(zone),
          point: points[points.length - 3],
          distanceMeters: _distanceBetween(
            points[points.length - 3],
            points[points.length - 2],
          ),
        ),
      );
    }

    if (points.length > 2) {
      final last = points[points.length - 1];
      final prev = points[points.length - 2];
      steps.add(
        RouteStep(
          instruction: 'Follow the signs for Zone $zone',
          point: prev,
          distanceMeters: _distanceBetween(prev, last),
        ),
      );
    }

    // Final step
    steps.add(
      RouteStep(
        instruction: '$destinationName is on your right',
        point: points.last,
        distanceMeters: 0,
      ),
    );

    return steps;
  }

  static String _turnInstruction(String zone) {
    return switch (zone) {
      '0' => 'Turn left at the shopping gallery',
      '2' => 'Turn right towards the VIP lounge corridor',
      _ => 'Follow the terminal signs',
    };
  }

  // ─── Distance helpers ─────────────────────────────────────────────────────

  static double _totalDistance(List<LatLng> points) {
    double total = 0;
    for (int i = 0; i < points.length - 1; i++) {
      total += _distanceBetween(points[i], points[i + 1]);
    }
    return total;
  }

  static double _distanceBetween(LatLng a, LatLng b) {
    // Haversine formula
    const R = 6371000.0;
    final lat1 = a.latitudeInRad;
    final lat2 = b.latitudeInRad;
    final dLat = b.latitudeInRad - a.latitudeInRad;
    final dLon = b.longitudeInRad - a.longitudeInRad;

    final h =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return R * 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
  }
}
