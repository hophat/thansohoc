import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_than_so_hoc_2/main.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/gender_enum.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/res_model/user_res.dart';
import 'package:flutter_app_than_so_hoc_2/provider/auth/auth_provider.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../network/data/req/user_req.dart';
import '../home/profile_icon_widget.dart';

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

  late final TextEditingController _nameCtrl,
      _emailCtrl,
      _birthDateCtrl,
      _sexCtrl,
      _countryCtrl,
      _noticeCtrl;

  UserReq get req => UserReq(
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        birthDate: DateTime.tryParse(_birthDateCtrl.text),
        sex: Gender.fromString(_sexCtrl.text),
        country: _countryCtrl.text,
        timeNotice: DateTime.tryParse(_noticeCtrl.text),
        isNotice: _isNotice,
      );

  _initCtrl() {
    final formatter = DateFormat(langCur == 'vi' ? 'dd/MM/yyyy' : 'MM/dd/yyyy');
    _authProvider = context.read<AuthProvider>();
    _nameCtrl = TextEditingController()..text = _authProvider.user?.name ?? '';
    _emailCtrl = TextEditingController()
      ..text = _authProvider.user?.email ?? '';
    _birthDateCtrl = TextEditingController()
      ..text = _authProvider.user?.birthDate != null
          ? _authProvider.user?.birthDate.toString() ?? ''
          : formatter.format(DateTime.now());
    _sexCtrl = TextEditingController()
      ..text = Gender.fromString(_authProvider.user?.sex).display;
    _countryCtrl = TextEditingController()
      ..text = _authProvider.user?.country ?? '';
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
    _initCtrl();
    super.initState();
  }

  TextStyle get _style => TextStyle(
        color: TSHColors().primaryTextColor,
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (_, auth, child) {
      return Theme(
        data: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: TSHColors().borderCardColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: TSHColors().borderCardColor),
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
                        'Tử vi hôm nay',
                        style: TextStyle(
                            fontSize: 24, color: TSHColors().primaryTextColor),
                      ),
                      leading: BackButton(
                        color: TSHColors().primaryTextColor,
                      ),
                      centerTitle: true,
                    ),
                    Hero(
                        tag: 'profile',
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: FittedBox(
                            child: IgnorePointer(
                                ignoring: true, child: ProfileIconWidget()),
                          ),
                        )),
                    if (!_isEdit)
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: cardItem(auth.user),
                      )
                    else ...[
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextFormField(
                              style: _style,
                              controller: _nameCtrl,
                              decoration: InputDecoration(
                                labelText: 'Họ và tên',
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              style: _style,
                              controller: _emailCtrl,
                              decoration: InputDecoration(
                                labelText: 'E-mail',
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              style: _style,
                              controller: _birthDateCtrl,
                              decoration: InputDecoration(
                                labelText: 'Sinh nhật',
                              ),
                              inputFormatters: [
                                DateTextFormatter(),
                              ],
                              readOnly: true,
                              onTap: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: _authProvider.user?.birthDate ?? DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                ).then((value) {
                                  if(value != null){
                                    final formatter = DateFormat(langCur == 'vi' ? 'dd/MM/yyyy' : 'MM/dd/yyyy');
                                    _birthDateCtrl.text = formatter.format(value);
                                  }
                                });
                              },
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              style: _style,
                              controller: _sexCtrl,
                              decoration: InputDecoration(
                                labelText: 'Giới tính',
                              ),
                              readOnly: true,
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              style: _style,
                              controller: _countryCtrl,
                              decoration: InputDecoration(
                                labelText: 'Quốc gia',
                              ),
                              readOnly: true,
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              style: _style,
                              controller: _noticeCtrl,
                              decoration: InputDecoration(
                                labelText: 'Thời gian nhận thông báo tử vi',
                              ),
                              inputFormatters: [
                                DateTextFormatter(),
                              ],
                              readOnly: true,
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Nhận thông báo mỗi ngày: ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: TSHColors().primaryTextColor),
                                ),
                                Checkbox(
                                  value: _isNotice,
                                  onChanged: (v) =>
                                      setState(() => _isNotice = v ?? false),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  print('Update user $req');
                                },
                                child: Container(
                                  height: 40,
                                  width: 160,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: TSHColors().titleCardColor2),
                                  child: BlinkText(
                                    'Xem tử vi',
                                    endColor: Colors.white,
                                    beginColor: TSHColors().primaryTextColor,
                                    duration: Duration(milliseconds: 600),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: TSHColors().primaryTextColor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            border: Border.all(color: TSHColors().borderCardColor, width: 2),
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: TSHColors().gradiantCardColor,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thông tin cá nhân',
                style: TextStyle(
                    fontSize: 24,
                    color: TSHColors().titleCardColor,
                    fontWeight: FontWeight.w400)),
            Text(
              'Name: ${user?.name}',
              style:
                  TextStyle(fontSize: 18, color: TSHColors().titleCardColor3),
            ),
            Text(
              'Ngày sinh: ${user?.birthDate}',
              style: TextStyle(fontSize: 18, color: TSHColors().titleCardColor),
            ),
            Text(
              'Giới tính: ${Gender.fromString(user?.sex).display}',
              style: TextStyle(fontSize: 18, color: TSHColors().titleCardColor),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    width: 160,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: TSHColors().titleCardColor2),
                    child: BlinkText(
                      'Xem Tử vi',
                      endColor: Colors.white,
                      beginColor: TSHColors().primaryTextColor,
                      duration: Duration(milliseconds: 600),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: TSHColors().primaryTextColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    //this fixes backspace bug
    if (oldValue.text.length >= newValue.text.length) {
      return newValue;
    }

    var dateText = _addSeperators(newValue.text, '/');
    return newValue.copyWith(text: dateText, selection: updateCursorPosition(dateText));
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