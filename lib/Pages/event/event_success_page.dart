import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class EventSuccessPage extends StatefulWidget {
  const EventSuccessPage({Key? key}) : super(key: key);

  @override
  State<EventSuccessPage> createState() => _EventSuccessPageState();
}

class _EventSuccessPageState extends State<EventSuccessPage> {

  final _confettiDuration = const Duration(seconds: 5);

  late ConfettiController _controllerCenter;

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: _confettiDuration);
    _controllerCenter.play();
    super.initState();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double boxSize = MediaQuery.of(context).size.width * 0.75;
    final double imgSize = boxSize * 0.75;
    return Container(
      color: Colors.white,
      height: boxSize,
      width: boxSize,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text('Chúc mừng năm mới'),
                Text('Đây là 1 câu chúc Tết vô cùng cảm lạnh'),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset('assets/tet/bg_tet_2.png', height: imgSize, width: imgSize,),
                ),
                Text('Cảm ơn bạn đã xem!'),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 20,
              // shouldLoop: true,
              emissionFrequency: 0.1,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
              // createParticlePath: drawStar,
            ),
          ),
        ],
      ),
    );
  }
}
