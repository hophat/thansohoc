import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/detail/detail.dart';

import 'package:flutter_app_than_so_hoc_2/class/Res.dart';
import 'package:flutter_app_than_so_hoc_2/components/box_card.dart';
import 'package:flutter_app_than_so_hoc_2/generated/l10n.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HangNgayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HangNgayPageState();
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
    return Future.value(sum);
  }
}

extension ParseToString on LocaleType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class _HangNgayPageState extends State<HangNgayPage> {
  dynamic name = null;
  static dynamic today_content = null;
  static DateTime dateCur = DateTime.parse("1996-01-01");
  late String ngay;
  late String thang;
  late String nam;
  late int dateValue;
  late String lang;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // this.today_content = null;

    lang = Intl.getCurrentLocale().toString();
    this._get_birh_date();
    if (today_content == null) {
      this._submit();
    }

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

  void _changeDate(_dateCur) async {
    setState(() {
      name = DateFormat('dd-MM-yyyy').format(_dateCur);
      dateCur = _dateCur;
    });
  }

  void _submit() async {
    dateValue = await tinh_scd(DateFormat('yyyyMMdd').format(dateCur));
    nam = DateFormat('yyyy').format(dateCur);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('birh_date_store', dateCur.toString());

    EasyLoading.show(status: 'loading...');
    this.get_today(nam).then((res) => {
          // print(res)
          setState(() {
            EasyLoading.dismiss();
            today_content = res;
          })
        });
  }

  get_today(year) async {
    // lây thông tin của 4 moc thoi gian
    String url =
        'https://edu.gulagi.com/admin/api/tsh_so_ngay_sinh/get_today/?year=$year&_lang=$lang' ;
    print(url);
    Map<String, String> requestHeaders = {
      'X-Api-Key': '0B03393E2DABCA692F7458294DBAEC2F',
    };
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    // return response;
    var dataDecode = await jsonDecode(response.body);
    return Res(dataDecode['status'], dataDecode['message'], dataDecode['data']);
    // return Res.fromJson(jsonDecode(response.body));
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
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              Text(
                S.of(context).tu_vi_hom_nay,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                S.of(context).thiet_lap_ngay_sinh,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  // height: 50.0,
                  // minWidth: 200,
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Color(0x00000000)
                  ),
                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.0),
                        side: BorderSide(color: Colors.white, width: 3)),
                  ),

                ),
                  // color: Color(0x00000000),
                  // splashColor: Colors.grey,
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(13.0),
                  //     side: BorderSide(color: Colors.white, width: 3)),
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
                              size: 24, color: Colors.white),
                        ),
                        TextSpan(
                          text: '$name',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 20),
              ElevatedButton(
                // height: 60.0,
                // minWidth: 200,
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.black12)),
                  ),
                  backgroundColor: MaterialStatePropertyAll<Color>(
                    Color(0xffcdae59),
                  ),
                  padding: MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.fromLTRB(30, 14, 30, 15),
                  )
                ),
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(10.0),
                //     side: BorderSide(color: Colors.black12)),
                // color: Color(0xffcdae59),
                // // splashColor: Colors.white,
                // padding: EdgeInsets.fromLTRB(30, 14, 30, 15),
                onPressed: () {
                  this._submit();
                },
                child: Text(
                  "Setting",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              SizedBox(
                height: 20,
                width: 100,
              ),
              today_content == null
                  ? Text('')
                  : Card(
                      color: Color(0x000d2421),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              S.of(context).tu_vi_hom_nay,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.yellow,
                              ),
                            ),
                            subtitle: Html(
                              data: today_content.data,
                              style: {
                                // tables will have the below background color
                                "body": Style(
                                  color: Colors.white,
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
