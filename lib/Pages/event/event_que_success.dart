import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';

class EventQueSuccess extends StatefulWidget {
  final Function one, two;
  const EventQueSuccess({Key? key, required this.one, required this.two})
      : super(key: key);

  @override
  State<EventQueSuccess> createState() => _EventQueSuccessState();
}

class _EventQueSuccessState extends State<EventQueSuccess>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotateController;

  final Duration _duration = const Duration(milliseconds: 1000);

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    );

    _rotateController = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.1,
          1.0,
          curve: Curves.easeInOutBack,
        ),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        tween: Tween<double>(begin: 0.3, end: 1),
        builder: (_, v, c) {
          return Transform.scale(
            scale: v,
            child: c,
          );
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () async {
                          await _controller.forward();
                          // await _controller.reverse();
                          widget.one();
                        },
                        child: AnimatedBuilder(
                          animation: _controller,
                          child: Image.asset('assets/tet/que_1.png'),
                          builder: (_, c) {
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(pi  * _rotateController.value),
                              child: c,
                            );
                          },
                        )),
                    GestureDetector(
                        onTap: () async {
                          await _controller.forward();
                          await _controller.reverse();
                          // widget.two();
                        },
                        child: Image.asset('assets/tet/que_2.png'))
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Chạm để xem quẻ',
                style: TextStyle(
                    color: TSHColors().primaryTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
