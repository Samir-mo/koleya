import 'package:latlong2/latlong.dart';

/// Predefined indoor waypoint graph for the airport.
/// All coordinates are based on the real service coordinates
/// from the backend (Schiphol-style layout).
/// Waypoints simulate corridors, hallways, and intersections.

class AirportWaypoints {
  AirportWaypoints._();

  // ─── Main corridor spine (horizontal) ─────────────────────────────────────
  static const LatLng mainEntranceA = LatLng(52.3098, 4.7590);
  static const LatLng corridorA1 = LatLng(52.3098, 4.7600);
  static const LatLng corridorA2 = LatLng(52.3098, 4.7610);
  static const LatLng corridorA3 = LatLng(52.3098, 4.7620);
  static const LatLng corridorA4 = LatLng(52.3098, 4.7630);
  static const LatLng corridorA5 = LatLng(52.3098, 4.7640);
  static const LatLng mainEntranceB = LatLng(52.3098, 4.7650);

  // ─── Upper branch (Zone 0 - shops/restaurants) ────────────────────────────
  static const LatLng junctionNorth1 = LatLng(52.3093, 4.7601);
  static const LatLng junctionNorth2 = LatLng(52.3093, 4.7612);
  static const LatLng junctionNorth3 = LatLng(52.3093, 4.7623);
  static const LatLng junctionNorth4 = LatLng(52.3093, 4.7635);
  static const LatLng gateC = LatLng(52.3090, 4.7601);
  static const LatLng gateD = LatLng(52.3090, 4.7612);
  static const LatLng gateE = LatLng(52.3090, 4.7624);
  static const LatLng gateF = LatLng(52.3090, 4.7635);

  // ─── Lower branch (Zone 2 - VIP / services) ───────────────────────────────
  static const LatLng junctionSouth1 = LatLng(52.3086, 4.7600);
  static const LatLng junctionSouth2 = LatLng(52.3086, 4.7612);
  static const LatLng junctionSouth3 = LatLng(52.3086, 4.7625);
  static const LatLng junctionSouth4 = LatLng(52.3086, 4.7637);
  static const LatLng vipLounge = LatLng(52.3083, 4.7612);
  static const LatLng securityGate = LatLng(52.3083, 4.7625);

  // ─── Named landmark nodes (match backend coords) ──────────────────────────
  static const LatLng newsAndBooks = LatLng(52.3086, 4.7637); // zone 0
  static const LatLng jaminShop = LatLng(52.3093, 4.7612); // zone 2
  static const LatLng hunkemoller = LatLng(52.3088, 4.7635); // zone 0
  static const LatLng bloem = LatLng(52.3099, 4.7601); // zone 0

  // ─── User "start" position ────────────────────────────────────────────────
  static const LatLng userStart = LatLng(52.3098, 4.7590);
}

/// A named step in a walking route
class RouteStep {
  final String instruction;
  final LatLng point;
  final double distanceMeters;

  const RouteStep({
    required this.instruction,
    required this.point,
    required this.distanceMeters,
  });
}

/// Represents a complete indoor route
class IndoorRoute {
  final List<LatLng> polylinePoints;
  final List<RouteStep> steps;
  final double totalDistanceMeters;
  final int estimatedWalkingSeconds;

  const IndoorRoute({
    required this.polylinePoints,
    required this.steps,
    required this.totalDistanceMeters,
    required this.estimatedWalkingSeconds,
  });

  String get estimatedTimeLabel {
    if (estimatedWalkingSeconds < 60) {
      return '${estimatedWalkingSeconds}s walk';
    }
    final mins = (estimatedWalkingSeconds / 60).ceil();
    return '$mins min walk';
  }

  String get distanceLabel {
    if (totalDistanceMeters < 1000) {
      return '${totalDistanceMeters.toStringAsFixed(0)}m';
    }
    return '${(totalDistanceMeters / 1000).toStringAsFixed(1)}km';
  }
}
