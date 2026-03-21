import 'package:flutter/material.dart';

// 🎯 TODO: لما ترجع تستخدم الـ API والـ Bloc:
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../cubit/accessibility_cubit.dart';
// import '../../cubit/accessibility_state.dart';
// import '../../data/repositories/services_repository.dart';

class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  Color get _primaryBlue => const Color(0xFF005B8F);
  Color get _accentYellow => const Color(0xFFF5B700);

  @override
  Widget build(BuildContext context) {
    // بيانات ديمو شبيهة بالفيجما
    final List<Map<String, String>> demoServices = [
      {
        "title": "Wheelchair Service",
        "description":
            "Request wheelchair support from arrival to boarding gate.",
      },
      {
        "title": "Accessible Restrooms",
        "description":
            "Easily find restrooms designed for accessibility and comfort.",
      },
      {
        "title": "Golf Car Service",
        "description":
            "Enjoy comfortable rides inside the terminal with our golf car service.",
      },
      {
        "title": "Luggage Assistance",
        "description":
            "Get help carrying and handling your luggage at any point.",
      },
      {
        "title": "Escort Service",
        "description":
            "Personal escort through check-in, security, and boarding.",
      },
    ];

    // أيكون لكل خدمة زي الفيجما تقريبًا
    final List<IconData> demoIcons = [
      Icons.wheelchair_pickup,     // Wheelchair
      Icons.wc,                    // Restrooms
      Icons.airport_shuttle,       // Golf Car
      Icons.luggage,               // Luggage
      Icons.support_agent,         // Escort
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
                          const Text(
                            "Accessibility & Assistance",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Color(0xFF154D71),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Make your airport journey smoother and more comfortable with our special assistance services, all highlighted on the map for your convenience.",
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
                                return _AccessibilityServiceItem(
                                  title: item["title"]!,
                                  description: item["description"]!,
                                  primaryBlue: _primaryBlue,
                                  accentYellow: _accentYellow,
                                  iconData: demoIcons[index],
                                );
                              },
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

      // 👇 الكود الأصلي بالـ Bloc لما تحب ترجعه بعدين
      /*
      body: BlocProvider(
        create: (_) =>
            AccessibilityCubit(ServicesRepository())..loadAccessibilityServices(),
        child: BlocBuilder<AccessibilityCubit, AccessibilityState>(
          builder: (context, state) {
            ...
          },
        ),
      ),
      */
    );
  }
}

class _AccessibilityServiceItem extends StatelessWidget {
  final String title;
  final String description;
  final Color primaryBlue;
  final Color accentYellow;
  final IconData iconData;

  const _AccessibilityServiceItem({
    required this.title,
    required this.description,
    required this.primaryBlue,
    required this.accentYellow,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // الضغط على الكارت كله يفتح الخريطة
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AccessibilityLocationMapScreen(serviceTitle: title),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F7FF),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    iconData,
                    size: 26,
                    color: const Color(0xFF154D71),
                  ),
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
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AccessibilityLocationMapScreen(
                                    serviceTitle: title,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentYellow,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Locate on Map",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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

class AccessibilityLocationMapScreen extends StatelessWidget {
  final String serviceTitle;

  const AccessibilityLocationMapScreen({
    super.key,
    required this.serviceTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF005B8F),
        centerTitle: true,
        title: Text(
          serviceTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        // TODO: هنا بعدين تحط Google Map أو أي خريطة حقيقية
        child: Text(
          "هنا هتظهر خريطة مكان خدمة الـ Accessibility 🗺️",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
