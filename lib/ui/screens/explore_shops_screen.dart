import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/explore_cubit.dart';
import '../../cubit/explore_state.dart';
import '../../data/repositories/places_repository.dart';
import '../screens/place_details_screen.dart';

class ExploreShopsScreen extends StatelessWidget {
  const ExploreShopsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return BlocProvider(
      create: (_) => ExploreCubit(PlacesRepository())..loadPlaces(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF154D71),
          title: const Text(
            "Explore Shops & Restaurants",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ExploreCubit, ExploreState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔍 Search Bar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: "Search by name or category...",
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12),
                            ),
                            onSubmitted: (value) {
                              context
                                  .read<ExploreCubit>()
                                  .loadPlaces(category: value);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Color(0xFF154D71)),
                          onPressed: () {
                            context
                                .read<ExploreCubit>()
                                .loadPlaces(category: controller.text);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  // 🔘 Filter Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilterChip(
                        label: const Text('ALL'),
                        selectedColor: const Color(0xFF0285B8),
                        labelStyle: const TextStyle(color: Colors.white),
                        onSelected: (v) =>
                            context.read<ExploreCubit>().loadPlaces(),
                        selected: false,
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Restaurants & Cafe'),
                        selectedColor: const Color(0xFF0285B8),
                        labelStyle: const TextStyle(color: Colors.white),
                        onSelected: (v) => context
                            .read<ExploreCubit>()
                            .loadPlaces(category: "Restaurant"),
                        selected: false,
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Shops'),
                        selectedColor: const Color(0xFF0285B8),
                        labelStyle: const TextStyle(color: Colors.white),
                        onSelected: (v) => context
                            .read<ExploreCubit>()
                            .loadPlaces(category: "Shops"),
                        selected: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 📋 محتوى الشاشة
                  _buildStateContent(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStateContent(BuildContext context, ExploreState state) {
    if (state is ExploreLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF0285B8)),
        ),
      );
    }

    if (state is ExploreError) {
      return Expanded(
        child: Center(
          child: Text(
            "❌ خطأ أثناء تحميل البيانات:\n${state.message}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (state is ExploreLoaded) {
      final places = state.places;
      if (places.isEmpty) {
        return const Expanded(
          child: Center(child: Text("لا توجد بيانات لعرضها")),
        );
      }

      return Expanded(
        child: ListView.builder(
          itemCount: places.length,
          itemBuilder: (context, index) {
            final place = places[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place["name"] ?? "Shop / Restaurant",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      place["type"] ?? "Type unknown",
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        Text("${place["rating"] ?? "N/A"}"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlaceDetailsScreen(
                                placeId: place["id"],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5B700),
                        ),
                        child: const Text(
                          "View details",
                          style:
                              TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return const SizedBox();
  }
}