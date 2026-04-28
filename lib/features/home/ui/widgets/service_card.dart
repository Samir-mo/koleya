import 'package:flutter/material.dart';
import 'package:koleya/features/home/ui/home_screen.dart';

class ServiceCard extends StatelessWidget {
  final ServiceItem item;
  const ServiceCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: item.onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE3E7F1)),
        ),
        child: Row(
          children: [
            Icon(item.icon, size: 22, color: const Color(0xFFF3A623)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003A72),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
