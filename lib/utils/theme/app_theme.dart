import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';

class TSHTheme{

  static final _instance = TSHTheme._();

  TSHTheme._();

  factory TSHTheme() => _instance;


  BoxDecoration get cardDecoration => BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: TSHColors().bodyCardColor,),
      boxShadow: [
        BoxShadow(
            color: Color.fromARGB(0, 0, 0, 25),
            offset: Offset(1,3),
            blurRadius: 12
        ),
      ],
      gradient: LinearGradient(
        colors: TSHColors().gradiantCardColor,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )
  );

  BoxDecoration get cardEventDecoration => BoxDecoration(
      color: TSHColors().eventCardColor,
      border: Border.all(
        color: TSHColors().eventBorderCardColor,
        width: 4.0,
      ),
      borderRadius: BorderRadius.circular(5.0));
}