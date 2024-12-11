import 'package:blinking_text/blinking_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_than_so_hoc_2/main.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/gender_enum.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/res_model/user_res.dart';
import 'package:flutter_app_than_so_hoc_2/network/repository/user_repository.dart';
import 'package:flutter_app_than_so_hoc_2/provider/admob/admob_provider.dart';
import 'package:flutter_app_than_so_hoc_2/provider/auth/auth_provider.dart';
import 'package:flutter_app_than_so_hoc_2/utils/const.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../app/locator/app_locator.dart';
import '../../class/Lang.dart';
import '../../generated/l10n.dart';
import '../../network/data/req/user_req.dart';
import '../../network/data/res_model/daily_res.dart';
import '../home/profile_icon_widget.dart';
import 'daily_screen.dart';

class ZodiacMenu extends StatefulWidget {
  const ZodiacMenu({super.key});

  @override
  State<ZodiacMenu> createState() => _ZodiacMenuState();
}

class _ZodiacMenuState extends State<ZodiacMenu> {
  bool _isNotice = false;
  bool _isEdit = false;
  late final AuthProvider _authProvider;

  bool get isLogin => context.read<AuthProvider>().isLogin;

  DailyRes? daily;
  Gender _currentGender = Gender.other;

  late final TextEditingController _nameCtrl,
      _emailCtrl,
      _birthDateCtrl,
      _sexCtrl,
      _countryCtrl,
      _noticeCtrl;

  UserReq get req => UserReq(
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        birthDate: parseDate(_birthDateCtrl.text),
        sex: _currentGender,
        country: _countryCtrl.text,
        timeNotice: parseDate(_noticeCtrl.text),
        deviceToken: _fcmToken,
        isNotice: _isNotice,
      );

  String? _fcmToken;

  DateTime? parseDate(String date) {
    final formatter = DateFormat(langCur == 'vi' ? 'dd/MM/yyyy' : 'MM/dd/yyyy');
    return formatter.tryParse(date);
  }

