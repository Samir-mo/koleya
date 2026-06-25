import 'package:gate_buddy/features/home/data/remote/home_remote_ds.dart';
import 'package:gate_buddy/features/home/data/repo/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDs remoteDs;
  HomeRepoImpl({required this.remoteDs});

  @override
  Future<dynamic> getHomeData() => remoteDs.getHomeData();
}
