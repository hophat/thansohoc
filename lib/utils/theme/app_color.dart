import 'dart:ui';

class TSHColors {

  static final _instance = TSHColors._();

  TSHColors._();

  factory TSHColors() => _instance;

  Color get primaryTextColor => Color(0xFFFAE9B1);

  Color get primaryColor => Color(0xFFE94944);

  List<Color> get gradiantBtnColor => [
    Color(0xFFEDBE72),
    Color(0xFFFAE9B1),
    Color(0xFFEDBE72),
  ];

  List<Color> get gradiantSheetColor => [
    Color(0xFFB22720),
    Color(0xFF9B150E),
  ];

}