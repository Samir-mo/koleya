import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gate_buddy/core/di/dependency_injection.dart';
import 'package:gate_buddy/core/widgets/splash_view.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_cubit.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_state.dart';
import 'package:gate_buddy/features/main_navigation/ui/main_scaffold.dart';
import 'package:gate_buddy/features/on_boarding/ui/onboarding_screen.dart';

import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/settings/cubit/app_settings_cubit.dart';
import 'core/settings/cubit/app_settings_state.dart';
import 'core/themes/theme_data/theme_data_dark.dart';
import 'core/themes/theme_data/theme_data_light.dart';

class GateBuddyApp extends StatelessWidget {
  const GateBuddyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (final BuildContext context, final Widget? child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AppSettingsCubit>(
              create: (final _) => AppSettingsCubit(),
            ),
            // checkAuth() runs once on startup to validate any stored token
            BlocProvider<AuthCubit>(
              create: (final _) => getIt<AuthCubit>()..checkAuth(),
            ),
          ],
          child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
            builder:
                (final BuildContext context, final AppSettingsState settings) {
                  return MaterialApp(
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: settings.locale,
                    debugShowCheckedModeBanner: false,
                    home: const _AppBootstrap(),
                    onGenerateRoute: AppRouter.generateRoute,
                    title: AppConfig.appName,
                    theme: getLightTheme().copyWith(
                      textTheme: getLightTheme().textTheme.apply(
                        fontFamily: settings.fontFamily,
                      ),
                    ),
                    darkTheme: getDarkTheme().copyWith(
                      textTheme: getDarkTheme().textTheme.apply(
                        fontFamily: settings.fontFamily,
                      ),
                    ),
                    themeMode: settings.themeMode,
                  );
                },
          ),
        );
      },
    );
  }
}

class _AppBootstrap extends StatelessWidget {
  const _AppBootstrap();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      // Only rebuild when the coarse status bucket changes
      buildWhen: (prev, curr) => prev.status != curr.status,
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.initial:
          case AuthStatus.loading:
            return const SplashView();

          case AuthStatus.authenticated:
            return const MainScaffold();

          case AuthStatus.unauthenticated:
          case AuthStatus.error:
            return const OnboardingScreen();
        }
      },
    );
  }
}
