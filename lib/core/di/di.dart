import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  await _setupCore();
}

Future<void> _setupCore() async {}
