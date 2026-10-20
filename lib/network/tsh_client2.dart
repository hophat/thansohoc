import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TSHClient2 {
  late final Dio dio;
  TSHClient2._() {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://apitwo.gulagi.com/',
      // headers: {
        // 'Cockpit-Token': '235a9449e91330b05871d371121134',
        // 'Content-Type': 'application/json; charset=UTF-8'
      // },
    );

    dio = Dio(options);

    _setUpInterceptors();
  }

  _setUpInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (op, req) {
      EasyLoading.show();
      log('[REQUEST] [${op.method}] -> ${op.baseUrl}${op.path}');
      log('[HEADER] -> ${op.headers}');
      log('[BODY] -> ${op.data}');
      req.next(op);
    }, onResponse: (op, res) {
      EasyLoading.dismiss();
      log('[RESPONSE] [${op.statusCode}] -> ${op.data}');
      res.next(op);
    }, onError: (err, errHandle) {
      EasyLoading.dismiss();
      log('[ERROR] -> [${err.message}');
      errHandle.next(err);
    }));
  }

  static TSHClient2? _instance;

  static TSHClient2 get instance {
    _instance ??= TSHClient2._();
    return _instance!;
  }

  Future<Response<T>> blankGet<T>(String path) {
    return dio.get<T>(path);
  }
}
