import 'package:flutter/material.dart';

class EventQue extends StatefulWidget {
  const EventQue({Key? key}) : super(key: key);

  @override
  State<EventQue> createState() => _EventQueState();
}

class _EventQueState extends State<EventQue> with TickerProviderStateMixin {

  late final AnimationController _controller;
  final Duration _duration = const Duration(milliseconds: 3000);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
