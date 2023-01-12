import 'dart:ui';

class TSHColors {

  static final _instance = TSHColors._();

  TSHColors._();

  factory TSHColors() => _instance;

  Color get primaryTextColor => Color(0xFFFAE9B1);

  Color get primaryColor => Color(0xFFE94944);

  Color get titleCardColor => Color(0xFF9B150E);

  Color get titleCardColor2 => Color(0xFFC72C25);

  Color get titleCardColor3 => Color(0xFF843C02);

  Color get bodyCardColor => Color(0xFF843C02);

  Color get borderCardColor => Color(0xFFFAE9B1);

  Color get borderCircleColor => Color(0xFFE94944);

  Color get lineCircleColor => Color(0xFFDE3532);

  Color get eventTextColor => Color(0xFFFFF385);

  List<Color> get gradiantBtnColor => [
    Color(0xFFEDBE72),
    Color(0xFFFAE9B1),
    Color(0xFFEDBE72),
  ];

  List<Color> get gradiantSheetColor => [
    Color(0xFFB22720),
    Color(0xFF9B150E),
  ];

  List<Color> get gradiantCardColor => [
    Color(0xFFFAE9B1),
    Color(0xFFEDBE72)
  ];

  List<Color> get gradiantCircleColor => [
    Color(0xFFE94944),
    Color(0xFFC72C25)
  ];

  List<Color> get gradiantTextColor => [
    Color(0xFFFAE9B1),
    Color(0xFFEDBE72),
    Color(0xFFFAE9B1),
    // Color(0xFFEDBE72),
  ];

}