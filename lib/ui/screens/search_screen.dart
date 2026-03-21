import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/search_cubit.dart';
import '../../cubit/search_state.dart';
import '../../data/repositories/search_repository.dart';

/// شاشة البحث عن الرحلات أو الخدمات
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return BlocProvider(
      create: (_) => SearchCubit(SearchRepository()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF154D71),
          title: const Text(
            "Gate Buddy",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 🔍 Search Bar
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Find Your Flight...",
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onSubmitted: (value) {
                          context.read<SearchCubit>().performSearch(value);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Color(0xFF154D71)),
                      onPressed: () {
                        context
                            .read<SearchCubit>()
                            .performSearch(controller.text);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 📋 Bloc State Handling
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchInitial) {
                      return const Center(
                        child: Text("🔍 ابحث عن رحلتك هنا..."),
                      );
                    } else if (state is SearchLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0285B8),
                        ),
                      );
                    } else if (state is SearchError) {
                      return Center(
                        child: Text(
                          "حدث خطأ أثناء البحث\n${state.message}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is SearchLoaded) {
                      final results = state.results;
                      if (results.isEmpty) {
                        return const Center(
                          child: Text("❌ لا توجد نتائج."),
                        );
                      }

                      return ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final flight = results[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.flight_takeoff_rounded,
                                color: Color(0xFF0285B8),
                              ),
                              title: Text(
                                flight["route"] ?? "Flight Route",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "Flight No: ${flight["flight_no"] ?? "N/A"}\n"
                                "Status: ${flight["status"] ?? "Unknown"}",
                              ),
                              trailing: Text(
                                flight["time"] ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}