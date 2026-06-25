class FlightModel {
  final String id;
  final String flightNo;
  final String airline;
  final String route;
  final String status;
  final String time;
  final String gate;
  final String terminal;
  final String from;
  final String to;
  final String date;

  const FlightModel({
    this.id = '',
    this.flightNo = '',
    this.airline = '',
    this.route = '',
    this.status = '',
    this.time = '',
    this.gate = '',
    this.terminal = '',
    this.from = '',
    this.to = '',
    this.date = '',
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) => FlightModel(
        id: json['_id'] ?? '',
        flightNo: json['flight_no'] ?? '',
        airline: json['airline'] ?? '',
        route: json['route'] ?? '',
        status: json['status'] ?? '',
        time: json['time'] ?? '',
        gate: json['gate'] ?? '',
        terminal: json['terminal'] ?? '',
        from: json['from'] ?? '',
        to: json['to'] ?? '',
        date: json['date'] ?? '',
      );
}
