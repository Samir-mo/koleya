import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gate_buddy/data/repositories/dashboard_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../api/dio_factory.dart';
import '../config/app_config.dart';
import '../networking/network_info.dart';
import '../service/secure_storage.dart';
import '../utils/app_constants.dart';

final getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  // --- External ---
  getIt.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  final FlutterSecureStorage flutterSecureStorage =
      const FlutterSecureStorage();

  if (!getIt.isRegistered<SecureStorage>()) {
    getIt.registerLazySingleton<SecureStorage>(
      () => SecureStorage(flutterSecureStorage),
    );
  }

  // --- Core ---
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // --- Dio ---
  getIt.registerLazySingleton<Dio>(
    () => DioFactory.create(
      baseUrl: AppConfig.baseUrl,
      getToken: () =>
          getIt<SecureStorage>().read(key: AppConstants.userDataKey),
      enableLogging: AppConfig.enableLogging,
    ),
  );

  // --- Repositories ---
  getIt.registerLazySingleton(() => DashboardRepository());

  // --- Use Cases ---
  // getIt.registerFactory(() => LoginUseCase(getIt()));
}
