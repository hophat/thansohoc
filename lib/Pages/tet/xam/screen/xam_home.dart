import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:gieoque/const.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:screenshot/screenshot.dart';

import '../widget/result.dart';
import '../widget/tet_background.dart';
import '../widget/xam.dart';

class XamHome extends StatefulWidget {
  const XamHome({Key? key}): super(key: key);

  @override
  State<XamHome> createState() => _XamHomeState();
}

class _XamHomeState extends State<XamHome> {
  bool result = false;
  bool isShakingInstruct = true;
  final txtColor = const Color(0xFFFFF385);
  ScreenshotController _screenshotController = ScreenshotController();
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    isShakingInstruct = false;
    // isShakingInstruct = globalShared.getBool(instructionKey) ?? true;
    // isShakingInstruct = true;
  }
  Uint8List? _imgBytes;
  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: (){
          _screenshotController.capture().then((capturedImage) {
            _imgBytes = capturedImage;
            if (capturedImage != null) {
              print('_screenshotController Capture Done');
              setState(() {

              });
            }
          }).catchError((onError) {
            print('_screenshotController Capture Error');
          });
        }),
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
                            Text('Lắc mạnh phone để lấy quẻ', style: GoogleFonts.livvic(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: txtColor,
                            ),),
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
                              onRetry: () {
                                result = false;
                                setState(() {});
                              },
                            ),
                    ),
            ),

            // _imgBytes != null ? Positioned.fill(
            //   child: Image.memory(_imgBytes!, fit: BoxFit.cover,),
            // ) : const SizedBox.shrink(),
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
