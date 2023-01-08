import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/detail/detail.dart';

import 'package:flutter_app_than_so_hoc_2/class/Res.dart';
import 'package:flutter_app_than_so_hoc_2/generated/l10n.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static DateTime dateCur = DateTime.parse('1996-01-01');
  late String ngay;
  late String thang;
  late String nam;
  late int dateValue;
  late String lang;

  InterstitialAd? _interstitialAd;

  _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        // adUnitId: 'ca-app-pub-5726417511192387/9970372711',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              print('_createInterstitialAd');
              _interstitialAd = ad;
            },
            onAdFailedToLoad: (err) {
              _interstitialAd = null;
              print('_createInterstitialAd false');
            }
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lang = Intl.getCurrentLocale().toString();
    this._get_birh_date();
    _createInterstitialAd();
  }

  void _changeDate(_dateCur) async {
    setState(() {
      name = DateFormat('dd-MM-yyyy').format(_dateCur);
      dateCur = _dateCur;
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

    if(_interstitialAd != null){
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          _createInterstitialAd();
        }
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }else{
      _createInterstitialAd();
    }
    await _interstitialAd?.show();
    // return;

    dateValue = await tinh_scd(DateFormat('yyyyMMdd').format(dateCur));
    ngay = DateFormat('dd').format(dateCur);
    thang = DateFormat('MM').format(dateCur);
    nam = DateFormat('yyyy').format(dateCur);
    EasyLoading.show(status: 'loading...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('birh_date_store', dateCur.toString());
    // var url = 'https://edu.gulagi.com:443/admin/api/tsh_so_chu_dao/get_v2?scd_number=$dateValue&langapp=$lang';
    var url = 'http://app.gulagi.com/api/collections/get/tsh_sochudao';

    Map<String, String> requestHeaders = {
      // 'X-Api-Key': '0B03393E2DABCA692F7458294DBAEC2F',
      'Cockpit-Token':'235a9449e91330b05871d371121134',
      'Content-Type':'application/json; charset=UTF-8'
    };
    var bodyHttp = jsonEncode({
      "filter": {
        "scd_number": dateValue.toString(),
        "lang": lang
      }
    });
    http.post(Uri.parse(url), headers: requestHeaders, body: bodyHttp).then((response) {
      // http.get(url, headers: requestHeaders).then((response) {
      EasyLoading.dismiss();
      var dataDecode = jsonDecode(response.body);

      final res = Res(true, "22", dataDecode);
      // final res = Res(true, "22", dataDecode['data']);
      res.data['ngay'] = ngay;
      res.data['thang'] = thang;
      res.data['nam'] = nam;
      print('res => $res');
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
    var locate = LocaleType.en;

    if (Intl.getCurrentLocale().toString() != "en") {
      LocaleType.values.forEach((LocaleType_) {
        if (LocaleType_?.toString()?.split('.')?.elementAt(1) ==
            Intl.getCurrentLocale().toString()) {
          locate = LocaleType_;
        }
      });
    }
    return Material(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(46.0)),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg01.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // ignore: deprecated_member_use
              Image(
                image: AssetImage('assets/EYEb.png'),
                height: 220,
              ),
              SizedBox(height: 30),
              Text(
                S.of(context).hay_chon_ngay_sinh_cua_ban,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  // height: 70.0,
                  // minWidth: 250,
                 style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all<Color>(
                     Color(0x00000000),
                   ),
                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                       RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(13.0),
                           side: BorderSide(color: Colors.white, width: 3))
                   ),
                 ),
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        onChanged: (date) {}, onConfirm: (date) {
                      this._changeDate(date);
                    }, currentTime: dateCur, locale: locate);
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.date_range_outlined,
                              size: 30, color: Colors.white),
                        ),
                        TextSpan(
                          text: '$name',
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 20),
              ElevatedButton(
                // height: 60.0,
                // minWidth: 200,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.black12)),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xffcdae59),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.fromLTRB(30, 14, 30, 15),
                  )
                ),
                onPressed: () {
                  this._submit();
                },
                child: Text(
                  S.of(context).xem,
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
