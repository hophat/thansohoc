import 'package:flutter_app_than_so_hoc_2/app/locator/repo_locator.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt get getIt => GetIt.instance;

Future<void> configLocator() async {
  getIt.registerLazySingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
  await GetIt.instance.isReady<SharedPreferences>();
  RepoLocator.I.register();
}