import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_18_final_project/core/config/app_constants.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/app_router.dart';
import 'package:team_18_final_project/core/utils/app_theme.dart';
import 'package:team_18_final_project/features/settings/logic/language_cubit.dart';
import 'package:team_18_final_project/features/settings/logic/theme_cubit.dart';
import 'package:team_18_final_project/l10n/app_localizations.dart';

class AppProvidersWrapper extends StatelessWidget {
  const AppProvidersWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LanguageCubit>(
      create: (context) => sl<LanguageCubit>(),
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, languageState) {
          final Locale appLocale = Locale(languageState.languageCode);

          return BlocProvider<ThemeCubit>(
            create: (context) => sl<ThemeCubit>(),
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                AppTheme.setSystemUIOverlayStyle(themeState.themeMode);

// Set preferred orientations (optional - remove if you want landscape support)
                SystemChrome.setPreferredOrientations(
                    AppConstants.allowedOrientations);

                return ScreenUtilInit(
                  designSize: AppConstants.designSize,
                  minTextAdapt: true,
                  splitScreenMode: true,
                  builder: (_, __) {
                    return MaterialApp.router(
                      title: AppConstants.appTitle,
                      debugShowCheckedModeBanner: false,

                      locale: appLocale,
                      supportedLocales: AppLocalizations.supportedLocales,
                      localizationsDelegates: const [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],

                      theme: AppTheme.lightTheme,
                      darkTheme: AppTheme.darkTheme,
                      themeMode: themeState.themeMode,

                      routerConfig: RouteGenerator.mainRoutingInOurApp,

                      // SecureApplication blur/screenshot handling routed via observer
                      builder: (context, child) => child ?? const SizedBox(),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
