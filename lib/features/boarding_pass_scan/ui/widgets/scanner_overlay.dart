import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/spacing.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final frameW = rw(280);
    final frameH = rh(160);

    return CustomPaint(
      painter: _OverlayPainter(frameWidth: frameW, frameHeight: frameH),
      child: Center(
        child: SizedBox(
          width: frameW,
          height: frameH,
          child: Stack(
            children: [
              _corner(top: 0, left: 0, rotation: 0),
              _corner(top: 0, right: 0, rotation: 90),
              _corner(bottom: 0, right: 0, rotation: 180),
              _corner(bottom: 0, left: 0, rotation: 270),
            ],
          ),
        ),
      ),
    );
  }

  Widget _corner({
    double? top,
    double? left,
    double? right,
    double? bottom,
    required double rotation,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Transform.rotate(
        angle: rotation * 3.14159 / 180,
        child: CustomPaint(
          size: Size(rw(24), rw(24)),
          painter: _CornerPainter(),
        ),
      ),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final double frameWidth;
  final double frameHeight;

  _OverlayPainter({required this.frameWidth, required this.frameHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.black.withValues(alpha: 0.6);
    final cx = size.width / 2;
    final cy = size.height / 2;
    final rect = Rect.fromCenter(
      center: Offset(cx, cy),
      width: frameWidth,
      height: frameHeight,
    );
    final full = Rect.fromLTWH(0, 0, size.width, size.height);
    final path = Path()
      ..addRect(full)
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
