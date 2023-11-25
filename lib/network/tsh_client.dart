import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_than_so_hoc_2/class/Res.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TSHClient {
  late final Dio dio;
  final firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
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