  Future<Gender?> _selectGender() async {
    return await showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: false,
        builder: (ctx) {
          return ListView.separated(
              shrinkWrap: true,
              itemCount: Gender.values.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (_, index) => ListTile(
                    title: Text(Gender.values[index].display),
                    onTap: () {
                      Navigator.pop(ctx, Gender.values[index]);
                    },
                  ));
        });
  }

  Future<Lang?> _selectCountry() async {
    return await showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: false,
        builder: (ctx) {
          return ListView.separated(
              shrinkWrap: true,
              itemCount: listLang.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (_, index) => ListTile(
                    title: Text(listLang[index].country),
                    onTap: () {
                      Navigator.pop(ctx, listLang[index]);
                    },
                  ));
        });
  }

  _initCtrl() {
    final formatter = DateFormat(langCur == 'vi' ? 'dd/MM/yyyy' : 'MM/dd/yyyy');
    final dateStore =
        getIt.get<SharedPreferences>().getString(birthDayKey) ?? '';

    _authProvider = context.read<AuthProvider>();
    _nameCtrl = TextEditingController()..text = _authProvider.user?.name ?? '';
    _emailCtrl = TextEditingController()
      ..text = _authProvider.user?.email ?? '';
    _birthDateCtrl = TextEditingController()
      ..text = _authProvider.user?.birthDate != null
          ? formatter.format(_authProvider.user?.birthDate ?? DateTime.now())
          : formatter.format(DateTime.tryParse(dateStore) ?? DateTime.now());
    _currentGender = Gender.fromString(_authProvider.user?.sex);
    _sexCtrl = TextEditingController()..text = _currentGender.display;
    _countryCtrl = TextEditingController()
      ..text = _authProvider.user?.country ?? 'VietNam';
    _noticeCtrl = TextEditingController()
      ..text = _authProvider.user?.timeNotice != null
          ? _authProvider.user?.timeNotice.toString() ?? ''
          : '';
  }

  @override
  void initState() {
    _isNotice = context.read<AuthProvider>().user?.isNotice ?? false;
    _isEdit = !context.read<AuthProvider>().isLogin;
    // _isEdit = false;
    context.read<AdmobProvider>().load();
    _initCtrl();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDaily();
    });
    super.initState();
  }

  TextStyle get _style => TextStyle(
      color: TSHColors().primaryTextColor, fontWeight: FontWeight.w500);

  _fetchDaily() {
    getIt.get<UserRepository>().daily().then((v) {
      if (!mounted) return;
      v.fold((l) {
        daily = null;
        setState(() {});
      }, (r) {
        daily = r;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (_, auth, child) {
      return Theme(
        data: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: TSHColors().primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: TSHColors().primaryTextColor),
            ),
            labelStyle: TextStyle(color: TSHColors().primaryTextColor),
          ),
        ),
        child: Scaffold(
            body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/tet/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    if (!_isEdit) ...[
                      Padding(
                        padding: EdgeInsets.all(16).copyWith(bottom: 0),
                        child: cardItem(auth.user),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16).copyWith(bottom: 0),
                        child: _summary(),
                      ),

                      Padding(
                        padding: EdgeInsets.all(16),
                        child: _submitTuVi(),
                      )
                    ] else ...[
                      Hero(
                          tag: 'profile',
                          child: SizedBox(
                            height: 175,
                            width: 175,
                            child: FittedBox(
                              child: IgnorePointer(
                                  ignoring: true, child: ProfileIconWidget()),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: formEdit(),
                      )
                    ],
                  ],
                ),
              ),
            )
          ],
        )),
      );
    });
  }

  Widget _submitTuVi(){
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _navigateToDaily,
        child: Container(
          height: 40,
          // width: 160,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFAE9B1),
                  Color(0xFFEDBE72),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
          child: BlinkText(
            S.of(context).horo_submit,
            endColor: Colors.white,
            beginColor: TSHColors().primaryColor,
            duration: Duration(milliseconds: 600),
            times: 2,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: TSHColors().primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _summary() {
    final formatter = DateFormat(langCur == 'vi' ? 'dd/MM/yyyy' : 'MM/dd/yyyy');
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      constraints: BoxConstraints(minHeight: 83,maxHeight: daily?.summary != null ? 150 : 83),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: TSHColors().gradiantCardColor),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/icons/daily_flow_left.png',
                  height: 83,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Image.asset('assets/icons/daily_flow_right.png',
                    height: 83),
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
                    ),
                    SizedBox(height: 16),
                    Text(
                      daily?.summary ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: TSHColors().titleCardColor,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget formEdit() {
    return Column(
      children: [
        TextFormField(
          style: _style,
          controller: _nameCtrl,
          decoration: InputDecoration(
            labelText: S.of(context).horo_user_name,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          style: _style,
          controller: _birthDateCtrl,
          decoration: InputDecoration(
            labelText: S.of(context).horo_birthday,
          ),
          inputFormatters: [
            DateTextFormatter(),
          ],
          readOnly: true,
          onTap: () {
            DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              minTime: DateTime(1900, 1, 1),
              maxTime: DateTime.now(),
              onChanged: (v) {
                final formatter =
                    DateFormat(langCur == 'vi' ? 'dd/MM/yyyy' : 'MM/dd/yyyy');
                _birthDateCtrl.text = formatter.format(v);
              },
              onConfirm: (v) {
                final formatter =
                    DateFormat(langCur == 'vi' ? 'dd/MM/yyyy' : 'MM/dd/yyyy');
                _birthDateCtrl.text = formatter.format(v);
              },
              currentTime: parseDate(_birthDateCtrl.text),
              locale: langCur == 'vi' ? LocaleType.vi : LocaleType.en,
            );
          },
        ),
        SizedBox(height: 8),
        TextFormField(
          style: _style,
          controller: _sexCtrl,
          decoration: InputDecoration(
            labelText: S.of(context).horo_gender,
          ),
          readOnly: true,
          onTap: () {
            _selectGender().then((v) {
              if (v != null) {
                _currentGender = v;
                _sexCtrl.text = _currentGender.display;
              }
            });
          },
        ),
        SizedBox(height: 8),
        TextFormField(
          style: _style,
          controller: _countryCtrl,
          decoration: InputDecoration(
            labelText: S.of(context).horo_country,
          ),
          readOnly: true,
          onTap: () {
            _selectCountry().then((v) {
              if (v != null) {
                _countryCtrl.text = v.country;
              }
            });
          },
        ),
        SizedBox(height: 20),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              _fcmToken = await FirebaseMessaging.instance.getToken();
              if (_fcmToken == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Bạn cần cung cấp quyền truy cập thông báo để sử dụng chức năng này',
                    ),
                  ),
                );
                return;
              }
              if (_authProvider.isLogin) {
                _authProvider.update(req).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Cập nhật thông tin thành công',
                      ),
                    ),
                  );
                  _isEdit = false;
                  setState(() {});
                });
                return;
              }
              _authProvider.register(req).then((_) {
                if (!mounted) return;
                _isEdit = false;
                Future.delayed(const Duration(seconds: 1), () => _fetchDaily());
              });
            },
            child: Container(
              height: 40,
              // width: 160,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFAE9B1),
                      Color(0xFFEDBE72),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
              child: BlinkText(
                isLogin ? S.of(context).horo_edit : S.of(context).horo_submit,
                endColor: Colors.white,
                beginColor: TSHColors().primaryColor,
                duration: Duration(milliseconds: 600),
                times: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: TSHColors().primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _navigateToDaily() {
    if (!mounted) return;
    if(!kDebugMode) context.read<AdmobProvider>().show();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DailyScreen(daily: daily),
      ),
    );
  }

  Widget cardItem(UserRes? user) {
    return TweenAnimationBuilder<double>(
      builder: (_, v, c) {
        return Opacity(
          opacity: v,
          child: c,
        );
      },
      tween: Tween<double>(begin: 0.0, end: 1),
      duration: const Duration(milliseconds: 1000),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFE94944), width: 2),
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE94944),
                  Color(0xFFC72C25),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Hero(
                  tag: 'profile',
                  child: Transform.scale(
                    scale: 4,
                    child: Transform.translate(
                      offset: Offset(-10.5, 8),
                      child: Image.asset(
                        'assets/icons/zodiac.png',
                        height: 50,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user?.name ?? '',
                        style:
                        TextStyle(fontSize: 18, color: TSHColors().primaryTextColor, fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Material(
                          elevation: 0,
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  _isEdit = true;
                                });
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: Icon(
                                Icons.edit_note,
                                color: TSHColors().primaryTextColor,
                              )))
                    ],
                  ),
                  Text(
                    DateFormat(langCur == 'vi' ? 'dd/MM/yyyy' : 'MM/dd/yyyy').format(user?.birthDate ?? DateTime.now()),
                    style: TextStyle(fontSize: 18, color: TSHColors().primaryTextColor),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    //this fixes backspace bug
    if (oldValue.text.length >= newValue.text.length) {
      return newValue;
    }

    var dateText = _addSeperators(newValue.text, '/');
    return newValue.copyWith(
        text: dateText, selection: updateCursorPosition(dateText));
  }

  String _addSeperators(String value, String seperator) {
    value = value.replaceAll('/', '');
    var newString = '';
    for (int i = 0; i < value.length; i++) {
      newString += value[i];
      if (i == 1) {
        newString += seperator;
      }
      if (i == 3) {
        newString += seperator;
      }
    }
    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}
