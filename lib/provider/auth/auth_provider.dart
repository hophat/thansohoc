import 'dart:convert';

import 'package:android_id/android_id.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_than_so_hoc_2/app/locator/app_locator.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/req/user_req.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/res_model/user_res.dart';
import 'package:flutter_app_than_so_hoc_2/network/repository/user_repository.dart';
import 'package:flutter_app_than_so_hoc_2/utils/const.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier{
  String? _defaultToken;
  String? get defaultToken => _defaultToken;
  UserRes? _userRes;
  UserRes? get user => _userRes;
  bool get isLogin => _userRes != null;

  AuthProvider() {
    final SharedPreferences prefs = getIt.get<SharedPreferences>();
    final _token = prefs.getString(defaultTokenKey) ?? '';
    final _deviceId = prefs.getString(deviceIDKey) ?? '';
    if(_deviceId.isEmpty){
      AndroidId().getId().then((deviceId) {
        if((deviceId ?? '').isEmpty) return;
        prefs.setString(deviceIDKey, deviceId!);
      });
    }

    // if(_token.isNotEmpty){
    //   _defaultToken = _token;
    //   print('AuthProvider fetch defaultToken from store: $_defaultToken');
    //   return;
    // }
    fetchDefaultToken();
  }

  fetchDefaultToken() {
    getIt.get<UserRepository>().fetchDefaultToken().then((value) {
      value.fold((l) {
        _defaultToken = null;
      }, (r) async {
        _defaultToken = r.token;
        final SharedPreferences prefs = getIt.get<SharedPreferences>();
        prefs.setString(defaultTokenKey, r.token);
        fetchUser();
      });
    });
  }

  fetchUser({bool notify = false}) {
    final SharedPreferences prefs = getIt.get<SharedPreferences>();
    try{
      _userRes = UserRes.fromJson(jsonDecode(prefs.getString(userKey) ?? ''));
    }catch(_){
      _userRes = null;
    }

    getIt.get<UserRepository>().fetch().then((value) {
      value.fold((l) {
        if(_userRes != null) return;
        _userRes = null;
      }, (r) {
        _userRes = r;
        prefs.setString(userKey, jsonEncode(_userRes?.toJson()));
        if(notify) notifyListeners();
      });
    });
  }

  register(UserReq req) async {
    final SharedPreferences prefs = getIt.get<SharedPreferences>();
    final deviceId = prefs.getString(deviceIDKey) ?? '';
    if(deviceId.isEmpty) return;
    try{
      if(EasyLoading.isShow) return;
      EasyLoading.show(status: 'Loading...');
      getIt.get<UserRepository>().register(req).then((value) {
        value.fold((l) {
          _userRes = null;
        }, (r) {
          _userRes = r;
          prefs.setString(userKey, jsonEncode(_userRes?.toJson()));
        });
      });
    }catch(_){

    }finally{
      EasyLoading.dismiss();
    }
  }

  Future<void> update(UserReq req) async {
    if(EasyLoading.isShow) return;
    try{
      EasyLoading.show(status: 'Loading...');
      final res = await getIt.get<UserRepository>().update(req);
      res.fold((l) {}, (r){
        _userRes = r;
      });
    }catch(_){
    }finally{
      EasyLoading.dismiss();
    }
  }

}