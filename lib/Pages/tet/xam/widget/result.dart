import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/provider/local_pub_sub.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../../generated/l10n.dart';
import '../../splash/screen/splash.dart';

class Result extends StatefulWidget {
  final Function() onRetry;
  final bool isClean;

  const Result({Key? key, required this.onRetry, this.isClean = false})
      : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {

  List<String> resultData = [];


  final Color txtColor = const Color(0xFF4E1C00);
  bool _isShowBtn = false;
  int _resultIndex = 0;

  bool get isClean => widget.isClean;

  @override
  void initState() {
    super.initState();

    final rd = Random();
    _resultIndex = rd.nextInt(25);
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      setState(() {
        if(!mounted) return;
        _isShowBtn = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    resultData = [
      S.of(context).chuc_tet_mean_1,
      S.of(context).chuc_tet_mean_2,
      S.of(context).chuc_tet_mean_3,
      S.of(context).chuc_tet_mean_4,
      S.of(context).chuc_tet_mean_5,
      S.of(context).chuc_tet_mean_6,
      S.of(context).chuc_tet_mean_7,
      S.of(context).chuc_tet_mean_8,
      S.of(context).chuc_tet_mean_9,
      S.of(context).chuc_tet_mean_10,
      S.of(context).chuc_tet_mean_11,
      S.of(context).chuc_tet_mean_12,
      S.of(context).chuc_tet_mean_13,
      S.of(context).chuc_tet_mean_14,
      S.of(context).chuc_tet_mean_15,
      S.of(context).chuc_tet_mean_16,
      S.of(context).chuc_tet_mean_17,
      S.of(context).chuc_tet_mean_18,
      S.of(context).chuc_tet_mean_19,
      S.of(context).chuc_tet_mean_20,
      S.of(context).chuc_tet_mean_21,
      S.of(context).chuc_tet_mean_22,
      S.of(context).chuc_tet_mean_23,
      S.of(context).chuc_tet_mean_24,
      S.of(context).chuc_tet_mean_25,
    ];
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      // key: UniqueKey(),
      duration: const Duration(milliseconds: 1000),
      tween: Tween<double>(begin: 0.5, end: 1.0),
      curve: Curves.fastEaseInToSlowEaseOut,
      builder: (_, v, c) {
        return Transform.scale(
          // offset: Offset(0, -(400.0 * v).h),
          scaleY: v,
          alignment: Alignment.topCenter,
          child: c,
        );
      },
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            height: 341.h,
            left: 20.w,
            right: 20.w,
            top: 0,
            child: Image.asset('assets/chuc_mung.png'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 100.w),
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      (_resultIndex+1).toString(),
                      style: GoogleFonts.livvic().copyWith(
                          fontSize: 50,
                          color: txtColor,
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      resultData[_resultIndex],
                      style: Theme.of(context)
                          // style: GoogleFonts.caveatTextTheme()
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: txtColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
          ),
         Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isShowBtn
                  ? isClean
                      ? 0
                      : 1
                  : 0,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFD2290A),
                          side: const BorderSide(
                            color: Color(0xFFFFFF85),
                            width: 4.0,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
                          return const XamSplashScreen();
                        }),);
                        // widget.onRetry.call();
                      },
                      child: Text(
                        S.of(context).xam_new,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFFFF85),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFD2290A),
                          side: const BorderSide(
                            color: Color(0xFFFFFF85),
                            width: 4.0,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      onPressed: () {
                        AppLocalPubSub.I.emitEvent(LocalPubSub(EventName.shareXAM));
                      },
                      child: Text(
                        S.of(context).share,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFFFF85),
                        ),
                    ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

