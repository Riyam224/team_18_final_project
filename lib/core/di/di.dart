import 'package:get_it/get_it.dart';
import 'package:team_18_final_project/features/settings/logic/language_cubit.dart';

import 'package:team_18_final_project/features/settings/logic/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  await _setupCore();
}

Future<void> _setupCore() async {
  //rahma settings
  sl.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(),
);

  sl.registerLazySingleton<LanguageCubit>(
    () => LanguageCubit(),
  );
}
