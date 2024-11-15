import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/provider/auth/auth_provider.dart';
import 'package:provider/provider.dart';

class ZodiacMenu extends StatefulWidget {
  const ZodiacMenu({super.key});

  @override
  State<ZodiacMenu> createState() => _ZodiacMenuState();
}

class _ZodiacMenuState extends State<ZodiacMenu> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (_, auth, child){
      return Scaffold(
        appBar: AppBar(
          title: Text('Zodiac Menu ${auth.isLogin}'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

            ],
          ),
        ),
      );
    });
  }
}
