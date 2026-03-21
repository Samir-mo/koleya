import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/financial_cubit.dart';
import '../../cubit/financial_state.dart';
import '../../data/repositories/services_repository.dart';

const Color kPrimaryBlue = Color(0xFF002D6B)
;
const Color kAccentYellow = Color(0xFFEDB046);

class FinancialServicesScreen extends StatefulWidget {
  const FinancialServicesScreen({super.key});

  @override
  State<FinancialServicesScreen> createState() =>
      _FinancialServicesScreenState();
}

class _FinancialServicesScreenState extends State<FinancialServicesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabs = ["ATMs", "Banks", "Currency Exchange"];

  // ===== Mock Data مؤقتاً بدل الـ API =====
  final List<Map<String, String>> _atms = [
    {
      "title": "National Bank of Egypt ATM",
      "location": "Terminal 1 – Gate A",
      "status": "Busy",
    },
    {
      "title": "CIB ATM",
      "location": "Terminal 2 – Arrival Hall",
      "status": "Available",
    },
  ];

  final List<Map<String, String>> _banks = [
    {
      "title": "National Bank of Egypt",
      "location": "Terminal 3 – Mezzanine Floor",
      "status": "Available",
    },
    {
      "title": "QNB Bank",
      "location": "Terminal 2 – Check-in Area",
      "status": "Busy",
    },
  ];

  final List<Map<String, String>> _currencyExchange = [
    {
      "title": "Forex Exchange",
      "location": "Terminal 3 – Arrival Hall",
      "status": "Available",
    },
    {
      "title": "Currency Exchange Point",
      "location": "Terminal 1 – Departure Zone",
      "status": "Busy",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // ⛔ هنا مش بننادي على الـ API دلوقتي
      create: (_) => FinancialCubit(ServicesRepository()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Financial Services",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryBlue,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor:const Color(0xFFEDB046)
,
            indicatorWeight: 3,
            labelColor:const Color(0xFFEDB046)
, // الـ Tab المفتوحة (ATMs مثلاً)
            unselectedLabelColor: Colors.white, // التابات المقفولة
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            tabs: tabs.map((t) => Tab(text: t)).toList(),
            onTap: (index) {
              // لما ترجع الـ API ممكن ترجع تستعمل السطر ده:
              // final cat = tabs[index];
              // context.read<FinancialCubit>().loadFinancialServices(cat);
            },
          ),
        ),
        body: BlocBuilder<FinancialCubit, FinancialState>(
          builder: (context, state) {
            // دلوقتي متجاهلين الـ state وبنستخدم UI ثابت لحد ما الـ API يشتغل
            return TabBarView(
              controller: _tabController,
              children: [
                _buildFinancialList(_atms),
                _buildFinancialList(_banks),
                _buildFinancialList(_currencyExchange),
              ],
            );
          },
        ),
      ),
    );
  }

  // ===== UI لكل تاب =====
  Widget _buildFinancialList(List<Map<String, String>> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          "لا توجد خدمات مالية حالياً",
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: Colors.grey.shade300,
      ),
      itemBuilder: (context, i) {
        final item = items[i];
        final status = item["status"] ?? "";
        final bool isAvailable = status.toLowerCase() == "available";

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon + Texts
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // أيقونة ATM / Bank
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: kPrimaryBlue,
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 18,
                      color:Color(0xFFEDB046),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["title"] ?? "Financial Place",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item["location"] ?? "Terminal Info",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Status + Show on Map
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status pill (Busy / Available)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color:const Color(0xFFEDB046)
,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Color(0xFF002D6B)
,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: افتح خريطة المطار هنا
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color:Color(0xFFEDB046)
 , width: 1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Show on Map",
                      style: TextStyle(
                        color: kPrimaryBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
