import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final double radius;

  const ProfileAvatar({
    super.key,
    this.photoUrl,
    required this.name,
    this.radius = 44,
  });

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.secondary200, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: photoUrl != null && photoUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: photoUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    _Initials(initials: _initials, radius: radius),
              )
            : _Initials(initials: _initials, radius: radius),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  final String initials;
  final double radius;

  const _Initials({required this.initials, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      color: AppColors.primary300,
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.font20Bold.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
