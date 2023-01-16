import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/event/event_que_success.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/event/event_result.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_theme.dart';
import 'package:shake/shake.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vibration/vibration.dart';

import 'event_que.dart';

class EventShakeQue extends StatefulWidget {
  const EventShakeQue({Key? key}) : super(key: key);

  @override
  State<EventShakeQue> createState() => _EventShakeQueState();
}

class _EventShakeQueState extends State<EventShakeQue>
    with TickerProviderStateMixin {
  late final AnimationController _controller,
      _controller1,
      _controller2,
      _controller3;
  late final Animation<double> _rotateController;
  late final Animation<double> _rotateController1;
  late final Animation<double> _rotateController2;
  late final Animation<double> _rotateController3;
  final Duration _duration = const Duration(milliseconds: 300);
  final Duration _duration1 = const Duration(milliseconds: 300 + 45);
  final Duration _duration2 = const Duration(milliseconds: 300 + 45 + 25);
  final Duration _duration3 = const Duration(milliseconds: 300 + 45 + 25 + 10);

  Timer? _debounce;

  final int _limitReward = 8;

  Size get _size => MediaQuery.of(context).size;

  final double tweenValue = 0.09;

  String content = '';
  String title = '';

  int count = 0;
  bool _beforeShake = true;
  bool _rewardQue = false;
  int choose = -1;
  bool _hasNext = true;

  late final ShakeDetector detector;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    );

    _controller1 = AnimationController(
      vsync: this,
      duration: _duration1,
    );

    _controller2 = AnimationController(
      vsync: this,
      duration: _duration2,
    );

    _controller3 = AnimationController(
      vsync: this,
      duration: _duration3,
    );

    _rotateController = Tween(begin: -tweenValue, end: tweenValue).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.easeInOutBack,
        ),
      ),
    );

    _rotateController1 = Tween(begin: -tweenValue, end: tweenValue).animate(
      CurvedAnimation(
        parent: _controller1,
        curve: const Interval(
          0.1,
          1.0,
          curve: Curves.easeInOutBack,
        ),
      ),
    );

    _rotateController2 = Tween(begin: -tweenValue, end: tweenValue).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: const Interval(
          0.2,
          1.0,
          curve: Curves.easeInOutBack,
        ),
      ),
    );

    _rotateController3 = Tween(begin: -tweenValue, end: tweenValue).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: const Interval(
          0.25,
          1.0,
          curve: Curves.easeInOutBack,
        ),
      ),
    );

    _controller.addStatusListener((status) {
      if (count >= _limitReward) {
        _getCount();
      }

      if (status == AnimationStatus.forward ||
          status == AnimationStatus.reverse) {
        count++;
      }
    });

    super.initState();

    detector = ShakeDetector.autoStart(
      shakeThresholdGravity: 1.3,

      onPhoneShake: () {
        _setUpShakeQue();
      },
    );

    createRewardedAd();
  }

  _getCount() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      print(count);
      // Navigator.pop(context);
      if(_rewardQue) return;
      setState(() {
        Vibration.vibrate();
        _rewardQue = true;
      });
    });
  }

  _setUpShakeQue() {
    _beforeShake = false;
    if (_controller.isAnimating) return;
    _controller.forward().then((value) => _controller.reverse());
    _controller1.forward().then((value) => _controller1.reverse());
    _controller2.forward().then((value) => _controller2.reverse());
    _controller3.forward().then((value) => _controller3.reverse());
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    print('--- Parse json from: $assetsPath');
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  @override
  void dispose() {
    detector.stopListening();
    _controller.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_rewardQue) {
      return _buildShakeQue();
    }

    if (choose == -1) {
      return EventQueSuccess(
        one: () async {
          await showRewardAd();
          choose = 1;
          Map<String, dynamic> map = await parseJsonFromAssets(
              'assets/chuc_tet/cauchuc${Random().nextInt(26) + 1}.json');

          print(map);
          title = map['title'];
          content += '\n\n';
          content += map['mean'] ?? '';
          setState(() {});
        },
        two: () async {
          await showRewardAd();
          choose = 2;
          Map<String, dynamic> map = await parseJsonFromAssets(
              'assets/chuc_tet/cauchuc${Random().nextInt(26) + 1}.json');
          print(map);
          title = map['title'];
          content = map['mean'] ?? '';
          setState(() {});
        },
      );
    }

    String numberOfQue = 'Quẻ số $choose';

    return EventResult(
      key: ValueKey(_hasNext),
      numberOfQue: numberOfQue,
      title: title,
      content: content,
      hasNext: _hasNext,
      onHasNext: (v) async {
        await showRewardAd();
        Navigator.pop(context);
      },
      onCancel: () {
        Navigator.pop(context);
      },
    );
  }

  _buildShakeQue() {
    return GestureDetector(
      onTap: () {
        _setUpShakeQue();
      },
      child: SafeArea(
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
                        decoration: TSHTheme().cardEventDecoration,
                        child: Text(
                          'Lắc phone mạnh để xin quẻ',
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
              Expanded(
                flex: 3,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, c) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Transform.rotate(
                          angle:
                              _beforeShake ? 0 : pi * _rotateController1.value,
                          alignment: Alignment(0.0, 0.3),
                          child: Opacity(
                              opacity: 0.3,
                              child: Image.asset('assets/tet/ques.png')),
                        ),
                        Transform.rotate(
                          angle:
                              _beforeShake ? 0 : pi * _rotateController2.value,
                          alignment: Alignment(0.0, 0.3),
                          child: Opacity(
                              opacity: 0.3,
                              child: Image.asset('assets/tet/ques.png')),
                        ),
                        Transform.rotate(
                          angle:
                              _beforeShake ? 0 : pi * _rotateController3.value,
                          alignment: Alignment(0.0, 0.3),
                          child: Opacity(
                              opacity: 0.3,
                              child: Image.asset('assets/tet/ques.png')),
                        ),
                        Transform.rotate(
                          angle:
                              _beforeShake ? 0 : pi * _rotateController.value,
                          alignment: Alignment(0.0, 0.3),
                          child: Image.asset('assets/tet/ques.png'),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 15)
            ],
          ),
        ),
      ),
    );
  }
}
