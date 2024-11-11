import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/tet/splash/screen/splash.dart';

import '../../../../utils/theme/app_color.dart';

class TetBtnWidget extends StatefulWidget {
  const TetBtnWidget({super.key});

  @override
  State<TetBtnWidget> createState() => _TetBtnWidgetState();
}

class _TetBtnWidgetState extends State<TetBtnWidget>
    with TickerProviderStateMixin {
  late final AnimationController _ctrl, _ctrl2;
  late final Animation<double> _scaleAnim, _shakeAnim;

  @override
  void initState() {
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward()..repeat(reverse: true);
    _ctrl2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward()..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.2)
        .animate(CurvedAnimation(parent: _ctrl2, curve: Curves.bounceIn));

    _shakeAnim = Tween<double>(begin: -0.05, end: 0.05)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return XamSplashScreen();
        }));
      },
      child: Container(
        height: 70 ,
        width: 70,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: TSHColors().gradiantBtnColor),
        ),
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, c) {
            return Transform.rotate(
              // alignment: Alignment(0, 0.6),
              angle: _shakeAnim.value * 3.14159,
                // offset: Offset(_shakeAnim.value, 0),
                child: Transform.scale(scale: _scaleAnim.value, child: c));
          },
          child: Image.asset(
            'assets/hu_xam_single.png',
            height: 50,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
