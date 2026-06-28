import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/api_endpoints.dart';
import 'package:gate_buddy/core/data/base_remote_ds.dart';
import '../models/home_model.dart';

class HomeRemoteDs with BaseRemoteDs {
  final ApiConsumer api;
  const HomeRemoteDs({required this.api});

  Future<HomeModel> getHomeData() =>
      execute(() async {
        final response = await api.get(ApiEndpoints.home);
        return HomeModel.fromJson(response as Map<String, dynamic>);
      });
}
