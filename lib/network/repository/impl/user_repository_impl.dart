import 'package:either_dart/src/either.dart';
import 'package:flutter_app_than_so_hoc_2/app/locator/app_locator.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/base_response.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/res_model/default_token.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/res_model/user_res.dart';
import 'package:flutter_app_than_so_hoc_2/network/path/tsh_path.dart';
import 'package:flutter_app_than_so_hoc_2/network/repository/user_repository.dart';
import 'package:flutter_app_than_so_hoc_2/network/tsh_client.dart';
import 'package:flutter_app_than_so_hoc_2/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/req/user_req.dart';

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

  @override
  Future<Either<BaseResponse, UserRes>> fetch() async {
    try {
      return await _service.get(
        (TSHPath.I.fetchUser +
                '/${getIt.get<SharedPreferences>().getString(deviceIDKey)}')
            .v1,
        dataFactory: UserRes.fromJson,

      );
    }catch(_){
      return Left(BaseResponse.serverErr());
    }
  }

  @override
  Future<Either<BaseResponse, UserRes>> register(UserReq req) async {
    try {
      return await _service.post(
        TSHPath.I.registerUser.v1,
        dataFactory: UserRes.fromJson,
        body: req.toJson(),
      );
    }catch(_){
      return Left(BaseResponse.serverErr());
    }
  }

  @override
  Future<Either<BaseResponse, UserRes>> update(UserReq req) async {
    try {
      return await _service.patch(
        (TSHPath.I.updateUser +
            '/${getIt.get<SharedPreferences>().getString(deviceIDKey)}')
            .v1,
        dataFactory: UserRes.fromJson,
        body: req.toJson(),
      );
    }catch(_){
      return Left(BaseResponse.serverErr());
    }
  }


}
