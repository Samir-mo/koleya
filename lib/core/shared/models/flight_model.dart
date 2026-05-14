/// نموذج الرحلة FlightModel
class FlightModel {
  final String airline;     // اسم شركة الطيران
  final String flightNo;    // رقم الرحلة
  final String from;        // المطار المغادر منه
  final String to;          // إلى أي مطار
  final String gate;        // رقم البوابة
  final String terminal;    // رقم التيرمنال
  final String status;      // حالة الرحلة (departed, landed...)
  final String time;        // الوقت
  final String date;        // التاريخ
  final String logo;        // رابط لوجو شركة الطيران

  FlightModel({
    required this.airline,
    required this.flightNo,
    required this.from,
    required this.to,
    required this.gate,
    required this.terminal,
    required this.status,
    required this.time,
    required this.date,
    required this.logo,
  });

  /// 📥 إنشاء من JSON (البيانات القادمة من السيرفر)
  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      airline: json['airline'] ?? '',
      flightNo: json['flight_no'] ?? json['flightNo'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      gate: json['gate'] ?? '',
      terminal: json['terminal']?.toString() ?? '',
      status: json['status'] ?? '',
      time: json['time'] ?? '',
      date: json['date'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  /// 📤 تحويل البيانات إلى JSON (لو عايز تبعتها في POST)
  Map<String, dynamic> toJson() => {
        "airline": airline,
        "flight_no": flightNo,
        "from": from,
        "to": to,
        "gate": gate,
        "terminal": terminal,
        "status": status,
        "time": time,
        "date": date,
        "logo": logo,
      };

  /// عرض كنص (بس للمساعدة في الطباعة أو التطوير)
  @override
  String toString() =>
      'Flight($flightNo | $from -> $to | $status @ $time | $date)';
}