import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/tet/xam/screen/xam_home.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../provider/audio/audio_provider.dart';
import '../../../../provider/local_db/shared_pref.dart';
import '../../../../utils/const.dart';

class XamSplashScreen extends StatefulWidget {
  const XamSplashScreen({Key? key}): super(key: key);

  @override
  State<XamSplashScreen> createState() => _XamSplashScreenState();
}

enum GenderType {
  male,
  female,
  unknown;

  String get name {
    if (this == GenderType.male) return 'Nam';
    if (this == GenderType.female) return 'Nữ';
    return 'Bí mật';
  }
}

class _XamSplashScreenState extends State<XamSplashScreen> {
  final txtColor = const Color(0xFFFFF385);
  int step = 0;
  final _scaleDuration = const Duration(milliseconds: 500);

  DateTime currentDate = DateTime.now();

  int _genderIndex = 2;

  set genderIndex(int v) {
    if (v < 0) {
      _genderIndex = 2;
      return;
    }

    if (v > 2) {
      _genderIndex = 0;
      return;
    }
    _genderIndex = v;
  }

  GenderType get _gender => GenderType.values[_genderIndex];

  String get dayStr => currentDate.day.toString();

  String get monthStr => currentDate.month.toString();

  String get yearStr => currentDate.year.toString();

  @override
  void initState() {
    super.initState();
    final String dateStr = myShared.getString(birthDayKey) ?? '';
    final int gIndex = myShared.getInt(genderKey) ?? 2;
    currentDate = DateTime.tryParse(dateStr) ?? DateTime.now();
    genderIndex = gIndex;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (v) async {
        AudioProvider.I.stopBg();
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/bg_tet.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black54,
              ),
            ),
            AnimatedSwitcher(
              duration: _scaleDuration,
              child: step == 0 ? _hello() : _input(),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black45,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input() {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0.0, 0.0),
          child: Hero(
            key: const ValueKey('_input'),
            tag: 'xam_single',
            child: SizedBox(
              height: 250,
              child: Image.asset('assets/hu_xam_single.png'),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0.0, .6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _info(),
              const SizedBox(height: 12),
              _submit(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _submit() {
    return InkWell(
      onTap: () {
        myShared.setInt(genderKey, _genderIndex);
        myShared.setString(birthDayKey, currentDate.toIso8601String()).then((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const XamHome(),
            ),
          );
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
          maxWidth: MediaQuery.of(context).size.width * 0.3,
        ),
        child: FittedBox(
          child: Text(
            'Gieo quẻ',
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

  Widget _info() {
    Divider divider() {
      return Divider(thickness: 1, height: 5, color: txtColor);
    }

    Widget dateStr(String str) {
      return Column(
        children: [
          divider(),
          Text(
            str,
            maxLines: 1,
            style: GoogleFonts.livvic(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: txtColor,
            ),
          ),
          divider(),
        ],
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFD2290A),
        border: Border.all(
          color: const Color(0xFFFFFF85),
          width: 4.0,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ngày sinh'.toUpperCase(),
            style: GoogleFonts.livvic(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: txtColor,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                minTime: DateTime(1900, 1, 1),
                maxTime: DateTime.now(),
                onChanged: (date) {
                  currentDate = date;
                  setState(() {});
                },
                onConfirm: (date) {
                  currentDate = date;
                  setState(() {});
                },
                currentTime: currentDate,
                locale: LocaleType.vi,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: dateStr(yearStr)),
                const Expanded(child: SizedBox.shrink()),
                Expanded(child: dateStr(monthStr)),
                const Expanded(child: SizedBox.shrink()),
                Expanded(child: dateStr(dayStr)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Giới tính'.toUpperCase(),
            style: GoogleFonts.livvic(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: txtColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(child: SizedBox.shrink()),
              Expanded(
                child: InkWell(
                  onTap: () {
                    genderIndex = _genderIndex + 1;
                    setState(() {});
                  },
                  child: dateStr(_gender.name),
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
            ],
          )
        ],
      ),
    );
  }

  Widget _hello() {
    return Align(
      key: const ValueKey('_hello'),
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          step = 1;
          setState(() {});
        },
        child: TweenAnimationBuilder<double>(
          duration: _scaleDuration,
          tween: Tween<double>(begin: 0, end: 1),
          builder: (_, v, c) {
            return Transform.scale(
              scale: v,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: v == 1 ? 1 : 0,
                    duration: _scaleDuration,
                    child: Text(
                      'Xin Chào',
                      style: GoogleFonts.livvic(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: txtColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Hero(
                    tag: 'xam_single',
                    child: SizedBox(
                      height: 250,
                      child: Image.asset('assets/hu_xam_single.png'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
