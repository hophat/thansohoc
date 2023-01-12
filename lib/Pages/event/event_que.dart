import 'dart:math';

import 'package:flutter/material.dart';

class EventQue extends StatefulWidget {
  const EventQue({Key? key}) : super(key: key);

  @override
  State<EventQue> createState() => _EventQueState();
}

class _EventQueState extends State<EventQue> with TickerProviderStateMixin {

  late final AnimationController _controller;
  late final Animation<double> _rotateController;
  final Duration _duration = const Duration(milliseconds: 1000);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    );

    _rotateController = Tween(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.linear,
        ),
      ),
    );

    _controller.forward();
    _controller.repeat(reverse: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (_, c) {
          return Center(
            child: Transform.rotate(angle: pi * _rotateController.value,
            alignment: Alignment.center,
            child: Image.asset('assets/tet/ques.png'),
            ),
          );
        },
      ),
    );
  }
}
