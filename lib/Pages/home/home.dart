import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/detail/detail.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/event/event_2.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/event/event_que.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/setting/setting.dart';
import 'package:flutter_app_than_so_hoc_2/class/Res.dart';
import 'package:flutter_app_than_so_hoc_2/generated/l10n.dart';
import 'package:flutter_app_than_so_hoc_2/network/tsh_client.dart';
import 'package:flutter_app_than_so_hoc_2/provider/firebase/analytics/analytics_service.dart';
import 'package:flutter_app_than_so_hoc_2/provider/local_db/shared_pref.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/admob/admob_service.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }
}

Future<int> tinh_scd(date_) async {
  var list = date_.toString().split("");
  int sum = list.fold(0, (p, c) => p + int.parse(c));
  if (sum > 11) {
    return tinh_scd(sum);
  } else {
    // print(sum);
    // return sum;
    return Future<int>.value(sum);
  }
}

extension ParseToString on LocaleType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class _MyHomePageState extends State<HomePage> {
  dynamic name;
  static DateTime dateCur = DateTime.now();
  late String ngay;
  late String thang;
  late String nam;
  late int dateValue;
  String get lang => Intl.getCurrentLocale().toString();

  InterstitialAd? _interstitialAd;

  Size get _size => MediaQuery.of(context).size;

  LocaleType get locate {
    LocaleType _l = LocaleType.en;
    if (Intl.getCurrentLocale().toString() != "en") {
      LocaleType.values.forEach((LocaleType_) {
        if (LocaleType_.toString().split('.').elementAt(1) ==
            Intl.getCurrentLocale().toString()) {
          _l = LocaleType_;
        }
      });
    }
    return _l;
  }

  _showEvent() async {
    // return;
    // AnalyticsService.I.analytics.logAppOpen();
    await showAnimatedDialog(
      context: context,
      animationType: DialogTransitionType.slideFromBottomFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 1000),
      builder: (_) => EventQue(),
    );
    _get_birh_date();
  }

  _createInterstitialAd() {
    if(Platform.isIOS) return;
    InterstitialAd.load(
        // adUnitId: 'ca-app-pub-3940256099942544/1033173712',//test
        adUnitId: AdMobService.instance.InterstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          _interstitialAd = ad;
        }, onAdFailedToLoad: (err) {
          _interstitialAd = null;
        }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // lang = Intl.getCurrentLocale().toString();
    this._get_birh_date();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _changeDate(_dateCur) async {
    setState(() {
      dateCur = _dateCur;
      myShared.setString('birh_date_store', dateCur.toString());
      if (Intl.getCurrentLocale().toString() == "vi") {
        name = DateFormat('dd-MM-yyyy').format(dateCur);
      } else {
        name = DateFormat('yyyy-MM-dd').format(dateCur);
      }
    });
  }

  void _get_birh_date() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString('birh_date_store') != null) {
        dateCur = DateTime.parse(prefs.getString('birh_date_store')!);
      }
      if (Intl.getCurrentLocale().toString() == "vi") {
        name = DateFormat('dd-MM-yyyy').format(dateCur);
      } else {
        name = DateFormat('yyyy-MM-dd').format(dateCur);
      }
    });
  }

  void _submit() async {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _createInterstitialAd();
      });
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      _createInterstitialAd();
    }
    await _interstitialAd?.show();

    // AnalyticsService.I.analytics.logAppOpen();

    dateValue = await tinh_scd(DateFormat('yyyyMMdd').format(dateCur));
    ngay = DateFormat('dd').format(dateCur);
    thang = DateFormat('MM').format(dateCur);
    nam = DateFormat('yyyy').format(dateCur);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('birh_date_store', dateCur.toString());
    String path = 'collections/get/tsh_sochudao';
    var bodyHttp = jsonEncode({
      "filter": {"scd_number": dateValue.toString(), "lang": lang}
    });

    TSHClient.instance.dio.post<String>(path, data: bodyHttp).then((response) {
      var dataDecode = jsonDecode(response.data ?? '');

      final res = Res(true, "22", dataDecode);
      res.data['ngay'] = ngay;
      res.data['thang'] = thang;
      res.data['nam'] = nam;
      print('res => ${res.data}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(res: res),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(46.0)),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/tet/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // ignore: deprecated_member_use
                    Image(
                      image: AssetImage('assets/tet/logo_home.png'),
                      height: 220,
                    ),
                    SizedBox(height: 30),
                    Text(
                      S.of(context).hay_chon_ngay_sinh_cua_ban,
                      style: TextStyle(
                        fontSize: 18,
                        color: TSHColors().primaryTextColor,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildDate(),
                    SizedBox(height: 20),
                    _buildLixiBtn(),
                    SizedBox(height: 20),
                    _buildSubmit(),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 15 * 2 + 10,
              right: 15,
              child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context, builder: (_) => settingPage());
                  },
                  icon: Image.asset('assets/tet/ic_language.png')),
            )
          ],
        ),
      ),
    );
  }

  _buildLixiBtn() => IconButton(
    onPressed: () => _showEvent(),
    iconSize: 72,
    icon: Image.asset('assets/tet/ic_lixi.png'),
  );

  _buildDate() => InkWell(
        onTap: () => DatePicker.showDatePicker(context,
            minTime: DateTime(1900, 1, 1),
            showTitleActions: true,
            onChanged: (date) {}, onConfirm: (date) {
          this._changeDate(date);
        }, currentTime: dateCur, locale: locate),
        child: Container(
          alignment: Alignment.center,
          constraints:
              BoxConstraints(minWidth: 150, maxWidth: _size.width / 1.5),
          decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: TSHColors().primaryColor,
                width: 2.0,
              )),
          padding: EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Text(
            '$name',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      );

  _buildSubmit() => InkWell(
        onTap: () => _submit(),
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          alignment: Alignment.center,
          constraints:
              BoxConstraints(minWidth: 150, maxWidth: _size.width / 2.5),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: TSHColors().gradiantBtnColor),
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 12,
          ),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              S.of(context).xem,
              style: TextStyle(
                  color: TSHColors().primaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
}
