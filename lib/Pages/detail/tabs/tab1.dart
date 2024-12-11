import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_app_than_so_hoc_2/generated/l10n.dart';
import 'package:flutter_app_than_so_hoc_2/provider/local_pub_sub.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

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

class _My_tab1 extends State<tab1_Page> with AutomaticKeepAliveClientMixin{
  late final ScreenshotController _ctrl;

  ScreenshotController get ctrl => _ctrl;
  late final StreamSubscription _shareSub;
  Uint8List? _image;
  bool _isSharing = false;
  @override
  void initState() {
    // TODO: implement initState
    _ctrl = ScreenshotController();

    _subscribe();
    super.initState();
  }

  _subscribe() {
    _shareSub = AppLocalPubSub.I.listenManyEvents(
      listEventName: [EventName.shareSCD],
      handler: (ps) async {
        _isSharing = true;
        setState(() {});
        if (_image == null) {
          try{
            EasyLoading.show();
            _image = await _ctrl.capture();
          }catch(_){}finally{
            EasyLoading.dismiss();
          }
        }
        if(_image == null){
          _isSharing = false;
          setState(() {});
          return;
        }

        final temp = await getTemporaryDirectory();
        final path = '${temp.path}/${DateTime.now().millisecondsSinceEpoch}.png';
        File(path).writeAsBytesSync(_image!);
        final appName = Intl.getCurrentLocale().toLowerCase() == 'vi'
            ? 'Thần số học'
            : 'Numerology Birth date predict';
        final urlPath =
            'https://play.google.com/store/apps/details?id=com.boitoan.thansohoc';
        await Share.shareXFiles([XFile(path)],
            subject: appName,
            text: '$appName\n\n$urlPath');

        _isSharing = false;
        setState(() {});
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 2), () async {
        _isSharing = true;
        if(!mounted) return;
        setState(() {});
        if (_image == null) {
          try{
            EasyLoading.show();
            _image = await _ctrl.capture();
          }catch(_){}finally{
            _isSharing = false;
            EasyLoading.dismiss();
            setState(() {});
          }
        }
      });
    });
  }

  @override
  dispose() {
    _shareSub.cancel();
    if(EasyLoading.isShow) EasyLoading.dismiss();
    super.dispose();
  }

  SizedBox get spacing => SizedBox(height: 15, width: 15);

  Size get _size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        _screenShot(),
        _body(),
      ],
    );
  }

  _screenShot() {
    return Screenshot(
      controller: _ctrl,
      child: Opacity(
        opacity: _isSharing ? 1 : 0,
        // opacity: 1,
        child: Container(
          decoration: BoxDecoration(
            image: _isSharing
                ? DecorationImage(
                    image: AssetImage('assets/tet/bg.png'), fit: BoxFit.cover)
                : null,
          ),
          child: Column(
            children: [
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
                                    center: Alignment.center)
                                .createShader(
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
                padding: EdgeInsets.all(30).copyWith(top: 0, bottom: 0),
                child: Container(
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
              ),
              Padding(
                padding: EdgeInsets.all(30).copyWith(top: 15),
                child: Container(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  _body() {
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
                                    center: Alignment.center)
                                .createShader(
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
