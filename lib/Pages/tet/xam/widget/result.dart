import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gieoque/features/splash/screen/splash.dart';
import 'package:google_fonts/google_fonts.dart';

class Result extends StatefulWidget {
  final Function() onRetry;

  const Result({super.key, required this.onRetry});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final Color txtColor = const Color(0xFF4E1C00);
  bool _isShowBtn = false;
  int _resultIndex = 0;

  @override
  void initState() {
    super.initState();
    final rd = Random();
    _resultIndex = rd.nextInt(resultData.length);
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      setState(() {
        if(!mounted) return;
        _isShowBtn = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      // key: UniqueKey(),
      duration: const Duration(milliseconds: 1000),
      tween: Tween<double>(begin: 0.5, end: 1.0),
      curve: Curves.fastEaseInToSlowEaseOut,
      builder: (_, v, c) {
        return Transform.scale(
          // offset: Offset(0, -(400.0 * v).h),
          scaleY: v,
          alignment: Alignment.topCenter,
          child: c,
        );
      },
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            height: 341.h,
            left: 20.w,
            right: 20.w,
            top: 0,
            child: Image.asset('assets/chuc_mung.png'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 100.w),
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      (_resultIndex+1).toString(),
                      style: GoogleFonts.livvic().copyWith(
                          fontSize: 50,
                          color: txtColor,
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      resultData[_resultIndex],
                      style: Theme.of(context)
                          // style: GoogleFonts.caveatTextTheme()
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: txtColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isShowBtn ? 1 : 0,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFD2290A),
                      side: const BorderSide(
                        color: Color(0xFFFFFF85),
                        width: 4.0,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
                      return const SplashScreen();
                    }),);
                    // widget.onRetry.call();
                  },
                  child: Text(
                    'Quẻ mới',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFFFF85),
                        ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

const List<String> resultData = [
  "Niên niên như ý xuân - Tuế tuế bình an nhật",
  "Hoa khai phú quý - Trúc báo bình an",
  "Xuân an khang thịnh vượng - Niên phúc thọ miên trường",
  "Ngàn lần như ý - Vạn sự như mơ. Triệu sự bất ngờ - Tỷ lần hạnh phúc",
  "Xuân sang cội phúc sinh nhành lộc - Tết về cây đức trổ thêm hoa",
  "Tân niên nạp dư khánh - Gia tiết hiệu trường xuân",
  "Cạn ly mừng năm qua đắc lộc - Nâng cốc chúc năm mới phát tài",
  "Lộc biếc, mai vàng, xuân hạnh phúc - Đời vui, sức khỏe, tết an khang",
  "Tết đến gia đình vui sum họp - Xuân về con cháu hưởng bình an",
  "Cát tường như ý - Cung chúc Tân xuân",
  "Phúc lai miên thế trạch - Lộc mãn trấn gia thanh",
  "Trúc bảo bình an, tài lợi tiến - Mai khai phú quý, lộc quyền lai",
  "Đong cho đầy hạnh phúc - Gói cho trọn lộc tài. Giữ cho mãi an khang - Thắt cho chặt phú quý",
  "Cung chúc tân niên - Sức khỏe vô biên",
  "Thành công liên miên - Hạnh phúc triền miên",
  "Túi luôn đầy tiền - Sung sướng như tiên",
  "Thiên tăng tuế nguyệt, niên tăng thọ. Xuân mãn càn khôn, phúc mãn đường",
  "Xuân sang cội phúc sinh nhành lộc. Tết về cây đức trổ thêm hoa",
  "Ðịa sinh tài, thế nghiệp quang huy. Thiên tứ phúc, gia thanh hiện thái",
  "Chúc Tết đến trăm điều như ý. Mừng xuân sang vạn sự thành công",
  "Tân niên hạnh phúc bình an tiến. Xuân nhật vinh hoa phú quý lai",
  "Tiễn Chuột đi chúc xuân vui hạnh phúc. Đón Trâu về mừng Tết đạt thành công",
  "Túi luôn đầy tiền. Sung sướng như tiên",
  "Mừng xuân hỉ xả thêm công đức. Đón tết từ bi bớt não phiền",
  "Cung chúc tân niên. Sức khỏe vô biên",
  "Phúc đem lễ nghĩa trong nhà thịnh. Lộc nảy vinh hoa phú quý xuân",
  "Chúc gia đình có được một mùa xuân được như ý và tuổi mới luôn được bình an",
  "Chúc một năm mới được giàu sang phú quý và gia đình được an bình, hạnh phúc",
  "Chúc một năm mới luôn được an khang và thịnh vượng, sức khoẻ được dồi dào",
  "Chúc cho gia đình sự nghiệp được như ý muốn, luôn nhận được nhiều điều tốt đẹp bất ngờ và hạnh phúc",
  "Mùa xuân mới chúc gia định sẽ nhận được nhiều tài lộc và hạnh phúc bình an",
  "Mùa xuân mới luôn nhận được mọi điều an lành và gia đình luôn được vui vẻ và hạnh phúc",
  "Chào tạm biệt và ăn mừng một năm vừa qua đã nhận được nhiều may mắn< và hy vọng một năm mới sẽ được phát tài< nhiều hơn thế nữa",
  "Chúc một mùa xuân luôn có niềm vui trên môi, gia đình sum vầy hạnh và được sức khoẻ dồi dào",
  "Mùa xuân mới mong gia đình luôn được sum vầy, các thành viên trong gia đình đều được bình an và hạnh phúc",
  "Chúc năm mới cuộc sống được vạn sự như ý",
  "Năm mới niềm hạnh phúc sẽ dâng tràn mọi nẻo và tài lộc sẽ thơm ngát cửa nhà",
  "Gia đình luôn được bình yên, năm mới được nhiều tài lộc, được giàu sang, phú quý",
  "Mùa xuân mới gia đình luôn đong đầy hạnh phúc, tài lộc sẽ đến cửa nhà để có được năm mới luôn an khang",
  "Chúc năm mới được dồi dào sức khỏe",
  "Một năm mới luôn được thành công, có được hạnh phúc và có được cuộc sống sung sướng, giàu sang",
  "Chúc cho người thân của mình trong dịp xuân về sẽ tăng thêm tuổi thọ và phúc lộc đến đầy nhà",
  "Chúc cho người bên cạnh một năm mới sẽ nhận được nhiều may mắn, phát tài và phác lộc, gia đình được hạnh phúc và sum vầy",
  "Chúc cho người bên cạnh sự nghiệp được phát triển để cuộc đời thêm sáng lạn hơn, phúc lộc nhiều để gia đình luôn tràn ngập tiếng cười",
  "Vào năm mới, chúc cho người bên cạnh làm việc gì cũng đều được như ý và thành công viên mãn",
  "Chúc cho người bên cạnh một năm mới có nhiều vinh hoa phú quý và có nhiều niềm vui và hạnh phúc bên những người thân của mình",
  "Câu đối này nhằm tạm biệt một năm cũ qua đi với nhiều niềm vui, hạnh phúc và đồng thời đón chào một năm mới đến có nhiều thành công và hạnh phúc hơn nữa",
  "Chúc cho người bên cạnh năm mới sẽ gặt hái được nhiều tài lộc để cuộc sống được sung sướng và giàu sang",
  "Câu đối chúc cho người bên cạnh năm mới sẽ không còn buồn phiền hay lo toan mà thay vào đó sẽ là sự an lành và có được phúc lộc",
  "Chúc mừng năm mới, chúc cho người bên cạnh luôn được khỏe mạnh, hạnh phúc bên người thân của mình",
  "Năm mới gia đình có phúc lộc về nhà, sẽ được thành công và nhận được nhiều vinh hoa cuộc sống giàu sang, phú quý",
];
