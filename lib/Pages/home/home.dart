import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/detail/detail.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/setting/setting.dart';
import 'package:flutter_app_than_so_hoc_2/class/Res.dart';
import 'package:flutter_app_than_so_hoc_2/generated/l10n.dart';
import 'package:flutter_app_than_so_hoc_2/network/tsh_client.dart';

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
  static DateTime dateCur = DateTime.parse('1996-01-01');
  late String ngay;
  late String thang;
  late String nam;
  late int dateValue;
  String get lang => Intl.getCurrentLocale().toString();

  InterstitialAd? _interstitialAd;

  _createInterstitialAd() {
    InterstitialAd.load(
        // adUnitId: 'ca-app-pub-3940256099942544/1033173712',//test
        adUnitId: AdMobService.instance.InterstitialAdUnitId,
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
    // lang = Intl.getCurrentLocale().toString();
    this._get_birh_date();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
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

    dateValue = await tinh_scd(DateFormat('yyyyMMdd').format(dateCur));
    ngay = DateFormat('dd').format(dateCur);
    thang = DateFormat('MM').format(dateCur);
    nam = DateFormat('yyyy').format(dateCur);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('birh_date_store', dateCur.toString());
    String path = 'collections/get/tsh_sochudao';
    var bodyHttp = jsonEncode({
      "filter": {
        "scd_number": dateValue.toString(),
        "lang": lang
      }
    });

    TSHClient.instance.dio.post<String>(path, data: bodyHttp).then((response){
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
        child: Stack(
          children: [
            Center(
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

            Positioned(
              top: 15 *2,
              right: 15,
             child: IconButton(
                 onPressed: () {
                   showModalBottomSheet(
                       context: context, builder: (_) => settingPage());
                 },
                 icon: Icon(Icons.language, color: Colors.white,)),
            )
          ],
        ),
      ),
    );
  }
}
