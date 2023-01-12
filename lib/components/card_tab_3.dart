import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_theme.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:html/parser.dart';

import '../generated/l10n.dart';

class card_tab_3 extends StatelessWidget {
  final content;
  final so_key;

  const card_tab_3({this.so_key, this.content});
  @override
  Widget build(BuildContext context) {
    Widget spacing = SizedBox(height: 15, width: 15);

    // print(data_4);
    return Container(
      decoration: TSHTheme().cardDecoration,
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            so_key,
            style: TextStyle(fontSize: 26, color: TSHColors().titleCardColor),
          ),
          spacing,
          Text(
            S.of(context).giai_thich,
            style: TextStyle(fontSize: 22, color: TSHColors().titleCardColor3),
          ),
          Html(
            style: {
              // tables will have the below background color
              "body": Style(
                color: TSHColors().bodyCardColor,
              ),
            },
            data: parse(content).outerHtml,
          ),
          spacing,
        ],
      ),
    );
  }
}
