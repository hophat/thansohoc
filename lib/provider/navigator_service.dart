import 'package:flutter/cupertino.dart';

class NavigatorService {
  static NavigatorService? _instance;
  NavigatorService._();
  static NavigatorService get I {
    return _instance ??= NavigatorService._();
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get context => navigatorKey.currentContext!;
}