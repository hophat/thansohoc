import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:spine_flutter/spine_flutter.dart' as spine;
import 'package:vibration/vibration.dart';

class Xam extends StatefulWidget {
  const Xam({super.key, required this.onResult});
  final Function() onResult;

  @override
  State<Xam> createState() => _XamState();
}

class _XamState extends State<Xam> {
  bool expanded = false;
  int _shakeCount = 0;
  late spine.SpineWidgetController ctrl;

  final Random _random = Random();
  ShakeDetector? detector;
  Timer? _debounce;
  bool hasResult = false;

  int get _randomNumber => _random.nextInt(1) + 1;

  int get _stackNumber => 2;

  int get _trackIndex => ctrl.animationState.getNumTracks() + _shakeCount;

  final List<String> stateAnim = ['1_Idle', '2_ShakePhone'];

  final List<String> stateResultAnim = [
    '3_Ra1Que',
    '3_Ra2Que',
    '4_Focus1Que',
    '4_Focus2Que',
  ];

  void _listenShake() {
    _shakeCount++;
  }

  void _listenResult() {}

  void _shakeSetup() {
    detector = ShakeDetector.autoStart(
      shakeThresholdGravity: 1.3,
      onPhoneShake: () {
        _shakeCount++;
        Vibration.vibrate(duration: 100);
        ctrl.animationState
            .addAnimationByName(_trackIndex, stateAnim.last, false, 0);
        if (_shakeCount > 5) {
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce = Timer.periodic(const Duration(milliseconds: 1200), (_) {
            if (hasResult) {
              //handle
              _debounce?.cancel();
              return;
            }
            hasResult = true;
            ctrl.animationState
                .addAnimationByName(
              _trackIndex,
              stateResultAnim[_randomNumber],
              false,
              0,
            )
                .setListener((type, entry, event) {
              detector?.stopListening();
              detector = null;
              if (type == spine.EventType.complete) {
                expanded = true;
                setState(() {});
                ctrl.animationState
                    .addAnimationByName(
                  _trackIndex,
                  stateResultAnim[_randomNumber + _stackNumber],
                  false,
                  0,
                )
                    .setListener((typeResult, _, __) {
                  if (typeResult == spine.EventType.complete) {
                    widget.onResult.call();
                  }
                });
              }
            });
            _debounce?.cancel();
          });
        }
      },
    );
  }

  _setUpXam(){
    ctrl = spine.SpineWidgetController(onInitialized: (controller) {
      controller.animationStateData.setDefaultMix(0.1);
      controller.animationState.setAnimationByName(_trackIndex, stateAnim.first, true);
    });
    expanded = false;
    _shakeCount = 0;
    hasResult = false;
  }

  @override
  void initState() {
    _setUpXam();

    _shakeSetup();

    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // _setUpXam();
        // setState(() {
        //
        // });
        // // if (detector != null) return;
        // _shakeSetup();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 1000),
        scale: expanded ? 1.1 : 0.75,
        child: Transform.translate(
          offset: Offset(expanded ? -28 : 10, 0),
          child: spine.SpineWidget.fromAsset(
            "assets/Hu_Xam.atlas",
            "assets/Hu_Xam.json",
            ctrl,
          ),
        ),
      ),
    );
  }
}
