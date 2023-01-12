import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';

class EventQue extends StatefulWidget {
  const EventQue({Key? key}) : super(key: key);

  @override
  State<EventQue> createState() => _EventQueState();
}

class _EventQueState extends State<EventQue> with TickerProviderStateMixin {
  bool _introduced = false;

  late final AnimationController _controller, _controller1, _controller2;
  late final Animation<double> _rotateController;
  late final Animation<double> _rotateController1;
  late final Animation<double> _rotateController2;
  final Duration _duration = const Duration(milliseconds: 600);
  final Duration _duration1 = const Duration(milliseconds: 600 + 45);
  final Duration _duration2 = const Duration(milliseconds: 600 + 45 + 25);

  Size get _size => MediaQuery.of(context).size;

  final double tweenValue = 0.09;

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
          0.8,
          curve: Curves.easeInOutBack,
        ),
      ),
    );

    _rotateController2 = Tween(begin: -tweenValue, end: tweenValue).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: const Interval(
          0.2,
          0.8,
          curve: Curves.easeInOutBack,
        ),
      ),
    );

    _controller.forward();
    _controller.repeat(reverse: true);

    _controller1.forward();
    _controller1.repeat(reverse: true);

    _controller2.forward();
    _controller2.repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 2)).then((value) {
          showAnimatedDialog(
              context: context,
              animationType: DialogTransitionType.sizeFade,
              builder: (_) {
                return Container(
                  height: _size.height,
                  width: _size.width,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, c) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Transform.rotate(
                            angle: pi * _rotateController1.value,
                            alignment: Alignment(0.0, 0.3),
                            child: Opacity(
                                opacity: 0.3,
                                child: Image.asset('assets/tet/ques.png')),
                          ),
                          Transform.rotate(
                            angle: pi * _rotateController2.value,
                            alignment: Alignment(0.0, 0.3),
                            child: Opacity(
                                opacity: 0.3,
                                child: Image.asset('assets/tet/ques.png')),
                          ),
                          Transform.rotate(
                            angle: pi * _rotateController.value,
                            alignment: Alignment(0.0, 0.3),
                            child: Image.asset('assets/tet/ques.png'),
                          ),
                        ],
                      );
                    },
                  ),
                );
              });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
      ),
      body: Container(
        alignment: Alignment.center,
        height: _size.height,
        width: _size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/tet/que_bg.png'), fit: BoxFit.cover),
        ),
        child: _buildIntro(),
      ),
    );
  }


  _buildDate() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: 'meo',
          child: Image.asset('assets/tet/meo.png', scale: 2),
        ),
        SizedBox(
          height: 50,
        ),
        Hero(
          tag: 'hello',
          child: Text(
            'Xin chào',
            style: TextStyle(
                fontSize: 48,
                color: TSHColors().eventTextColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  _buildIntro() {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'hello',
            child: Text(
              'Xin chào',
              style: TextStyle(
                  fontSize: 48,
                  color: TSHColors().eventTextColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Hero(tag: 'meo', child: Image.asset('assets/tet/meo.png'))
        ],
      ),
    );
  }
}