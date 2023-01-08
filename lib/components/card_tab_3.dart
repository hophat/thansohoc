import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:html/parser.dart';
import 'package:thansohoc/generated/l10n.dart';

class card_tab_3 extends StatelessWidget {
  final content;
  final so_key;

  const card_tab_3({this.so_key, this.content});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    // print(data_4);
    return Card(
      color: Color(0x000d2421),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              so_key,
              style: TextStyle(fontSize: 26, color: Colors.white),
            ),
          ),
          ListTile(
            title: Text(
              S.of(context).giai_thich,
              style: TextStyle(fontSize: 22, color: Colors.yellow),
            ),
            subtitle: Html(
              style: {
                // tables will have the below background color
                "body": Style(
                  color: Colors.white,
                ),
              },
              data: parse(content).outerHtml,
            ),
          ),
          SizedBox(width: 100, height: 20)
        ],
      ),
    );
  }
}
