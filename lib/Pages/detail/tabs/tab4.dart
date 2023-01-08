import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:thansohoc/class/ListNumber.dart';

class Tab4Page extends StatefulWidget {
  final MyDate;

  const Tab4Page({ this.MyDate});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _My_tab4();
  }
}

class _My_tab4 extends State<Tab4Page> {
  late ListNumber
  listNumber;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bg01.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          Center(
            child: Column(
              children: <Widget>[
                Text('BIỂU ĐỒ NGÀY SINH',
                    style: TextStyle(fontSize: 20, color: Colors.white70)),
                SizedBox(
                  height: 20,
                  width: 100,
                ),
                buildTable(listNumber)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

buildTable(ListNumber list) {
  return Table(
    border: TableBorder.all(),
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    children: <TableRow>[
      TableRow(children: [
        Container(
          height: 32,
          child: Center(
            child: Text(list.one),
          ),
          color: Colors.green,
        ),
        Container(
          height: 32,
          color: Colors.green,
          child: Center(
            child: Text(list.two),
          ),
        ),
        Container(
          height: 32,
          color: Colors.green,
          child: Center(
            child: Text(list.three),
          ),
        ),
      ]),
      TableRow(children: [
        Container(
          height: 32,
          color: Colors.green,
          child: Center(
            child: Text(list.four),
          ),
        ),
        Container(
          height: 32,
          color: Colors.green,
          child: Center(
            child: Text(list.five),
          ),
        ),
        Container(
          height: 32,
          color: Colors.green,
          child: Center(
            child: Text(list.six),
          ),
        ),
      ]),
      TableRow(children: [
        Container(
          height: 32,
          color: Colors.green,
          child: Center(
            child: Text(list.seven),
          ),
        ),
        Container(
          height: 32,
          color: Colors.green,
          child: Center(
            child: Text(list.eight),
          ),
        ),
        Container(
          height: 32,
          color: Colors.green,
          child: Center(
            child: Text(list.night),
          ),
        ),
      ]),
    ],
  );
}
