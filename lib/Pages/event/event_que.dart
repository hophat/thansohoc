import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/event/event_shake_que.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_theme.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shake/shake.dart';
import 'package:flutter_app_than_so_hoc_2/generated/l10n.dart';

import '../../provider/admob/admob_service.dart';

showRewardAd() async {
  if (_rewardedAd == null) {
    createRewardedAd();
    return;
  }
  _rewardedAd?.fullScreenContentCallback =
      FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        createRewardedAd();
      }, onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        createRewardedAd();
      });
  await _rewardedAd?.show(onUserEarnedReward: (ad, reward) {});
  _rewardedAd = null;
}


RewardedAd? _rewardedAd;

Future createRewardedAd() async {
  await RewardedAd.load(
      adUnitId: AdMobService.instance.rewardAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
        print('_rewardedAd $ad');
        _rewardedAd = ad;
        print('_rewardedAd $_rewardedAd');
      }, onAdFailedToLoad: (err) {
        print('_rewardedAd null $err');
        _rewardedAd = null;
      }));
}

AudioPlayer? eventAudio;

class EventQue extends StatefulWidget {
  const EventQue({Key? key}) : super(key: key);

  @override
  State<EventQue> createState() => _EventQueState();
}

extension FormatEventDate on DateTime {
  String get getDay => DateFormat('dd', Intl.getCurrentLocale()).format(this);
  String get getMonth =>
      DateFormat('MMM', Intl.getCurrentLocale()).format(this);
  String get getYear =>
      DateFormat('yyyy', Intl.getCurrentLocale()).format(this);
}

