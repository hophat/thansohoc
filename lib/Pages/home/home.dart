import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/detail/detail.dart';
import 'package:flutter_app_than_so_hoc_2/class/Res.dart';
import 'package:flutter_app_than_so_hoc_2/generated/l10n.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
    return Future.value(sum);
  }
}

class _MyHomePageState extends State<HomePage> {
  dynamic name;
  static DateTime dateCur = DateTime.now();
  late String ngay;
  late String thang;
  late String nam;
  late int dateValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = DateFormat('dd-MM-yyyy').format(dateCur);
  }

  void _changeDate(_dateCur) async {
    setState(() {
      name = DateFormat('dd-MM-yyyy').format(_dateCur);
      dateCur = _dateCur;
    });
  }

  void _submit() async {
    dateValue = await tinh_scd(DateFormat('yyyyMMdd').format(dateCur));
    ngay = DateFormat('dd').format(dateCur);
    thang = DateFormat('MM').format(dateCur);
    nam = DateFormat('yyyy').format(dateCur);
    EasyLoading.show(status: 'loading...');
    var url =
        'https://edu.gulagi.com:443/admin/api/tsh_so_chu_dao/all?start=0&limit=1&filter=$dateValue&field=scd_number';
    Map<String, String> requestHeaders = {
      'X-Api-Key': '0B03393E2DABCA692F7458294DBAEC2F',
    };
    http.get(url, headers: requestHeaders).then((response) {
      EasyLoading.dismiss();
      var dataDecode = jsonDecode(response.body);

      final res =
          Res(dataDecode['status'], dataDecode['message'], dataDecode['data']);
      res.data['ngay'] = ngay;
      res.data['thang'] = thang;
      res.data['nam'] = nam;
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
              FlatButton(
                  height: 70.0,
                  minWidth: 250,
                  color: Color(0x00000000),
                  splashColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0),
                      side: BorderSide(color: Colors.white, width: 3)),
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        onChanged: (date) {}, onConfirm: (date) {
                      this._changeDate(date);
                    }, currentTime: dateCur, locale: LocaleType.vi);
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
              RaisedButton(
                // height: 60.0,
                // minWidth: 200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: BorderSide(color: Colors.yellowAccent)),
                color: Color(0xffcdae59),
                // splashColor: Colors.white,
                padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                onPressed: () {
                  this._submit();
                },
                // child: Icon(
                //   Icons.ac_unit,
                //   size: 30,
                // ),
                child: Text(
                  S.of(context).xem,
                  style: TextStyle(color: Colors.black54, fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
