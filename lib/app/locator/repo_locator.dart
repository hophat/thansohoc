import 'package:flutter_app_than_so_hoc_2/app/locator/app_locator.dart';
import 'package:flutter_app_than_so_hoc_2/network/repository/user_repository.dart';

import '../../network/repository/impl/user_repository_impl.dart';
import '../../network/tsh_client.dart';

class RepoLocator {
  RepoLocator._();
  static RepoLocator? _instance;
  static RepoLocator get I => _instance ??= RepoLocator._();

  register(){
    getIt.registerFactory<UserRepository>(() => UserRepositoryImpl(TSHClient.instance));
  }
}