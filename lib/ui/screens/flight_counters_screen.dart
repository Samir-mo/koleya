import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/counters_cubit.dart';
import '../../cubit/counters_state.dart';
import '../../data/repositories/services_repository.dart';

// ألوان قريبة من فيجما
const Color kPrimaryBlue = Color(0xFF154D71);
const Color kAccentYellow = Color(0xFFF5B700);

class FlightCountersScreen extends StatefulWidget {
  const FlightCountersScreen({super.key});

  @override
  State<FlightCountersScreen> createState() => _FlightCountersScreenState();
}

class _FlightCountersScreenState extends State<FlightCountersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CountersCubit(ServicesRepository())
            ..loadCounters(subCategory: "Domestic"),
      child: Scaffold(
        // خلفية شبه اللي تحت الكروت في فيجما
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 1, 14, 60),
          centerTitle: true,
          title: const Text(
            "Flight Check-in Counters",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          // تاب بار على خلفية بيضا تحت الـ AppBar زي فيجما
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(46),
            child: Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFFEDB046),
                indicatorWeight: 3,
                labelColor: const Color(0xFFEDB046), // الـ Tab المفتوحة
                unselectedLabelColor: Color.fromARGB(
                  255,
                  1,
                  14,
                  60,
                ), // الـ Tabs المقفولة
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: "Domestic"),
                  Tab(text: "International"),
                ],
                onTap: (index) {
                  final subCategory = index == 0 ? "Domestic" : "International";
                  context.read<CountersCubit>().loadCounters(
                    subCategory: subCategory,
                  );
                },
              ),
            ),
          ),
        ),
        body: BlocBuilder<CountersCubit, CountersState>(
          builder: (context, state) {
            if (state is CountersLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 1, 14, 60),
                ),
              );
            }

            if (state is CountersError) {
              return Center(
                child: Text(
                  "❌ خطأ أثناء تحميل البيانات:\n${state.message}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is CountersLoaded) {
              final List<dynamic> counters = state.counters;

              if (counters.isEmpty) {
                return const Center(
                  child: Text(
                    "لا توجد بيانات حالياً",
                    style: TextStyle(color: Colors.black54),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: counters.length,
                itemBuilder: (context, index) {
                  final dynamic item = counters[index];
                  final Map<String, dynamic> c = item is Map<String, dynamic>
                      ? item
                      : Map<String, dynamic>.from(item as Map);

                  return _buildCounterCard(c);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCounterCard(Map<String, dynamic> c) {
    final String statusText = (c["status"] ?? "").toString();
    final bool isOpen = statusText.toLowerCase() == "open";

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // الشريط الأزرق اللي فوق الكارد (نفس لون الـ AppBar)
          Container(
            height: 8,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 1, 14, 60),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // اللوجو + النصوص
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFFE8F0F7),
                      child: const Icon(
                        Icons.flight,
                        color: Color.fromARGB(255, 1, 14, 60),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (c["title"] ?? "Counter").toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Airline: ${(c["airline"] ?? "N/A").toString()}",
                            style: const TextStyle(color: Colors.black87),
                          ),
                          Text(
                            "Location: ${(c["location"] ?? "N/A").toString()}",
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Show on Map + Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Map Navigation
                      },
                      icon: const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: kAccentYellow,
                      ),
                      label: const Text(
                        "Show on Map",
                        style: TextStyle(
                          color: Color(0xFFEDB046),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    ),
                    Row(
                      children: [
                        const Text(
                          "Status: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 1, 14, 60),
                          ),
                        ),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isOpen
                                ? const Color(0xFFEDB046)
                                : const Color(0xFFEDB046),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
