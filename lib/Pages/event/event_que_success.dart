import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';

class EventQueSuccess extends StatefulWidget {
  final Function one, two;
  const EventQueSuccess({Key? key, required this.one, required this.two}) : super(key: key);

  @override
  State<EventQueSuccess> createState() => _EventQueSuccessState();
}

class _EventQueSuccessState extends State<EventQueSuccess> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        tween: Tween<double>(begin: 0.3, end: 1),
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
                        onTap: () {
                          widget.one();
                        },
                        child: Image.asset('assets/tet/que_1.png')),
                    GestureDetector(
                        onTap: () {
                          widget.two();
                        },
                        child: Image.asset('assets/tet/que_2.png'))
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text('Chạm để xem quẻ', style: TextStyle(color: TSHColors().primaryTextColor, fontSize: 20, fontWeight: FontWeight.bold),),
              const SizedBox(height: 15),
              const SizedBox(height: 15),
            ],
          ),
        ),
        builder: (_,v,c) {
          return Transform.scale(
            scale: v,
            child: c,
          );
        }
      ),
    );
  }
}
