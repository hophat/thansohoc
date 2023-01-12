import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_theme.dart';
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
    Widget spacing = SizedBox(height: 15, width: 15);

    var data_4 = data_box.data['entries'][0];
    return Container(
      decoration: TSHTheme().cardDecoration,
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            dinh +" "+ S.of(context).tuoi,
            style: TextStyle(fontSize: 22, color: TSHColors().titleCardColor, fontWeight: FontWeight.w600),
          ),
          Text(
            S.of(context).phat_trien_theo_so + ": " +data_4["dinh_cao_key"],
            style: TextStyle(fontSize: 22, color: TSHColors().titleCardColor2, fontWeight: FontWeight.w500 ),
          ),
          spacing,
          Text(
            S.of(context).noi_bat+':',
            style: TextStyle(fontSize: 22, color: TSHColors().titleCardColor3),
          ),
          Html(
            style: {
              // tables will have the below background color
              "body": Style(
                color: TSHColors().bodyCardColor,
              ),
            },
            data: parse(data_4['dinh_cao_tom_tat']).outerHtml,
          ),
        ],
      ),
    );
  }
}
