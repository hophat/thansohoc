import 'package:android_id/android_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/app/locator/app_locator.dart';
import 'package:flutter_app_than_so_hoc_2/network/repository/user_repository.dart';
import 'package:flutter_app_than_so_hoc_2/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier{
  String? _defaultToken;
  String? get defaultToken => _defaultToken;

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

    if(_token.isNotEmpty){
      _defaultToken = _token;
      print('AuthProvider fetch defaultToken from store: $_defaultToken');
      return;
    }
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
      });
    });
  }

}