class _EventQueState extends State<EventQue>
    with SingleTickerProviderStateMixin {

  bool _isStart = false;
  bool _shaking = false;
  late DateTime currentDate;
  int _gender = 0;

  String get _genderStr {
    if (_gender == 0) return S.of(context).male;
    if (_gender == 1) return S.of(context).female;
    return S.of(context).secret;
  }

  final Duration _duration = Duration(milliseconds: 1000);
  late final Animation<double> _scaleController;
  late final Animation<double> _textController;
  late final Animation<double> _textOpacityController;
  late final Animation<double> _dateController;

  Size get _size => MediaQuery.of(context).size;
  late final AnimationController _controller;
  SizedBox get spacing => SizedBox(height: 15, width: 15);
  late final ShakeDetector detector;

  LocaleType get locate {
    LocaleType _l = LocaleType.en;
    if (Intl.getCurrentLocale().toString() != "en") {
      LocaleType.values.forEach((LocaleType_) {
        if (LocaleType_.toString().split('.').elementAt(1) ==
            Intl.getCurrentLocale().toString()) {
          _l = LocaleType_;
        }
      });
    }
    return _l;
  }

  @override
  void initState() {
    currentDate = DateTime.now();
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    );

    _scaleController = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.linear,
        ),
      ),
    );

    _textController = Tween<double>(begin: 0, end: 300).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.linear,
        ),
      ),
    );

    _textOpacityController = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.linear,
        ),
      ),
    );

    _dateController = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.5,
          1.0,
          curve: Curves.linear,
        ),
      ),
    );

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Future.delayed(const Duration(seconds: 2)).then((value) {
    //     return;
    //
    //   });
    // });

    detector = ShakeDetector.autoStart(
      shakeThresholdGravity: 1.3,
      onPhoneShake: () {
        if (!_isStart) return;
        if (_shaking) return;
        _showShakeQue();
      },
    );

    Future.delayed(const Duration(milliseconds: 1500))
        .then((value) => _controller.forward());

    _setUpAudio();

    super.initState();
  }

  _setUpAudio() {
    eventAudio = AudioPlayer();
    eventAudio?.play(AssetSource('tet/new_year_audio.wav'));
    eventAudio?.onPlayerComplete.listen((event) async{
      await eventAudio?.stop();
      eventAudio?.play(AssetSource('tet/new_year_audio.wav'));
    });
  }

  @override
  void dispose() {
    detector.stopListening();
    eventAudio?.stop();
    eventAudio?.dispose();
    eventAudio = null;
    _rewardedAd?.dispose();
    super.dispose();
  }

  _showShakeQue() async {
    _shaking = true;
    await showAnimatedDialog(
        context: context,
        animationType: DialogTransitionType.sizeFade,
        builder: (_) {
          return EventShakeQue();
        });
    _shaking = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: _size.height,
        width: _size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/tet/que_bg.png'), fit: BoxFit.cover),
        ),
        child: _isStart ? _buildQue() : _buildIntro(),
      ),
    );
  }

  _onDateClicked() {
    DatePicker.showDatePicker(context,
        minTime: DateTime(1900, 1, 1),
        showTitleActions: true,
        onChanged: (_) {}, onConfirm: (date) {
      currentDate = date;
      setState(() {});
    }, currentTime: currentDate, locale: locate);
  }

  _onGenderClicked() {
    setState(() {
      _gender++;
      if (_gender >= 3) {
        _gender = 0;
      }
    });
  }

  _buildIntro() {
    return GestureDetector(
      onTap: () {
        _controller.forward();
      },
      child: Container(
        color: Colors.black45,
        alignment: Alignment.center,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
                animation: _controller,
                child: Align(
                  alignment: Alignment(0, -0.80),
                  child: Text(
                    S.of(context).hello,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 48,
                        color: TSHColors().eventTextColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                builder: (_, c) {
                  return Opacity(
                    opacity: _textOpacityController.value,
                    child: Transform.scale(
                      scale: _scaleController.value,
                      child: Transform.translate(
                        offset: Offset(0, _textController.value),
                        child: c,
                      ),
                    ),
                  );
                }),
            AnimatedBuilder(
              animation: _controller,
              builder: (_, c) {
                return Transform.scale(
                  alignment: Alignment.topCenter,
                  scale: _scaleController.value,
                  child: Image.asset('assets/tet/meo.png'),
                );
              },
            ),
            AnimatedBuilder(
                animation: _dateController,
                child: Align(
                  alignment: Alignment(0, 0.1),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    // height: 50,
                    // width: 50,
                    decoration: TSHTheme().cardEventDecoration,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          S.of(context).date_of_birth.toUpperCase(),
                          style: TextStyle(
                              color: TSHColors().primaryTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        spacing,
                        spacing,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildItemDate(currentDate.getYear,
                                onChange: _onDateClicked),
                            spacing,
                            spacing,
                            spacing,
                            _buildItemDate(currentDate.getMonth,
                                onChange: _onDateClicked),
                            spacing,
                            spacing,
                            spacing,
                            _buildItemDate(currentDate.getDay,
                                onChange: _onDateClicked)
                          ],
                        ),
                        spacing,
                        spacing,
                        Text(
                          S.of(context).gender.toUpperCase(),
                          style: TextStyle(
                              color: TSHColors().primaryTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        spacing,
                        spacing,
                        _buildItemDate(
                          _genderStr,
                          onChange: _onGenderClicked,
                        ),
                        spacing,
                      ],
                    ),
                  ),
                ),
                builder: (_, c) {
                  return Opacity(
                    opacity: 1 - _textOpacityController.value,
                    child: Transform.scale(
                      scale: _dateController.value,
                      child: c,
                    ),
                  );
                }),
            AnimatedBuilder(
                animation: _dateController,
                child: Align(
                  alignment: Alignment(0, 0.65),
                  child: GestureDetector(
                    onTap: () => setState(() => _isStart = true),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15 * 2, vertical: 15),
                      decoration: TSHTheme().cardEventDecoration,
                      child: Text(
                        S.of(context).sowing_hexagrams,
                        style: TextStyle(
                            color: TSHColors().primaryTextColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                builder: (_, c) {
                  return Opacity(
                    opacity: 1 - _textOpacityController.value,
                    child: Transform.scale(
                      alignment: Alignment.bottomCenter,
                      scale: _dateController.value,
                      child: c,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  _buildQue() {
    return GestureDetector(
      onTap: () {
        _showShakeQue();
      },
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween<double>(begin: 0, end: 1),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset('assets/tet/meo.png'),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: TSHTheme().cardEventDecoration,
                              child: AutoSizeText(
                                S.of(context).shake_phone_to_sow_hex,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: TSHColors().primaryTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(flex: 3, child: Image.asset('assets/tet/ques.png')),
                    const SizedBox(height: 15)
                  ],
                ),
              ),
              builder: (_, v, c) {
                return Transform.scale(scale: v, child: c);
              },
            ),
            if(!Platform.isAndroid) Align(
              alignment: Alignment.topRight,
              child: IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: Image.asset('assets/tet/ic_cancel.png')),
            )
          ],
        ),
      ),
    );
  }

  _buildItemDate(String text, {Function()? onChange}) {
    return GestureDetector(
      onTap: onChange,
      onVerticalDragUpdate: (_) {
        if (onChange == null) return;
        onChange.call();
      },
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 1,
              color: TSHColors().primaryTextColor,
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                  color: TSHColors().primaryTextColor,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 1,
              color: TSHColors().primaryTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
