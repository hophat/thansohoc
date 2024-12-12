import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/provider/navigator_service.dart';
// import 'package:provider/provider.dart';
// import '../../provider/auth/auth_provider.dart';
// import '../../utils/theme/app_color.dart';
import '../hangngay/zodiac_menu.dart';

class ProfileIconWidget extends StatefulWidget {
  const ProfileIconWidget({super.key});

  @override
  State<ProfileIconWidget> createState() => _ProfileIconWidgetState();
}

class _ProfileIconWidgetState extends State<ProfileIconWidget>
    with SingleTickerProviderStateMixin {
  // late final AnimationController _ctrl;
  //
  // late final Animation<double> _opacity;

  final int _millis = 800;
  final double _boxSize = 75;
  @override
  void initState() {
    // _ctrl = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: _millis),
    // )..repeat(reverse: true);
    //
    // _opacity = Tween<double>(begin: 0.5, end: 1).animate(_ctrl);

    super.initState();
  }

  @override
  void dispose() {
    // _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _boxSize,
      width: _boxSize,

      // decoration: BoxDecoration(
      //   shape: BoxShape.circle,
      //   // gradient: LinearGradient(
      //   //   colors: TSHColors().gradiantBtnColor,
      //   // ),
      // ),
      child: InkWell(
        onTap: () {
          Navigator.push(NavigatorService.I.context, MaterialPageRoute(builder: (context) => ZodiacMenu()));
        },
        child: HoroIconWidget(
          size: _boxSize,
        ),
        // icon: Stack(
        //   fit: StackFit.expand,
        //   children: [
        //     Image.asset(
        //       'assets/icons/zodiac.png',
        //       fit: BoxFit.cover,
        //       // color: Color(0xFF9B150E),
        //     ),
        //     // Transform.translate(
        //     //   offset: Offset(_boxSize*.28, -_boxSize*.3),
        //     //   child: AnimatedBuilder(
        //     //     animation: _opacity,
        //     //     builder: (_, child) {
        //     //       return Opacity(
        //     //         opacity: _opacity.value,
        //     //         child: child,
        //     //       );
        //     //     },
        //     //     child: Image.asset(
        //     //       'assets/icons/len_flare.png',
        //     //       color: Colors.white,
        //     //     ),
        //     //   ),
        //     // ),
        //     //
        //     // Transform.translate(
        //     //   offset: Offset(-15, _boxSize*.1),
        //     //   child: AnimatedBuilder(
        //     //     animation: _opacity,
        //     //     builder: (_, child) {
        //     //       return Opacity(
        //     //         opacity: _opacity.value,
        //     //         child: child,
        //     //       );
        //     //     },
        //     //     child: Image.asset(
        //     //       'assets/icons/len_flare.png',
        //     //       color: Colors.white,
        //     //     ),
        //     //   ),
        //     // ),
        //     //
        //     // Transform.translate(
        //     //   offset: Offset(0, _boxSize*.42),
        //     //   child: AnimatedBuilder(
        //     //     animation: _opacity,
        //     //     builder: (_, child) {
        //     //       return Opacity(
        //     //         opacity: _opacity.value,
        //     //         child: child,
        //     //       );
        //     //     },
        //     //     child: Image.asset(
        //     //       'assets/icons/len_flare.png',
        //     //       color: Colors.white,
        //     //     ),
        //     //   ),
        //     // )
        //   ],
        // ),
      ),
    );
  }
}

class HoroIconWidget extends StatefulWidget {
  final double? size;
  const HoroIconWidget({super.key, this.size});

  @override
  State<HoroIconWidget> createState() => _HoroIconWidgetState();
}

class _HoroIconWidgetState extends State<HoroIconWidget> with SingleTickerProviderStateMixin{

  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }


  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        return Transform.rotate(
          angle: _ctrl.value * 2 * 3.141592653589793,
          child: child,
        );
      },
      child: Image.asset(
        'assets/icons/zodiac.png',
        fit: BoxFit.cover,
        height: widget.size,
        width: widget.size,
      ),
    );
  }
}
