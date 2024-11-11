import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spine_flutter/spine_flutter.dart' as spine;

class TetBackground extends StatefulWidget {
  const TetBackground({super.key});

  @override
  State<TetBackground> createState() => _TetBackgroundState();
}

class _TetBackgroundState extends State<TetBackground> {

  late final spine.SpineWidgetController ctrl;

  @override
  void initState() {
    spine.reportLeaks();
    ctrl = spine.SpineWidgetController(onInitialized: (controller) {
      controller.animationState.setAnimationByName(0, "animation", true);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const double standardHeight = 844.0;
    final double addHeight =
    (size.height > standardHeight) ? size.height - standardHeight : 0;
    final bool isBigSize = size.height > 667;
    final height = isBigSize ? 1922 + addHeight : 1555;
    final bool invalidRate = size.height / size.width < 1.5;
    return Container(
      color: const Color(0xFF890004),
      child: Transform.scale(
        // scale: (1139 / size.width) / (1922 / size.height) ,
        scale: ((invalidRate ? 0.3 : 1) -
            max(size.height, height) / min(size.height, height))
            .abs(),
        // scale: 1,
        child: spine.SpineWidget.fromAsset(
          "assets/bg_gieoque_1.atlas",
          "assets/bg_gieoque_1.json",
          ctrl,
          alignment: Alignment.center,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
