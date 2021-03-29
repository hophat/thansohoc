import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:html/parser.dart';

class box_card extends StatelessWidget {
  final data_box;
  final dinh;

  const box_card({Key key, this.data_box, this.dinh}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var data_4 = data_box.data['tsh_dinh_cao'][0];
    // print(data_4);
    return Card(
      color: Color(0x000d2421),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              'Ở độ tuổi: ' + dinh,
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
          ListTile(
            title: Text(
              'Số chủ đạo : ' + data_4["dinh_cao_key"],
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
          ListTile(
            title: Text(
              'Nổi bật',
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
