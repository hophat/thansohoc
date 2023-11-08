import 'package:flutter_app_than_so_hoc_2/generated/l10n.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_theme.dart';
import 'package:flutter_html/flutter_html.dart';
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
      {this.scdNumber,
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

  SizedBox get spacing => SizedBox(height: 15, width: 15);

  Size get _size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
            // child: Html(data: document.outerHtml),
            children: <Widget>[
              const SizedBox(height: 5),
              Container(
                height: 180,
                // width: _size.width - 50,
                alignment: Alignment.center,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset('assets/tet/main_number_bg.png',
                        fit: BoxFit.scaleDown),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(S.of(context).con_so_chu_dao_cua_ban_la,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: TSHColors().primaryTextColor)),
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => RadialGradient(
                              colors: TSHColors().gradiantTextColor,
                              center: Alignment.center
                            ).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                            child: Text(
                              widget.scdNumber,
                              style: TextStyle(
                                  fontSize: 72, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // spacing,
                          // spacing,
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30).copyWith(top: 0),
                child: Column(
                  children: [
                    Container(
                      decoration: TSHTheme().cardDecoration,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.all(20),
                            title: Text(
                              S.of(context).noi_bat,
                              style: TextStyle(
                                fontSize: 22,
                                color: TSHColors().titleCardColor,
                              ),
                            ),
                            subtitle: Html(
                              data: widget.scdDacDiemNoiBat.outerHtml,
                              style: {
                                // tables will have the below background color
                                "body": Style(
                                  color: TSHColors().bodyCardColor,
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    spacing,
                    Container(
                      decoration: TSHTheme().cardDecoration,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            // leading: Icon(Icons.check),
                            contentPadding: EdgeInsets.all(20),
                            title: Text(
                              S.of(context).muc_dich_cuoc_song,
                              style: TextStyle(
                                fontSize: 22,
                                color: TSHColors().titleCardColor,
                              ),
                            ),
                            subtitle: Html(
                              data: widget.scdMucDich.outerHtml,
                              style: {
                                // tables will have the below background color
                                "body": Style(
                                  color: TSHColors().bodyCardColor,
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    spacing,
                    Container(
                      decoration: TSHTheme().cardDecoration,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            // leading: Icon(Icons.check),
                            contentPadding: EdgeInsets.all(20),
                            title: Text(
                              S.of(context).uu_diem,
                              style: TextStyle(
                                fontSize: 22,
                                color: TSHColors().titleCardColor,
                              ),
                            ),
                            subtitle: Html(
                              data: widget.scdUuDiem.outerHtml,
                              style: {
                                // tables will have the below background color
                                "body": Style(
                                  color: TSHColors().bodyCardColor,
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    spacing,
                    Container(
                      decoration: TSHTheme().cardDecoration,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            // leading: Icon(Icons.check),
                            contentPadding: EdgeInsets.all(20),
                            title: Text(
                              S.of(context).khuyet_diem,
                              style: TextStyle(
                                fontSize: 22,
                                color: TSHColors().titleCardColor,
                              ),
                            ),
                            subtitle: Html(
                              data: widget.scdKhuyetDiem.outerHtml,
                              style: {
                                // tables will have the below background color
                                "body": Style(
                                  color: TSHColors().bodyCardColor,
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    spacing,
                    // de xuat phat trien
                    Container(
                      decoration: TSHTheme().cardDecoration,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.all(20),
                            // leading: Icon(Icons.check),
                            title: Text(
                              S.of(context).de_xuat,
                              style: TextStyle(
                                fontSize: 22,
                                color: TSHColors().titleCardColor,
                              ),
                            ),
                            subtitle: Html(
                              data: widget.scdDeXuatPhatTrien.outerHtml,
                              style: {
                                // tables will have the below background color
                                "body": Style(
                                  color: TSHColors().bodyCardColor,
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    spacing,
                    // Nghe nghiẹp
                    Container(
                      decoration: TSHTheme().cardDecoration,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.all(20),
                            // leading: Icon(Icons.check),
                            title: Text(
                              S.of(context).nghe_nghiep_phu_hop,
                              style: TextStyle(
                                fontSize: 22,
                                color: TSHColors().titleCardColor,
                              ),
                            ),
                            subtitle: Html(
                              data: widget.scdNgheNghiep.outerHtml,
                              style: {
                                // tables will have the below background color
                                "body": Style(
                                  color: TSHColors().titleCardColor,
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
            ]),
      ),
    );
  }
}
