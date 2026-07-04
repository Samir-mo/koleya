class DashboardModel {
  final List<Map<String, dynamic>> flights;
  final List<Map<String, dynamic>> vipServices;
  final List<Map<String, dynamic>> assistances;
  final List<Map<String, dynamic>> discover;

  DashboardModel({
    required this.flights,
    required this.vipServices,
    required this.assistances,
    required this.discover,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      flights: List<Map<String, dynamic>>.from(json['flights'] ?? []),
      vipServices: List<Map<String, dynamic>>.from(json['vip'] ?? []),
      assistances: List<Map<String, dynamic>>.from(json['assistances'] ?? []),
      discover: List<Map<String, dynamic>>.from(json['discover'] ?? []),
    );
  }
}
