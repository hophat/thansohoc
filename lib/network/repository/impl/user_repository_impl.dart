import 'package:either_dart/src/either.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/base_response.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/res_model/default_token.dart';
import 'package:flutter_app_than_so_hoc_2/network/path/tsh_path.dart';
import 'package:flutter_app_than_so_hoc_2/network/repository/user_repository.dart';
import 'package:flutter_app_than_so_hoc_2/network/tsh_client.dart';

class UserRepositoryImpl implements UserRepository {
  final TSHClient _service;

  UserRepositoryImpl(TSHClient service) : _service = service;

  @override
  Future<Either<BaseResponse, DefaultToken>> fetchDefaultToken() async {
    try {
      return await _service.getSingleData(
        TSHPath.I.defaultToken.v1,
        dataFactory: (json) {
          if (json['data'] == null) {
            return Left(BaseResponse.serverErr());
          }
          return DefaultToken(
            token: json['data'] ?? '',
          );
        },
      );
    } catch (_) {
      return Left(BaseResponse.serverErr());
    }
  }
}
