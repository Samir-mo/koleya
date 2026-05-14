import 'package:flutter/material.dart';
import '../../core/shared/models/service_model.dart';

class CustomCard extends StatelessWidget {
  final ServiceModel service;
  const CustomCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(service.name),
        subtitle: Text(service.description),
      ),
    );
  }
}