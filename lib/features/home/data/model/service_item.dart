import 'package:flutter/widgets.dart';

class ServiceItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  ServiceItem({required this.title, required this.icon, required this.onTap});
}
