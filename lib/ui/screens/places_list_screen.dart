import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/places_cubit.dart';
import '../../cubit/places_state.dart';
import '../../core/shared/models/place_model.dart';
import 'place_details_screen.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlacesCubit()..loadPlaces(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF003366),
          title: const Text('Explore Shops & Restaurants'),
        ),
        body: BlocBuilder<PlacesCubit, PlacesState>(
          builder: (context, state) {
            if (state is PlacesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PlacesError) {
              return Center(child: Text('❌ ${state.message}'));
            } else if (state is PlacesLoaded) {
              final items = state.places;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, i) => _buildCard(context, items[i]),
              );
            } else {
              return const Center(child: Text('No data'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, PlaceModel place) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(place.image, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${place.type} • ${place.terminal}',
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlaceDetailsScreen(placeId: place.id),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD39A28),
          ),
          child: const Text("View details", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}