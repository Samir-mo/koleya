import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gate_buddy/core/api/api_consumer.dart';
import 'package:gate_buddy/core/api/dio_consumer.dart';
import 'package:gate_buddy/data/repositories/dashboard_repository.dart';
import 'package:gate_buddy/features/indoor_map/data/remote/indoor_map_remote_ds.dart';
import 'package:gate_buddy/features/indoor_map/data/repo/indoor_map_repo.dart';
import 'package:gate_buddy/features/indoor_map/data/repo/indoor_map_repo_impl.dart';
import 'package:gate_buddy/features/indoor_map/logic/cubit/indoor_map_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../api/dio_factory.dart';
import '../config/app_config.dart';
import '../networking/network_info.dart';
import '../service/secure_storage.dart';
import '../utils/app_constants.dart';

final getIt = GetIt.instance;
Future<void> setUpDependencies() async {
  // External
  getIt.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  final storage = FlutterSecureStorage();

  getIt.registerLazySingleton<SecureStorage>(() => SecureStorage(storage));

  // Core Network
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // Dio
  getIt.registerLazySingleton<Dio>(
    () => DioFactory.create(
      baseUrl: AppConfig.baseUrl,
      getToken: () async {
        return await getIt<SecureStorage>().read(key: AppConstants.userDataKey);
      },
      enableLogging: AppConfig.enableLogging,
    ),
  );

  // --- Repositories ---
  getIt.registerLazySingleton(() => DashboardRepository());

  // --- Api ---
  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(getIt()));

  // --- Remote Data Source ---
  getIt.registerLazySingleton<IndoorMapRemoteDs>(
    () => IndoorMapRemoteDs(api: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<IndoorMapRepo>(
    () => IndoorMapRepoImpl(remoteDs: getIt()),
  );

  // Cubits
  getIt.registerLazySingleton<IndoorMapCubit>(
    () => IndoorMapCubit(indoorMapRepo: getIt()),
  );
}
