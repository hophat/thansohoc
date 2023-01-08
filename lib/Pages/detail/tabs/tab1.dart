import 'package:flutter_app_than_so_hoc_2/generated/l10n.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class tab1_Page extends StatefulWidget {
  final scdNumber;
  final scdDacDiemNoiBat;
  final scdMucDich;
  final scdKhuyetDiem;
  final scdDeXuatPhatTrien;
  final scdNgheNghiep;
  final scdUuDiem;

  const tab1_Page(
      {
      this.scdNumber,
      this.scdDacDiemNoiBat,
      this.scdMucDich,
      this.scdKhuyetDiem,
      this.scdDeXuatPhatTrien,
      this.scdUuDiem,
      this.scdNgheNghiep});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _My_tab1();
  }
}

class _My_tab1 extends State<tab1_Page> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber
        // image: DecorationImage(
        //   image: AssetImage("assets/bg01.jpg"),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: ListView(padding: EdgeInsets.all(30.0),
          // child: Html(data: document.outerHtml),
          children: <Widget>[
            Center(
                child: Column(
              children: [
                Text(S.of(context).con_so_chu_dao_cua_ban_la,
                    style: TextStyle(fontSize: 20, color: Colors.white70)),
                Text(widget.scdNumber,
                    style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            )),
            SizedBox(width: 15, height: 40),
            Card(
              color: Color(0x000d2421),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      S.of(context).noi_bat,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.yellow,
                      ),
                    ),
                    subtitle: Html(
                      data: widget.scdDacDiemNoiBat.outerHtml,
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
            Card(
              color: Color(0x000d2421),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    // leading: Icon(Icons.check),
                    title: Text(
                      S.of(context).muc_dich_cuoc_song,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.yellow,
                      ),
                    ),
                    subtitle: Html(
                      data: widget.scdMucDich.outerHtml,
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
            SizedBox(width: 15, height: 30),
            Card(
              color: Color(0x000d2421),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    // leading: Icon(Icons.check),
                    title: Text(
                      S.of(context).uu_diem,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.yellow,
                      ),
                    ),
                    subtitle: Html(
                      data: widget.scdUuDiem.outerHtml,
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
            Card(
              color: Color(0x000d2421),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    // leading: Icon(Icons.check),
                    title: Text(
                      S.of(context).khuyet_diem,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.yellow,
                      ),
                    ),
                    subtitle: Html(
                      data: widget.scdKhuyetDiem.outerHtml,
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
            SizedBox(width: 15, height: 30),
            // de xuat phat trien
            Card(
              color: Color(0x000d2421),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    // leading: Icon(Icons.check),
                    title: Text(
                      S.of(context).de_xuat,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.yellow,
                      ),
                    ),
                    subtitle: Html(
                      data: widget.scdDeXuatPhatTrien.outerHtml,
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
            // Nghe nghiẹp
            Card(
              color: Color(0x000d2421),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    // leading: Icon(Icons.check),
                    title: Text(
                      S.of(context).nghe_nghiep_phu_hop,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.yellow,
                      ),
                    ),
                    subtitle: Html(
                      data: widget.scdNgheNghiep.outerHtml,
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
          ]),
    );
  }
}
