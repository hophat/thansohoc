import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../generated/l10n.dart';

class EventQueSuccess extends StatefulWidget {
  final Function one, two;
  const EventQueSuccess({Key? key, required this.one, required this.two})
      : super(key: key);

  @override
  State<EventQueSuccess> createState() => _EventQueSuccessState();
}

class _EventQueSuccessState extends State<EventQueSuccess>
    with TickerProviderStateMixin {
  late final AnimationController _controller1, _controller2;
  late final Animation<double> _rotateController1, _rotateController2;
  late final Animation<double> _translateController1, _translateController2;
  late final Animation<double> _opacityController1, _opacityController2;

  final Duration _duration = const Duration(milliseconds: 1300);

  Size get _size => MediaQuery.of(context).size;

  final one = Random().nextInt(26) + 1;
  final two = Random().nextInt(26) + 1;

  @override
  void initState() {
    _controller1 = AnimationController(
      vsync: this,
      duration: _duration,
    );

    _controller2 = AnimationController(
      vsync: this,
      duration: _duration,
    );

    _translateController1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller1,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.linear,
        ),
      ),
    );

    _rotateController1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller1,
        curve: const Interval(
          0.5,
          1.0,
          curve: Curves.easeInOutBack,
        ),
      ),
    );

    _opacityController1 = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller1,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.linear,
        ),
      ),
    );

    _translateController2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.linear,
        ),
      ),
    );

    _rotateController2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: const Interval(
          0.5,
          1.0,
          curve: Curves.easeInOutBack,
        ),
      ),
    );

    _opacityController2 = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.linear,
        ),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller1.dispose();
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await _controller1.forward();
                          widget.one(one);
                        },
                        child: AnimatedBuilder(
                          animation: _controller2,
                          child: AnimatedBuilder(
                            animation: _controller1,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset('assets/tet/que_1.png'),
                                Align(
                                  alignment: Alignment(0.0, -0.3),
                                  child: Text(one.toString(), style: GoogleFonts.getFont('Permanent Marker').copyWith(
                                    color: Color(0xFFDE3532), fontSize: 25, fontWeight: FontWeight.bold
                                  ),),
                                ),
                              ],
                            ),
                            builder: (_, c) {
                              return Transform.translate(
                                offset: Offset(
                                    (_size.width/4.5) * _translateController1.value, 0),
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateY(pi * _rotateController1.value),
                                  child: c,
                                ),
                              );
                            },
                          ),
                          builder: (_, c) {
                            return Opacity(
                              opacity: _opacityController2.value,
                              child: c,
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                          onTap: () async {
                            await _controller2.forward();
                            widget.two(two);
                          },
                          child: AnimatedBuilder(
                              animation: _controller1,
                            child: AnimatedBuilder(
                                animation: _controller2,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset('assets/tet/que_2.png'),
                                    Align(
                                      alignment: Alignment(0.0, -0.3),
                                      child: Text(two.toString(), style: GoogleFonts.getFont('Permanent Marker').copyWith(
                                          color: Color(0xFFDE3532), fontSize: 25, fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                  ],
                                ),
                                builder: (_, c) {
                                  return Transform.translate(
                                    offset: Offset(
                                        -(_size.width/4.5) * _translateController2.value, 0),
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..rotateY(pi * _rotateController2.value),
                                      child: c,
                                    ),
                                  );
                                }
                            ),
                            builder: (_, c) {
                              return Opacity(
                                opacity: _opacityController1.value,
                                child: c,
                              );
                            }
                          )),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                S.of(context).touch_hexagram_to_open,
                textAlign: TextAlign.center,
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
