import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/class/ListNumber.dart';
import 'package:flutter_app_than_so_hoc_2/class/Res.dart';
import 'package:flutter_app_than_so_hoc_2/components/card_tab_3.dart';
import 'package:flutter_app_than_so_hoc_2/generated/l10n.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:http/http.dart' as http;

class diengiai_tab3_Page extends StatefulWidget {
  final data_3;
  final MyDate;

  const diengiai_tab3_Page({this.data_3, this.MyDate});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _My_tab3();
  }
}

class _My_tab3 extends State<diengiai_tab3_Page> {
  late ListNumber listNumber;

  SizedBox get spacing => SizedBox(height: 15, width: 15);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var listString =
        widget.MyDate.split('').map((String text) => text).toList();

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

    listNumber =
        ListNumber(one, two, three, four, five, six, seven, eight, nine);
  }

  Iterable<card_tab_3> getListCard3(List<dynamic> list) {
    return list.map((item) =>
        card_tab_3(content: item['sns_content'], so_key: item['sns_key']));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          Center(
              child: Column(
            children: <Widget>[
              // Text(S.of(context).bieu_do_ngay_sinh,
              //     style: TextStyle(fontSize: 20, color: Colors.white70)),
              spacing,
              buildTable(listNumber),
              spacing,
              Text(
                S.of(context).y_nghia_cac_con_so_tren_bieu_do,
                style: TextStyle(
                    fontSize: 18,
                    color: TSHColors().primaryTextColor,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              spacing,
              for (var item in widget.data_3) ...[
                card_tab_3(
                    content: item['sns_content'], so_key: item['sns_key']),
                spacing,
              ]
            ],
          )),
          // spacing,
          // spacing
        ],
      ),
    );
  }
}

buildTable(ListNumber list) {
  TextStyle style = TextStyle(
      color: TSHColors().primaryTextColor,
      fontWeight: FontWeight.w500,
      fontSize: 20);
  return Table(
    border: TableBorder(
      borderRadius: BorderRadius.circular(8),
      horizontalInside: BorderSide(color: TSHColors().borderCardColor),
      verticalInside: BorderSide(color: TSHColors().borderCardColor),
      bottom: BorderSide(color: TSHColors().borderCardColor),
      top: BorderSide(color: TSHColors().borderCardColor),
      left: BorderSide(color: TSHColors().borderCardColor),
      right: BorderSide(color: TSHColors().borderCardColor),
    ),
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    children: <TableRow>[
      TableRow(children: [
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8)),
          ),
          child: Center(
            child: Text(list.one, style: style),
          ),
        ),
        Container(
          height: 32,
          color: Colors.black26,
          child: Center(
            child: Text(list.two, style: style),
          ),
        ),
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.only(topRight: Radius.circular(8)),
          ),
          child: Center(
            child: Text(list.three, style: style),
          ),
        ),
      ]),
      TableRow(children: [
        Container(
          height: 32,
          color: Colors.black26,
          child: Center(
            child: Text(list.four, style: style),
          ),
        ),
        Container(
          height: 32,
          color: Colors.black26,
          child: Center(
            child: Text(list.five, style: style),
          ),
        ),
        Container(
          height: 32,
          color: Colors.black26,
          child: Center(
            child: Text(list.six, style: style),
          ),
        ),
      ]),
      TableRow(children: [
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
          ),
          child: Center(
            child: Text(list.seven, style: style),
          ),
        ),
        Container(
          height: 32,
          color: Colors.black26,
          child: Center(
            child: Text(list.eight, style: style),
          ),
        ),
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(8)),
          ),
          child: Center(
            child: Text(list.night, style: style),
          ),
        ),
      ]),
    ],
  );
}
