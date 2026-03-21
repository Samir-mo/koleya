import 'package:flutter/material.dart';

class TrackedFlightScreen extends StatelessWidget {
  final String flightNo;
  final String airline;
  final String status;
  final String gate;
  final String time;
  final String date;
  final String from;
  final String to;
  final String terminal;

  const TrackedFlightScreen({
    super.key,
    this.flightNo = '',
    this.airline = '',
    this.status = '',
    this.gate = '',
    this.time = '',
    this.date = '',
    this.from = '',
    this.to = '',
    this.terminal = '',
  });

  static const Color _primaryBlue = Color(0xFF005B8F);
  static const Color _accentGold = Color(0xFFF3A623);

  @override
  Widget build(BuildContext context) {
    // قيم للعرض (لو فيه داتا جاية من Flights بنستخدمها، لو لأ نرجع للديمو)
    final String displayAirline = airline.isNotEmpty ? airline : 'Egypt Air';
    final String displayFlightNo =
        flightNo.isNotEmpty ? flightNo : 'MS359';
    final String displayStatus =
        status.isNotEmpty ? status : 'Boarding';
    final String displayGate = gate.isNotEmpty ? gate : 'C14';
    final String displayTime = time.isNotEmpty ? time : '11:25';
    final String displayDate = date.isNotEmpty ? date : '15 Oct 2025';
    final String displayFrom = from.isNotEmpty ? from : 'HENI';
    final String displayTo = to.isNotEmpty ? to : 'DXB';
    final String displayTerminal =
        terminal.isNotEmpty ? 'T$terminal' : 'T2';

    final bool isDelayed =
        displayStatus.toLowerCase().contains('delay');

    return Scaffold(
      backgroundColor: _primaryBlue,
      appBar: AppBar(
        backgroundColor: _primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Tracked Flight',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
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
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ===== كارت الرحلة =====
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                              border: Border.all(
                                color: const Color(0xFFE3E7F1),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // الهيدر الأزرق اللي فوق الكارت
                                Container(
                                  decoration: const BoxDecoration(
                                    color: _primaryBlue,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(14),
                                      topRight: Radius.circular(14),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // لوجو Placeholder
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.flight,
                                          size: 20,
                                          color: _primaryBlue,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              displayAirline,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              'Flight No: $displayFlightNo',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Gate: $displayGate',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDelayed
                                                  ? Colors.red.shade100
                                                  : const Color(0xFFFFF0D6),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              displayStatus,
                                              style: TextStyle(
                                                color: isDelayed
                                                    ? Colors.red.shade700
                                                    : _accentGold,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // باقي تفاصيل الرحلة
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.flight_takeoff,
                                            size: 18,
                                            color: _accentGold,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            displayTime,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            displayDate,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '$displayFrom ➜ $displayTo',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            displayTerminal,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
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

                          const Spacer(),

                          // زر Cancel Tracking
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // لاحقاً تقدر تشيل الرحلة من قايمة الـ tracked
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              icon: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              label: const Text(
                                'Cancel Tracking',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
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
    );
  }
}
