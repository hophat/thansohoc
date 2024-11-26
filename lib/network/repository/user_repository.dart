import 'package:either_dart/either.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/base_response.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/res_model/default_token.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/res_model/user_res.dart';

import '../data/req/user_req.dart';
import '../data/res_model/daily_res.dart';

abstract class UserRepository {
  Future<Either<BaseResponse, DefaultToken>> fetchDefaultToken();
  Future<Either<BaseResponse, UserRes>> fetch();
  Future<Either<BaseResponse, UserRes>> register(UserReq req);
  Future<Either<BaseResponse, UserRes>> update(UserReq req);
  Future<Either<BaseResponse, DailyRes>> daily();

}