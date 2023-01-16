import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/event/event_share_image.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class EventResult extends StatefulWidget {
  final String title, content;
  final String numberOfQue;
  final bool hasNext;
  final Function(bool) onHasNext;
  final Function? onCancel;

  const EventResult(
      {Key? key,
      this.onCancel,
      required this.numberOfQue,
      required this.title,
      required this.content,
      this.hasNext = false,
      required this.onHasNext})
      : super(key: key);

  @override
  State<EventResult> createState() => _EventResultState();
}

class _EventResultState extends State<EventResult> {
  Uint8List? _image;

  SizedBox get spacing => SizedBox(height: 15, width: 15);
  Size get _size => MediaQuery.of(context).size;

  String get title => widget.title;
  String get content => widget.content;
  bool get hasNext => widget.hasNext;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(widget.onCancel!=null) {
          widget.onCancel!();
        }
        Navigator.pop(context);
        return true;
      },
      child: SafeArea(
        left: false,
        right: false,
        child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 500),
            tween: Tween<double>(begin: 0.3, end: 1),
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      if(widget.onCancel!=null) {
                        widget.onCancel!();
                      }
                      Navigator.pop(context);
                    },
                    icon: Image.asset('assets/tet/ic_cancel.png'),
                  ),
                  spacing,
                  _buildContainer(),
                  if (hasNext) ...[
                    spacing,
                    GestureDetector(
                      onTap: () => widget.onHasNext(false),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15 * 2, vertical: 15),
                        decoration: TSHTheme().cardEventDecoration,
                        child: Text(
                          'Gieo quẻ tiếp ...',
                          style: TextStyle(
                              color: TSHColors().primaryTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                  spacing,
                  GestureDetector(
                    onTap: () async {
                      // showDialog(context: context, builder: (_) {
                      //   return EventShareImage(content: content, title: title, numberOfQue: widget.numberOfQue);
                      // });
                      // return;
                      if (_image == null) {
                        EasyLoading.show();
                        _image = await screenshotController.captureFromWidget(
                            EventShareImage(
                                content: content,
                                title: title,
                                numberOfQue: widget.numberOfQue),
                            context: context);
                        EasyLoading.dismiss();
                      }
                      final temp = await getTemporaryDirectory();
                      final path = '${temp.path}/image.png';
                      File(path).writeAsBytesSync(_image!);

                      final appName =
                          Intl.getCurrentLocale().toLowerCase() == 'vi'
                              ? 'Thần số học'
                              : 'Numerology Birth date predict';
                      final urlPath =
                          'https://play.google.com/store/apps/details?id=com.boitoan.thansohoc';

                      await Share.shareXFiles([XFile(path)],
                          text: '$appName\n\n$urlPath');
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15 * 2, vertical: 15),
                        decoration: TSHTheme().cardEventDecoration,
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  color: TSHColors().primaryTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              children: [
                                WidgetSpan(
                                  child: Image.asset('assets/tet/ic_fb.png'),
                                  alignment: PlaceholderAlignment.middle,
                                ),
                                TextSpan(
                                  text: ' chia sẻ',
                                )
                              ]),
                        )),
                  ),
                  spacing,
                ],
              ),
            ),
            builder: (_, v, c) {
              return Transform.scale(
                scale: v,
                child: c,
              );
            }),
      ),
    );
  }

  _buildResult() {
    final w = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.all(35),
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/tet/bg_result.png'),
              fit: BoxFit.scaleDown),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.numberOfQue,
                style: GoogleFonts.getFont('Philosopher').copyWith(
                  fontSize: 20,
                  color: Color(0xFFE87F2B),
                  fontWeight: FontWeight.bold,
                ),
              ),
              spacing,
              spacing,
              _buildDivider(w / 2),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Text(
                  '\"$title\"',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont('Philosopher').copyWith(
                    fontSize: 24,
                    color: Color(0xFFDE3532),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _buildDivider(w),
              spacing,
              spacing,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont('Inter').copyWith(
                    fontSize: 16,
                    color: Color(0xFF843C02),
                  ),
                ),
              ),
              spacing,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/tet/ic_hoa_mai.png',
                    scale: 1.4,
                  ),
                  spacing,
                  Image.asset('assets/tet/ic_hoa_mai.png'),
                  spacing,
                  Image.asset(
                    'assets/tet/ic_hoa_mai.png',
                    scale: 1.4,
                  ),
                ],
              )
            ],
          ),
        ));
  }

  _buildDivider(double w) {
    return Container(
      margin: EdgeInsets.all(15),
      height: 1,
      width: w,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xFFEDBE72).withOpacity(0),
        Color(0xFFE1B260),
        Color(0xFFEDBE72).withOpacity(0),
      ])),
    );
  }

  _buildOpacityImage(String path) {
    return Opacity(opacity: 0.5, child: Image.asset(path));
  }

  _buildContainer() {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildResult(),
          Align(
              alignment: Alignment(-1.0, 0.0),
              child: _buildOpacityImage('assets/tet/cloud2.png')),
          Align(
              alignment: Alignment(-1.0, 0.0),
              child: _buildOpacityImage('assets/tet/cloud1.png')),
          Align(
              alignment: Alignment(1.0 - 0.2, -0.65),
              child: _buildOpacityImage('assets/tet/cloud2.png')),
          Align(
              alignment: Alignment(1.0 - 0.2, 0.65),
              child: _buildOpacityImage('assets/tet/cloud1.png')),

          // Align(
          //   alignment: Alignment(0.0, -0.5 + (!hasNext ? 0.1 : 0.0)),
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(
          //       // vertical: 50,
          //       horizontal: _size.width/4,
          //     ),
          //     child: Scrollbar(
          //       child: SingleChildScrollView(
          //         child: Column(
          //           children: [
          //             Text(title, style: TextStyle(color: TSHColors().titleCardColor3, fontSize: 20, fontWeight: FontWeight.bold),),
          //             spacing,
          //             Text(content, style: TextStyle(color: TSHColors().titleCardColor3),),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
