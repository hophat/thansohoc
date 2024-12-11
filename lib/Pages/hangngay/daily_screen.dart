import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/app/locator/app_locator.dart';
import 'package:flutter_app_than_so_hoc_2/main.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/res_model/daily_res.dart';
import 'package:flutter_app_than_so_hoc_2/network/repository/user_repository.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../generated/l10n.dart';

class DailyScreen extends StatefulWidget {
  final DailyRes? daily;

  const DailyScreen({super.key, this.daily});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  DailyRes? daily;

  List<bool> _isOpens = [true, false, false];

  bool _isLoading = false;

  @override
  void initState() {
    daily = widget.daily;

    if (daily == null) {
      _isLoading = true;
      getIt.get<UserRepository>().daily().then((v) {
        _isLoading = false;
        v.fold((l) {
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(SnackBar(content: Text(l.message ?? 'Error')));
        }, (r) {
          daily = r;
        });
        if (!mounted) return;
        setState(() {});
      });
    }

    super.initState();
  }

  Widget get _bg => Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/tet/bg.png'),
        fit: BoxFit.cover,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _bg),
          Positioned.fill(child: _body()),
        ],
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            S.of(context).horo_today,
            style: TextStyle(
                fontSize: 24, color: TSHColors().primaryTextColor),
          ),
          leading: BackButton(
            color: TSHColors().primaryTextColor,
          ),
          centerTitle: true,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Skeletonizer(
              enabled: _isLoading,
              child: Column(
                children: [
                  _date(),
                  ...() {
                    // if (daily == null && !_isLoading)
                    //   return [
                    //     SizedBox(height: 150),
                    //     Padding(
                    //       padding: const EdgeInsets.all(16.0),
                    //       child: Center(
                    //         child: Text(
                    //           'Chưa tìm thấy thông tin tử vi của bạn! Quay lại vào ngày hôm sau nhé!',
                    //           style: TextStyle(fontSize: 16),
                    //           textAlign: TextAlign.center,
                    //         ),
                    //       ),
                    //     )
                    //   ];
                    return [
                      SizedBox(height: 12),
                      _box(
                        title: S.of(context).horo_love,
                        content: daily?.love ?? '',
                        icon: Icon(Icons.favorite, color: Color(0xFFB22720)),
                      ),
                      _box(
                        title: S.of(context).horo_career,
                        content: daily?.career ?? '',
                        icon: Icon(Icons.work, color: Color(0xFFB22720)),
                      ),
                      _box(
                        title: S.of(context).horo_fin,
                        content: daily?.finance ?? '',
                        icon: Icon(Icons.monetization_on, color: Color(0xFFB22720)),
                      ),
                    ];
                  }(),
                  SizedBox(height: 150),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _date() {
    final formatter = DateFormat(langCur == 'vi' ? 'dd/MM/yyyy' : 'MM/dd/yyyy');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
          constraints: BoxConstraints(minHeight: 83, maxHeight: 83),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(colors: TSHColors().gradiantCardColor,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Skeleton.keep(
                    child: Image.asset(
                      'assets/icons/daily_flow_left.png',
                      height: 83,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Skeleton.keep(
                    child: Image.asset('assets/icons/daily_flow_right.png',
                        height: 83),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  // bottom: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${DateFormat('EEEE').format(DateTime.now())}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: TSHColors().titleCardColor,
                        ),
                      ),
                      Text(
                        '${formatter.format(DateTime.now())}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: TSHColors().titleCardColor,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  TextStyle get _titleStyle => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFFB22720),
  );

  TextStyle get _contentStyle => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF9B150E),
  );


  _box({
    String title = 'Tình duyên',
    String content = '',
    Widget? icon,
}) {
    return Padding(
      padding: const EdgeInsets.all(16.0).copyWith(bottom: 4, top: 4),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: TSHColors().gradiantCardColor,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                icon ?? Icon(Icons.favorite, color: Color(0xFFB22720)),
                SizedBox(width: 8),
                Text(title, style: _titleStyle),
              ],
            ),
            Text(content, style: _contentStyle),
          ],
        ),
      ),
    );
  }
}
