import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Animated pulsing blue dot that represents the user's current position.
/// Used inside a flutter_map MarkerLayer.
class UserPositionMarker extends StatefulWidget {
  final LatLng position;

  const UserPositionMarker({super.key, required this.position});

  @override
  State<UserPositionMarker> createState() => _UserPositionMarkerState();
}

class _UserPositionMarkerState extends State<UserPositionMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: false);

    _pulse = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) => Stack(
        alignment: Alignment.center,
        children: [
          // Outer pulse ring
          Container(
            width: 40 * _pulse.value,
            height: 40 * _pulse.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(
                33,
                150,
                243,
                0.2 * (1 - _pulse.value + 0.3),
              ),
            ),
          ),
          // Inner accuracy ring
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2196F3).withValues(alpha: 0.18),
              border: Border.all(
                color: const Color(0xFF2196F3).withValues(alpha: 0.4),
                width: 1,
              ),
            ),
          ),
          // Core dot
          Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1565C0),
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2196F3).withValues(alpha: 0.5),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Returns a flutter_map Marker for the user position.
Marker buildUserMarker(LatLng position) {
  return Marker(
    point: position,
    width: 48,
    height: 48,
    child: UserPositionMarker(position: position),
  );
}
