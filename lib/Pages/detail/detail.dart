import 'dart:convert';

import 'package:flutter_app_than_so_hoc_2/Pages/detail/tabs/diengiai_tab3.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/detail/tabs/tab1.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/detail/tabs/tab2.dart';
import 'package:flutter_app_than_so_hoc_2/network/tsh_client.dart';
import 'package:flutter_app_than_so_hoc_2/network/tsh_client2.dart';
import 'package:flutter_app_than_so_hoc_2/provider/admob/admob_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';

import '../../class/Res.dart';
import '../../generated/l10n.dart';

class DetailPage extends StatefulWidget {
  final Res res;

  const DetailPage({required this.res});
  @override
  State<StatefulWidget> createState() {
    return _MyDetailPage();
  }
}

Future<int> tinh_scd(date_) async {
  var list = date_.toString().split("");
  int sum = list.fold(0, (p, c) => p + int.parse(c));
  if (sum > 11) {
    return tinh_scd(sum);
  } else {
    return Future.value(sum);
  }
}

Future<int> tinh_dinh_cao_1(date_) async {
  var list = date_.toString().split("");
  int sum = list.fold(0, (p, c) => p + int.parse(c));
  if (sum > 9) {
    return tinh_scd(sum);
  } else {
    return Future.value(sum);
  }
}

get4(dinh_cao, lang) async {
  // lây thông tin của 4 moc thoi gian
  var path = 'collections/get/tsh_dinhcao';
  var bodyHttp = jsonEncode({
    "filter": {"dinh_cao_key": dinh_cao.toString(), "lang": lang}
  });
  final response =
      await TSHClient.instance.dio.post<String>(path, data: bodyHttp);

  var dataDecode = await jsonDecode(response.data ?? '');
  return Res(true, "ok", dataDecode);
}

class _MyDetailPage extends State<DetailPage> {
  String lang = Intl.getCurrentLocale().toString();

  dynamic thang;
  dynamic ngay;
  dynamic nam;

  dynamic data1;
  dynamic data2;
  dynamic data3;
  dynamic data4;
  dynamic data_tab3;

  dynamic dinh_1, tuoi_1;
  dynamic dinh_2, tuoi_2;
  dynamic dinh_3, tuoi_3;
  dynamic dinh_4, tuoi_4;
  loaded(ngay_, thang_, nam_) async {
    var ngay_temp = await tinh_dinh_cao_1(ngay_);
    var thang_temp = await tinh_dinh_cao_1(thang_);
    var nam_temp = await tinh_dinh_cao_1(nam_);
    dinh_1 = await lay_dinh_1(ngay_temp + thang_temp);
    dinh_2 = await lay_dinh_1(thang_temp + nam_temp);
    dinh_3 = await tinh_scd(dinh_1 + dinh_2);
    dinh_4 = await tinh_scd(ngay_temp + nam_temp);
  }

  BannerAd? _banner;

  _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.banner,
      adUnitId: AdMobService.instance.bannerAdUnitId,
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      listener: AdMobService.instance.bannerAdListener,
      request: AdRequest(),
    );
    _banner?.load();
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _createBannerAd();
    super.initState();

    ngay = widget.res.data['ngay'];
    thang = widget.res.data['thang'];
    nam = widget.res.data['nam'];

    this.loaded(ngay, thang, nam).then((res) {
      get4(dinh_1, lang).then((res) {
        setState(() {
          data1 = res;
        });
      });

      get4(dinh_2, lang).then((res) {
        setState(() {
          data2 = res;
        });
      });

      get4(dinh_3, lang).then((res) {
        setState(() {
          data3 = res;
        });
      });

      get4(dinh_4, lang).then((res) {
        setState(() {
          data4 = res;
        });
      });
    });

    get_so_ngay_sinh(ngay + thang + nam, lang).then((res) {
      setState(() {
        data_tab3 = res.data;
      });
    });
  }

  // ignore: non_constant_identifier_names
  lay_dinh_1(scdNumber) async {
    return await tinh_dinh_cao_1(scdNumber);
  }

  Widget build(BuildContext context) {
    var data = widget.res.data['entries'][0];
    var scdNumber = data['scd_number'];
    var scdMucDich = parse(data['scd_muc_dich']);
    var scdDacDiemNoiBat = parse(data['scd_dac_diem_noi_bat']);
    var scdUuDiem = parse(data['scd_uu_diem']);
    var scdKhuyetDiem = parse(data['scd_khuyet_diem']);
    var scdDeXuatPhatTrien = parse(data['scd_de_xuat_phat_trien']);
    var scdNgheNghiep = parse(data['scd_nghe_nghiep']);

    tuoi_1 = 36 - int.parse(scdNumber);
    tuoi_2 = tuoi_1 + 9;
    tuoi_3 = tuoi_2 + 9;
    tuoi_4 = tuoi_3 + 9;

    Widget tab1 = tab1_Page(
      scdNumber: scdNumber,
      scdDacDiemNoiBat: scdDacDiemNoiBat,
      scdDeXuatPhatTrien: scdDeXuatPhatTrien,
      scdMucDich: scdMucDich,
      scdKhuyetDiem: scdKhuyetDiem,
      scdNgheNghiep: scdNgheNghiep,
      scdUuDiem: scdUuDiem,
    );

    Widget tab2 = diengiai_tab2_Page(
        data1: data1,
        data2: data2,
        data3: data3,
        data4: data4,
        tuoi_1: tuoi_1,
        tuoi_2: tuoi_2,
        tuoi_3: tuoi_3,
        tuoi_4: tuoi_4);

    Widget tab3 =
        diengiai_tab3_Page(data_3: data_tab3, MyDate: ngay + thang + nam);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).tong_quan),
              Tab(text: S.of(context).moc_cuoc_doi),
              Tab(text: S.of(context).bieu_do_ngay_sinh),
            ],
          ),
          title: Text(S.of(context).so + ' $scdNumber'),
          backgroundColor: Color(0xff000d24),
        ),
        body: TabBarView(
          children: [
            tab1,
            tab2,
            tab3,
          ],
        ),
        bottomNavigationBar: _banner == null
            ? SizedBox.shrink()
            : Container(
                // margin: const EdgeInsets.only(bottom: 12),
                height: _banner?.size.height.toDouble(),
                width: _banner?.size.width.toDouble(),
                child: AdWidget(ad: _banner!),
              ),
      ),
    );
  }
}

get_so_ngay_sinh(sns_key, lang) async {
  // lây thông tin của 4 moc thoi gian
  // var url = 'http://apitwo.gulagi.com/ngaysinh?date=$sns_key&appLang=$lang';
  var path = 'ngaysinh?date=$sns_key&appLang=$lang';
  // final response = await http.get(Uri.parse(url));
  final response = await TSHClient2.instance.blankGet<String>(path);
  var dataDecode = await jsonDecode(response.data ?? '');
  return Res(true, "ok", dataDecode);
}
