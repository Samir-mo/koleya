import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koleya/core/router/routes.dart';

import '../../cubit/places_cubit.dart';
import '../../cubit/places_state.dart';
import '../../core/shared/models/place_model.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final int placeId;
  const PlaceDetailsScreen({super.key, required this.placeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlacesCubit()..loadPlaceDetails(placeId),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Place Details'),
          backgroundColor: const Color(0xFF003366),
        ),
        body: BlocBuilder<PlacesCubit, PlacesState>(
          builder: (context, state) {
            if (state is PlacesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PlacesError) {
              return Center(child: Text('❌ ${state.message}'));
            } else if (state is PlaceDetailsLoaded) {
              final p = state.place;
              return _buildDetails(context, p);
            } else {
              return const Center(child: Text('No Data'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context, PlaceModel p) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(p.image, width: double.infinity, height: 200, fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          Text(p.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            p.description,
            style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
          ),
          const Divider(height: 30),
          const Text("Key Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.amber),
              const SizedBox(width: 5),
              Text(p.isOpen ? "Open 24 Hours" : "Closed"),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 5),
              Text('Rating: ${p.rating}'),
            ],
          ),
          const Divider(height: 30),
          const Text("Location", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            "Terminal: ${p.terminal} • Gate: ${p.gate}",
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          const SizedBox(height: 16),

          // ✅ الزر اللي هيودّي لصفحة الخريطة (Navigation ready)
          ElevatedButton.icon(
            onPressed: () {
              // بعدها لما تعمل MapScreen حقيقية، هتضيفها لـ Routes
              Navigator.pushNamed(context, Routes.indoorMap);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD39A28),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.directions, color: Colors.white),
            label: const Text(
              "View on Map",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
