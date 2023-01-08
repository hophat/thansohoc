import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:html/parser.dart';

import '../generated/l10n.dart';

class box_card extends StatelessWidget {
  final data_box;
  final dinh;

  const box_card({this.data_box, this.dinh});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var data_4 = data_box.data['entries'][0];
    return Card(
      color: Color(0x000d2421),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              dinh +" "+ S.of(context).tuoi,
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
          ListTile(
            title: Text(
              S.of(context).phat_trien_theo_so + ": " +data_4["dinh_cao_key"],
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
          ListTile(
            title: Text(
              S.of(context).noi_bat,
              style: TextStyle(fontSize: 22, color: Colors.yellow),
            ),
            subtitle: Html(
              style: {
                // tables will have the below background color
                "body": Style(
                  color: Colors.white,
                ),
              },
              data: parse(data_4['dinh_cao_tom_tat']).outerHtml,
            ),
          ),
        ],
      ),
    );
  }
}
