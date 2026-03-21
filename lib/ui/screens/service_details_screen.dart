import 'package:flutter/material.dart';

// 🎯 NOTE:
// شيلنا الـ Bloc والـ Repository مؤقتًا عشان الواجهة بس.
// لما تجهز الـ API تقدر ترجعهم بسهولة.

class ServiceDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> place;

  const ServiceDetailsScreen({
    super.key,
    required this.place,
  });

  Color get _primaryBlue => const Color(0xFF005B8F);
  Color get _accentYellow => const Color(0xFFF5B700);

  @override
  Widget build(BuildContext context) {
    final String name = place["name"] ?? "Place Name";
    final String about = place["about"] ??
        "Experience world-class service with dining, shopping and relaxation options.";
    final String location = place["location"] ?? "Terminal info not available.";
    final String cuisine = place["cuisine"] ?? "Various options.";
    final String open = place["open"] ?? "Opening hours not available.";
    final String rating = (place["rating"] ?? "").toString();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 375),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // صورة المكان
                  Container(
                    height: 220,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 60,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16.0, 18.0, 16.0, 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // About section
                        const Text(
                          "About",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF154D71),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          about,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Key details card
                        _DetailsCard(
                          title: "Key Details",
                          children: [
                            _DetailRow(
                              icon: Icons.restaurant_menu_rounded,
                              label: "Cuisine",
                              value: cuisine,
                            ),
                            _DetailRow(
                              icon: Icons.access_time_rounded,
                              label: "Open",
                              value: open,
                            ),
                            _DetailRow(
                              icon: Icons.star_rate_rounded,
                              label: "Rating",
                              value: rating,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Location card
                        _DetailsCard(
                          title: "Location",
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    location,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.map_rounded,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO: افتح خريطة فعلية بعدين
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _accentYellow,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  "Get Directions",
                                  style: TextStyle(
                                    color: _primaryBlue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailsCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE3E7F1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xFF154D71),
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFF5B700)),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
