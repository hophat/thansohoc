import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_than_so_hoc_2/provider/local_pub_sub.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// import 'package:gieoque/const.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../widget/result.dart';
import '../widget/tet_background.dart';
import '../widget/xam.dart';

class XamHome extends StatefulWidget {
  const XamHome({Key? key}) : super(key: key);

  @override
  State<XamHome> createState() => _XamHomeState();
}

class _XamHomeState extends State<XamHome> {
  bool result = false;
  bool isShakingInstruct = true;
  final txtColor = const Color(0xFFFFF385);
  ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;
  late final StreamSubscription _shareSub;

  @override
  void initState() {
    super.initState();
    _init();
    _subscribe();
  }

  @override
  void dispose() {
    _shareSub.cancel();
    super.dispose();
  }

  void _subscribe(){
    AppLocalPubSub.I.listenManyEvents(listEventName: [EventName.shareXAM], handler: (ps){
      if(!mounted) return;
      _sharingHandler();
    });
  }

  void _init() {
    isShakingInstruct = false;
    // isShakingInstruct = globalShared.getBool(instructionKey) ?? true;
    // isShakingInstruct = true;
  }

  Uint8List? _imgBytes;

  _sharingHandler() async {
    _isSharing = true;
    setState(() {});

    if (_imgBytes == null) {
      try {
        EasyLoading.show();
        _imgBytes = await _screenshotController.capture();
      } catch (_) {
      } finally {
        EasyLoading.dismiss();
      }
    }
    if (_imgBytes == null) {
      _isSharing = false;
      setState(() {});
      return;
    }

    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    File(path).writeAsBytesSync(_imgBytes!);
    final appName = Intl.getCurrentLocale().toLowerCase() == 'vi'
        ? 'Thần số học'
        : 'Numerology Birth date predict';
    final urlPath =
        'https://play.google.com/store/apps/details?id=com.boitoan.thansohoc';
    await Share.shareXFiles([XFile(path)],
        subject: appName, text: '$appName\n\n$urlPath');

    _isSharing = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        body: Stack(
          children: [
            const Positioned.fill(child: TetBackground()),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              child: isShakingInstruct
                  ? Align(
                      key: const ValueKey('instruction'),
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.black87,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/shaking_phone.json'),
                            Text(
                              'Lắc mạnh phone để lấy quẻ',
                              style: GoogleFonts.livvic(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: txtColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _submit(),
                            // ElevatedButton(
                            //   child: const Text('Bắt đầu'),
                            //   onPressed: () {
                            //     setState(() {
                            //       isShakingInstruct = false;
                            //       globalShared.setBool(instructionKey, isShakingInstruct);
                            //     });
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    )
                  : Align(
                      key: const ValueKey('xam'),
                      alignment: Alignment.center,
                      child: !result
                          ? Xam(
                              onResult: () {
                                result = true;
                                setState(() {});
                              },
                            )
                          : Result(
                              isClean: _isSharing,
                              onRetry: () {
                                result = false;
                                setState(() {});
                              },
                            ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _submit() {
    return InkWell(
      onTap: () {
        setState(() {
          isShakingInstruct = false;
          // globalShared.setBool(instructionKey, isShakingInstruct);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD2290A),
          border: Border.all(
            color: const Color(0xFFFFFF85),
            width: 4.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.all(10.0),
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.25,
          maxWidth: MediaQuery.of(context).size.width * 0.4,
        ),
        child: FittedBox(
          child: Text(
            'Bắt đầu',
            style: GoogleFonts.livvic(
              // fontSize: 12,
              fontWeight: FontWeight.w600,
              color: txtColor,
            ),
          ),
        ),
      ),
    );
  }
}
