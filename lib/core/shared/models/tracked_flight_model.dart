class TrackedFlightModel {
  final String airline;
  final String flightNo;
  final String gate;
  final String status;
  final String statusColorHex;
  final String time;
  final String date;
  final String route;
  final String terminal;
  final String logo;

  TrackedFlightModel({
    required this.airline,
    required this.flightNo,
    required this.gate,
    required this.status,
    required this.statusColorHex,
    required this.time,
    required this.date,
    required this.route,
    required this.terminal,
    required this.logo,
  });

  factory TrackedFlightModel.fromJson(Map<String, dynamic> json) {
    return TrackedFlightModel(
      airline: json['airline'] ?? '',
      flightNo: json['flight_no'] ?? '',
      gate: json['gate'] ?? '',
      status: json['status'] ?? '',
      statusColorHex: json['status_color'] ?? '#808080',
      time: json['time'] ?? '',
      date: json['date'] ?? '',
      route: json['route'] ?? '',
      terminal: json['terminal'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "airline": airline,
        "flight_no": flightNo,
        "gate": gate,
        "status": status,
        "status_color": statusColorHex,
        "time": time,
        "date": date,
        "route": route,
        "terminal": terminal,
        "logo": logo,
      };
}