// import 'package:flutter/material.dart';
// import '../../ui/screens/service_details_screen.dart';

// class ServicesScreen extends StatefulWidget {
//   const ServicesScreen({super.key});

//   @override
//   State<ServicesScreen> createState() => _ServicesScreenState();
// }

// class _ServicesScreenState extends State<ServicesScreen> {
//   static const Color _primaryBlue = Color(0xFF005B8F);
//   static const Color _accentYellow = Color(0xFFF5B700);

//   // 0 = All, 1 = Restaurants&Cafe, 2 = Shops
//   int _selectedFilter = 0;

//   // بيانات ديمو شبه التصميم بتاع فيجما
//   final List<Map<String, dynamic>> _demoPlaces = [
//     {
//       "name": "Sky Dine Lounge",
//       "category": "restaurant",
//       "type": "Restaurant – Terminal 2",
//       "rating": 4.6,
//       "open": "24 Hours",
//       "cuisine": "International & Egyptian",
//       "about":
//           "Experience world-class dining with panoramic views of the runway. Sky Dine Lounge offers a fusion of international and Egyptian cuisine, perfect for pre-flight relaxation.",
//       "location": "Terminal 2 – Near Gate E05",
//     },
//     {
//       "name": "SkyBite Café",
//       "category": "restaurant",
//       "type": "Coffee & Snacks – Terminal 3",
//       "rating": 4.4,
//       "open": "Open 24 Hours",
//       "cuisine": "Sandwiches, coffee, snacks",
//       "about":
//           "Grab a quick bite or relax with freshly brewed coffee at SkyBite Café, ideal for short layovers and early flights.",
//       "location": "Terminal 3 – Near Gate F12",
//     },
//     {
//       "name": "SkyDuty Free",
//       "category": "shop",
//       "type": "Duty-Free Store – Terminal 3",
//       "rating": 4.9,
//       "open": "Open 24 Hours",
//       "cuisine": "Perfumes, cosmetics, gifts",
//       "about":
//           "Shop a wide selection of perfumes, cosmetics and premium gifts at SkyDuty Free with exclusive airport offers.",
//       "location": "Terminal 3 – Central Hall",
//     },
//   ];

//   List<Map<String, dynamic>> get _filteredPlaces {
//     if (_selectedFilter == 0) return _demoPlaces;
//     if (_selectedFilter == 1) {
//       return _demoPlaces.where((p) => p["category"] == "restaurant").toList();
//     }
//     return _demoPlaces.where((p) => p["category"] == "shop").toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _primaryBlue,
//       appBar: AppBar(
//         backgroundColor: _primaryBlue,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: const Text(
//           "Gate buddy",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SafeArea(
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 375),
//             child: Column(
//               children: [
//                 const SizedBox(height: 12),
//                 Expanded(
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.08),
//                           blurRadius: 18,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Title + subtitle
//                           const Text(
//                             "Explore Shops & Restaurants",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xFF154D71),
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           const Text(
//                             "Discover dining and shopping options available at NIA Airport.",
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.black87,
//                               height: 1.4,
//                             ),
//                           ),
//                           const SizedBox(height: 16),

//                           // Search bar
//                           Container(
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFF6F8FC),
//                               borderRadius: BorderRadius.circular(24),
//                               border: Border.all(
//                                 color: const Color(0xFFE3E7F1),
//                               ),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 14,
//                               vertical: 4,
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     "Search by name or category...",
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   width: 32,
//                                   height: 32,
//                                   decoration: BoxDecoration(
//                                     color: _accentYellow,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Icon(
//                                     Icons.search,
//                                     size: 18,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 16),

//                           // Filter chips
//                           Row(
//                             children: [
//                               _buildFilterChip("ALL", 0),
//                               const SizedBox(width: 5),
//                               _buildFilterChip(
//                                 "Restaurants & Café",
//                                 1,
//                               ), // 👈 بقت 1
//                               const SizedBox(width: 5),
//                               _buildFilterChip(
//                                 "Shops",
//                                 2,
//                               ), // 👈 فضلت 2 زي ما هي
//                             ],
//                           ),

//                           const SizedBox(height: 16),

//                           // Top Picks
//                           const Text(
//                             "⭐ Top Picks of the Day",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: 14,
//                               color: Color(0xFF154D71),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           SizedBox(
//                             height: 90,
//                             child: ListView.separated(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: _demoPlaces.length,
//                               separatorBuilder: (_, __) =>
//                                   const SizedBox(width: 8),
//                               itemBuilder: (context, index) {
//                                 return ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Container(
//                                     width: 120,
//                                     color: Colors.grey.shade300,
//                                     child: const Icon(
//                                       Icons.image,
//                                       size: 32,
//                                       color: Colors.white70,
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           const SizedBox(height: 16),

//                           // List of places
//                           Expanded(
//                             child: ListView.builder(
//                               itemCount: _filteredPlaces.length,
//                               itemBuilder: (context, index) {
//                                 final place = _filteredPlaces[index];
//                                 return _PlaceCard(
//                                   place: place,
//                                   primaryBlue: _primaryBlue,
//                                   accentYellow: _accentYellow,
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterChip(String label, int value) {
//     final bool isSelected = _selectedFilter == value;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             _selectedFilter = value;
//           });
//         },
//         child: Container(
//           height: 32,
//           decoration: BoxDecoration(
//             color: isSelected ? _accentYellow : Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: isSelected ? Colors.transparent : const Color(0xFFE3E7F1),
//             ),
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: isSelected ? _primaryBlue : Colors.grey.shade700,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _PlaceCard extends StatelessWidget {
//   final Map<String, dynamic> place;
//   final Color primaryBlue;
//   final Color accentYellow;

//   const _PlaceCard({
//     required this.place,
//     required this.primaryBlue,
//     required this.accentYellow,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFFE3E7F1)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Row(
//           children: [
//             // صورة المكان
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Container(
//                 width: 80,
//                 height: 80,
//                 color: Colors.grey.shade300,
//                 child: const Icon(Icons.image, size: 30, color: Colors.white70),
//               ),
//             ),
//             const SizedBox(width: 10),
//             // تفاصيل المكان
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Name: ${place["name"]}",
//                     style: TextStyle(
//                       color: primaryBlue,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 13,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     "Type: ${place["type"]}",
//                     style: const TextStyle(fontSize: 11, color: Colors.black87),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     "Rating: ${place["rating"]}",
//                     style: const TextStyle(fontSize: 11, color: Colors.black87),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     "Open: ${place["open"]}",
//                     style: const TextStyle(fontSize: 11, color: Colors.black87),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     "Cuisine: ${place["cuisine"]}",
//                     style: const TextStyle(fontSize: 11, color: Colors.black87),
//                   ),
//                   const SizedBox(height: 6),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => ServiceDetailsScreen(place: place),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: accentYellow,
//                         padding: const EdgeInsets.symmetric(horizontal: 18),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: const Text(
//                         "View details",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
