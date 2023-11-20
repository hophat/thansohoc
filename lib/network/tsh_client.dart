import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_than_so_hoc_2/class/Res.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TSHClient {
  late final Dio dio;
  final rtdb = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://thansohoc-1-default-rtdb.asia-southeast1.firebasedatabase.app/',
  );

  TSHClient._() {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://app.gulagi.com/api/',
      headers: {
        'Cockpit-Token': '235a9449e91330b05871d371121134',
        'Content-Type': 'application/json; charset=UTF-8'
      },
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

  static TSHClient? _instance;

  static TSHClient get instance {
    _instance ??= TSHClient._();
    return _instance!;
  }

  Future<Res?> getSoChuDao({String scdNumber = '2', String lang = 'en'}) async {
    final dbEvent = await rtdb
        .ref('sochudao')
        // .orderByChild('scd_number')
        .once();
    log('data -> ${dbEvent.snapshot.value}');
    // final dataDecode = jsonDecode(data.snapshot.value as Map<String, dynamic>);
    if (!dbEvent.snapshot.exists) return null;
    final dataEncode = jsonEncode(dbEvent.snapshot.value);
    final dataDecode = jsonDecode(dataEncode);
    log('res -> dataEncode ${dataEncode}');
    final Res? res;
    if (dataDecode is List) {
      final data = dataDecode.firstWhere((element) =>
              element['lang'] == lang && element['scd_number'] == scdNumber) ??
          dataDecode
              .firstWhere((element) => element['scd_number'] == scdNumber) ??
          dataDecode.first;
      res = Res(true, "22", data);
    } else {
      res = Res(true, "22", dataDecode);
    }

    return res;
  }
}
