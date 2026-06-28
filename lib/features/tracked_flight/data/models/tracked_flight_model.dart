class TrackedFlightModel {
  final String flightNo;
  final String airline;
  final String status;
  final String gate;
  final String time;
  final String date;
  final String from;
  final String to;
  final String terminal;

  const TrackedFlightModel({
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

  factory TrackedFlightModel.fromJson(Map<String, dynamic> json) =>
      TrackedFlightModel(
        flightNo: json['flight_no'] ?? '',
        airline: json['airline'] ?? '',
        status: json['status'] ?? '',
        gate: json['gate'] ?? '',
        time: json['time'] ?? '',
        date: json['date'] ?? '',
        from: json['from'] ?? '',
        to: json['to'] ?? '',
        terminal: json['terminal'] ?? '',
      );
}
