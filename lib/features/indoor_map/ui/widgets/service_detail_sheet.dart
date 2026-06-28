import 'package:flutter/material.dart';
import 'package:gate_buddy/core/shared/models/service_model.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';

class ServiceDetailSheet extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onClose;
  final VoidCallback onNavigate;

  const ServiceDetailSheet({
    super.key,
    required this.service,
    required this.onClose,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      margin: EdgeInsets.fromLTRB(rw(12), 0, rw(12), rh(12)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: EdgeInsets.only(top: rh(10)),
            child: Container(
              width: rw(36),
              height: rh(4),
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(rr(2)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(rw(16), rh(12), rw(16), rh(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: image + info + close
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: service.primaryImage?.isNotEmpty == true
                          ? Image.network(
                              service.primaryImage!,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholder(),
                            )
                          : _placeholder(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary200,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: onClose,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.close,
                                      size: 16, color: Colors.grey.shade600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          // Category badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary200.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              service.categoryLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary200,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Open / closed status
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: service.isOpen
                                      ? Colors.green.shade500
                                      : Colors.red.shade400,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                service.isOpen ? 'Open Now' : 'Closed',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: service.isOpen
                                      ? Colors.green.shade600
                                      : Colors.red.shade500,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Rating
                              Icon(Icons.star_rounded,
                                  size: 13, color: AppColors.secondary200),
                              const SizedBox(width: 3),
                              Text(
                                service.rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Info chips
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if (service.hours?.isNotEmpty == true)
                      _InfoChip(
                        icon: Icons.access_time_rounded,
                        label: service.hours!,
                      ),
                    _InfoChip(
                      icon: Icons.location_on_outlined,
                      label: service.gate?.isNotEmpty == true
                          ? 'Gate ${service.gate}'
                          : service.zone.isNotEmpty
                              ? 'Zone ${service.zone}'
                              : 'Terminal ${service.terminal}',
                    ),
                    if (service.waitTime > 0)
                      _InfoChip(
                        icon: Icons.timer_outlined,
                        label: '${service.waitTime} min wait',
                        highlight: true,
                      ),
                  ],
                ),

                // Description
                if (service.description.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    service.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],

                // Amenity tags
                if (service.amenities.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: service.amenities
                        .take(4)
                        .map((a) => _TagChip(label: a))
                        .toList(),
                  ),
                ],

                const SizedBox(height: 14),

                // Navigate button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: onNavigate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    icon: Icon(Icons.navigation_rounded,
                        color: AppColors.secondary200, size: 18),
                    label: Text(
                      'Navigate',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.secondary200,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF3FB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.storefront_outlined,
            size: 30, color: AppColors.primary200),
      );
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlight;
  const _InfoChip({
    required this.icon,
    required this.label,
    this.highlight = false,
  });
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: highlight
              ? AppColors.secondary200.withValues(alpha: 0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 12,
              color: highlight ? AppColors.secondary200 : Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: highlight
                    ? const Color(0xFF8E5B15)
                    : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      );
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFE3E7F1)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.primary200,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}
