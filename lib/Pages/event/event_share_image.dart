import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/event/event_result.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';

ScreenshotController screenshotController = ScreenshotController();

class EventShareImage extends StatelessWidget {
  final String title, content;
  final String numberOfQue;
  const EventShareImage(
      {Key? key,
      required this.content,
      required this.title,
      required this.numberOfQue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final spacing = SizedBox(height: 15, width: 15);
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/tet/que_bg.png'),
                fit: BoxFit.scaleDown),
          ),
          margin: EdgeInsets.all(5),
          child: Container(
              padding: EdgeInsets.all(35),
              alignment: Alignment.center,
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/tet/bg_result.png'),
                    fit: BoxFit.scaleDown),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      numberOfQue,
                      style: GoogleFonts.getFont('Philosopher').copyWith(
                        fontSize: 20,
                        color: Color(0xFFE87F2B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    spacing,
                    Image.asset('assets/tet/card_cat.png', height: 112, width: 150,),
                    _buildDivider(w/2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Text(
                        '\"$title\"',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont('Philosopher').copyWith(
                          fontSize: 24,
                          color: Color(0xFFDE3532),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _buildDivider(w),
                    // spacing, spacing,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35),
                      child: Text(
                        content,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont('Inter').copyWith(
                          fontSize: 16,
                          color: Color(0xFF843C02),
                        ),
                      ),
                    ),
                    spacing,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/tet/ic_hoa_mai.png', scale: 1.4,),
                        spacing,
                        Image.asset('assets/tet/ic_hoa_mai.png'),
                        spacing,
                        Image.asset('assets/tet/ic_hoa_mai.png', scale: 1.4,),
                      ],
                    )
                  ],
                ),
              )
              ),
        ),
      ),
    );
  }

  _buildDivider(double w) {
    return Container(
      margin: EdgeInsets.all(15),
      height: 1,
      width: w,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xFFEDBE72).withOpacity(0),
        Color(0xFFE1B260),
        Color(0xFFEDBE72).withOpacity(0),
      ])),
    );
  }
}
