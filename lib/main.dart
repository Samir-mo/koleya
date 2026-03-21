import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koleya/cubit/app_cubit.dart';
import 'package:koleya/data/api/api_client.dart';
import 'package:koleya/data/storage/storage_helper.dart';
import 'package:koleya/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageHelper.init();
  ApiClient.setupInterceptors();

  runApp(const SmartAirportApp());
}

class SmartAirportApp extends StatelessWidget {
  const SmartAirportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gate Buddy',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        initialRoute: Routes.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}