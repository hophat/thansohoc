import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/app/locator/app_locator.dart';
import 'package:flutter_app_than_so_hoc_2/class/Res.dart';
import 'package:flutter_app_than_so_hoc_2/main.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/base_response.dart';
import 'package:flutter_app_than_so_hoc_2/provider/list_extension.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../class/Lang.dart';
import '../utils/const.dart';

typedef DataFactory<T> = T Function(Map<String,dynamic> json);

class TSHClient {
  late final Dio dio;
  final firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
  );

  Map<String, String> supportedLocales = {};
  Map<String, String> apiSupportedLocales = {};
  bool _isTet = false;
  bool get isTet => _isTet;

  List<Lang> get listLang {
    final lst = <Lang>[];
    for(final key in supportedLocales.keys) {
      lst.add(
        defaultLangs.firstWhereOrDefault(
          (e) => e.key == key,
          defaultValue: defaultLangs.first,
        ),
      );
    }
    return lst.toSet().toList();
  }

  TSHClient._() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://tsh-app.gulagi.com/api/',
      headers: {
        // 'Cockpit-Token': '235a9449e91330b05871d371121134',
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    dio = Dio(options);

    _setUpInterceptors();
  }

  _setUpInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (op, req) {
      final shared = getIt.get<SharedPreferences>();
      final defaultToken = shared.getString(defaultTokenKey) ?? '';
      if(defaultToken.isNotEmpty) {
        op.headers['Authorization'] = 'Bearer $defaultToken';
      }
      log('[REQUEST] [${op.method}] -> ${op.baseUrl}${op.path}');
      log('[REQUEST] [${op.method}] -> ${op.baseUrl}${op.path}${op.queryParameters}');
      log('[HEADER] -> ${op.headers}');
      log('[BODY] -> ${op.data}');
      req.next(op);
    }, onResponse: (op, res) {
      log('[RESPONSE] [${op.statusCode}] -> ${op.data}');
      res.next(op);
    }, onError: (err, errHandle) {
      log('[ERROR] -> [${err.message}');
      errHandle.next(err);
    }));
  }

  static TSHClient? _instance;

  static TSHClient get instance {
    _instance ??= TSHClient._();
    return _instance!;
  }

  Future<Either<BaseResponse, T>> post<T>(
      String path, {
        String rootData = 'data',
        Map<String, dynamic>? queryParam,
        Map<String, dynamic>? body,
        required DataFactory dataFactory,
      }) async {
    final response = await dio.post(
      path,
      queryParameters: queryParam,
      data: body ?? {},
    );
    final statusCode = response.statusCode ?? 0;
    if (statusCode > 200 && statusCode < 300) {
      if(response.data[rootData] == null) {
        return Left(BaseResponse(
          data: response.data,
          codeStatus: response.statusCode,
          message: "Không có dữ liệu.",
          success: response.statusCode == 200,
        ));
      }
      return Right(dataFactory.call(response.data[rootData]));
    }

    return Left(BaseResponse(
      data: response.data,
      codeStatus: response.statusCode,
      message: response.data['message'],
      success: response.statusCode == 200,
    ));
  }

  Future<Either<BaseResponse, T>> patch<T>(
      String path, {
        String rootData = 'data',
        Map<String, dynamic>? queryParam,
        Map<String, dynamic>? body,
        required DataFactory dataFactory,
      }) async {
    final response = await dio.patch(
      path,
      queryParameters: queryParam,
      data: body ?? {},
    );
    if (response.statusCode == 200) {
      // if(response.data[rootData] == null) {
      //   return Left(BaseResponse(
      //     data: response.data,
      //     codeStatus: response.statusCode,
      //     message: "Không có dữ liệu.",
      //     success: response.statusCode == 200,
      //   ));
      // }
      return Right(dataFactory.call(response.data));
    }

    return Left(BaseResponse(
      data: response.data,
      codeStatus: response.statusCode,
      message: response.data['message'],
      success: response.statusCode == 200,
    ));
  }

  Future<Either<BaseResponse, T>> get<T>(
    String path, {
    String rootData = 'data',
    Map<String, dynamic>? queryParam,
    required DataFactory dataFactory,
  }) async {
    final response = await dio.get(path, queryParameters: queryParam);
    if (response.statusCode == 200) {
      if(response.data[rootData] == null) {
        return Left(BaseResponse(
          data: response.data,
          codeStatus: response.statusCode,
          message: "Không có dữ liệu.",
          success: response.statusCode == 200,
        ));
      }
      return Right(dataFactory.call(response.data[rootData]));
    }

    return Left(BaseResponse(
      data: response.data,
      codeStatus: response.statusCode,
      message: response.data['message'],
      success: response.statusCode == 200,
    ));
  }

  Future<Either<BaseResponse, T>> getSingleData<T>(
      String path, {
        Map<String, dynamic>? queryParam,
        required DataFactory dataFactory,
      }) async {
    final response = await dio.get(path, queryParameters: queryParam);
    if (response.statusCode == 200) {
      return Right(dataFactory.call(response.data));
    }

    return Left(BaseResponse(
      data: response.data,
      codeStatus: response.statusCode,
      message: response.data['message'],
      success: response.statusCode == 200,
    ));
  }

  getConfig({String scdNumber = '2', String lang = 'en'}) async {
    final  v = await firestore
        .collection('app')
        .doc('config')
        .get();
    Map<String, dynamic> data = {};
    if (v.exists) {
      data = v.data() ?? {};
    }
    for(final key in data['api_supported_locales'] ?? {}) {
      log('api_supported_locales key -> $key');
      apiSupportedLocales[key] = key;
    }
    if(apiSupportedLocales.isEmpty) {
      supportedLocales['vi'] = 'vi';
    }

    for(final key in data['supported_locales'] ?? {}) {
      log('supported_locales key -> $key');
      supportedLocales[key] = key;
    }
    if(supportedLocales.isEmpty) {
      supportedLocales['vi'] = 'vi';
    }

    _isTet = data['is_tet'] == true;

    print('config -> ${data}');
  }

  Future<Res?> getSoChuDao({String scdNumber = '2', String lang = 'en'}) async {
    final QuerySnapshot<Map<String, dynamic>> v = await firestore
        .collection('sochudao')
        .where('scd_number', isEqualTo: scdNumber)
        .where('lang', isEqualTo: lang)
        .get();
    Map<String, dynamic> data = {};
    if (v.docs.isNotEmpty) {
      data = v.docs.first.data();
    }
    return Res(true, "22", data);
  }

  Future<Res?> getDinhCao({String dcNumber = '2', String lang = 'en'}) async {
    final QuerySnapshot<Map<String, dynamic>> v = await firestore
        .collection('dinhcao')
        .where('dinh_cao_key', isEqualTo: dcNumber)
        .where('lang', isEqualTo: lang)
        .get();
    Map<String, dynamic> data = {};
    if (v.docs.isNotEmpty) {
      data = v.docs.first.data();
    }
    return Res(true, "22", data);
  }

  Future<Res?> getNgaySinh({String snsKey = '22223344', String lang = 'en'}) async {
    var listString = snsKey.split('').map((String text) => text).toList();

    var one = '';
    var two = '';
    var three = '';
    var four = '';
    var five = '';
    var six = '';
    var seven = '';
    var eight = '';
    var nine = '';

    for (var item in listString) {
      if (int.parse(item) == 1) {
        one = one + item;
      } else if (int.parse(item) == 2) {
        two = two + item;
      } else if (int.parse(item) == 3) {
        three = three + item;
      } else if (int.parse(item) == 4) {
        four = four + item;
      } else if (int.parse(item) == 5) {
        five = five + item;
      } else if (int.parse(item) == 6) {
        six = six + item;
      } else if (int.parse(item) == 7) {
        seven = seven + item;
      } else if (int.parse(item) == 8) {
        eight = eight + item;
      } else if (int.parse(item) == 9) {
        nine = nine + item;
      }
    }

    final List<String> queryData =  [one, two, three, four, five, six, seven, eight, nine];
    queryData.removeWhere((element) => element.trim().isEmpty);

    final QuerySnapshot<Map<String, dynamic>> v = await firestore
        .collection('ngaysinh')
        .where(
          'sns_key',
          whereIn: queryData,
        )
        .where('lang', isEqualTo: lang)
        .get();
    List<Map<String, dynamic>> data = [];
    for(final doc in v.docs) {
      data.add(doc.data());
    }
    return Res(true, "22", data);
  }
}
