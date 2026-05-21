import 'package:flutter/material.dart';
import 'package:gate_buddy/ui/screens/profile_screen.dart';
// TODO: لما ترجع تربط الـ API والـ Bloc استوردهم هنا
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../cubit/vip_cubit.dart';
// import '../../cubit/vip_state.dart';
// import '../../data/repositories/services_repository.dart';

class VipExperienceScreen extends StatelessWidget {
  const VipExperienceScreen({super.key});

  Color get _primaryBlue => const Color(0xFF005B8F);
  Color get _accentYellow => const Color(0xFFF5B700);

  @override
  Widget build(BuildContext context) {
    // بيانات ديمو عشان بس نشوف الـ UI زي الفيجما
    final List<Map<String, String>> demoServices = [
      {
        "title": "Private Lounge Access",
        "description":
            "Relax in our luxurious private lounge before your flight.",
      },
      {
        "title": "Food & Beverage",
        "description": "Enjoy a wide variety of gourmet meals and beverages.",
      },
      {
        "title": "Free Wi-Fi & Entertainment",
        "description":
            "Stay connected with high-speed internet and premium TV zones.",
      },
      {
        "title": "Smoking & Non-Smoking Areas",
        "description":
            "Choose your comfort zone with designated areas for every preference.",
      },
      {
        "title": "Highlighted on Map",
        "description":
            "All VIP facilities are clearly marked on the airport map.",
      },
    ];

    // 👇 أيكون مختلفة لكل عنصر زي الفيجما
    final List<IconData> demoIcons = [
      Icons.event_seat, // Private Lounge Access
      Icons.restaurant_menu, // Food & Beverage
      Icons.wifi_tethering, // Free Wi-Fi & Entertainment
      Icons.smoke_free, // Smoking & Non-Smoking Areas
      Icons.map_outlined, // Highlighted on Map
    ];

    return Scaffold(
      backgroundColor: _primaryBlue,
      appBar: AppBar(
        backgroundColor: _primaryBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Gate buddy",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          // نقفل العرض على مقاس الموبايل زي الفيجما
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 375),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Title inside card
                          const Text(
                            "VIP Experience",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Color(0xFF154D71),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Enjoy exclusive comfort and personalized airport\nservices designed for your luxury travel.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // قائمة الخدمات
                          Expanded(
                            child: ListView.builder(
                              itemCount: demoServices.length,
                              itemBuilder: (context, index) {
                                final item = demoServices[index];
                                return _VipServiceItem(
                                  title: item["title"]!,
                                  description: item["description"]!,
                                  primaryBlue: _primaryBlue,
                                  accentYellow: _accentYellow,
                                  iconData: demoIcons[index],
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 12),

                          // زرار Explore VIP Lounges
                          SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: هنا ترجع تربط بالـ API أو صفحة تانية
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _accentYellow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                "Explore VIP Lounges",
                                style: TextStyle(
                                  color: _primaryBlue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),

      // 👇 ده مثال للكود اللي كان فيه Bloc لو حبيت ترجعه بعدين
      /*
      body: BlocProvider(
        create: (_) => VipCubit(ServicesRepository())..loadVipServices(),
        child: BlocBuilder<VipCubit, VipState>(
          builder: (context, state) {
            ...
          },
        ),
      ),
      */
    );
  }
}

class _VipServiceItem extends StatelessWidget {
  final String title;
  final String description;
  final Color primaryBlue;
  final Color accentYellow;
  final IconData iconData;

  const _VipServiceItem({
    required this.title,
    required this.description,
    required this.primaryBlue,
    required this.accentYellow,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // 👈 لما تضغط على الكارت كله
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(),
            // (serviceTitle: title)
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F7FF), // خلفية خفيفة زي الفيجما
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // الشريط الأصفر اللي فوق الكارت
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: accentYellow,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 10.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(iconData, size: 26, color: const Color(0xFF154D71)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: primaryBlue,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
