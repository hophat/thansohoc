import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/class/Lang.dart';
import 'package:flutter_app_than_so_hoc_2/generated/l10n.dart';
import 'package:flutter_app_than_so_hoc_2/provider/local_db/shared_pref.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

// ignore: camel_case_types
class settingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MySettingPage();
  }
}

class _MySettingPage extends State<settingPage> {
  @override
  void initState() {
    super.initState();
    this.detectLang();
  }

  detectLang() {
    if (langCur.isNotEmpty) return;
    listLang.forEach((ele) {
      if (Intl.getCurrentLocale() == ele.key) {
        langCur = ele.key;
      }
    });
  }

  @override
// const settingPage({Key ? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        gradient: LinearGradient(
          colors: TSHColors().gradiantSheetColor,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
      ),
      child: Center(
        child: ListView(
          // mainAxisSize: MainAxisSize.min,
          // padding: EdgeInsets.all(20.0),
          children: <Widget>[
            ListTile(
              title: Text(
                S.current.chon_ngon_ngu,
                style: TextStyle(fontSize: 26, color: Colors.white),
              ),
              trailing: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Colors.white,),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            for (var item in listLang)
              ListTile(
                title: Text(
                  item.lable,
                  style: TextStyle(
                      fontSize: 22,
                      color: langCur == item.key
                          ? TSHColors().primaryTextColor
                          : Colors.white),
                ),
                leading: IconButton(
                  onPressed: () {
                    langCur = item.key;
                    S.load(Locale(item.key));
                    myShared.setString('langCur', item.key);
                    langSteamController.sink.add(item.key);
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    langCur == item.key
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: langCur == item.key
                        ? TSHColors().primaryTextColor
                        : Colors.white,
                  ),
                ),
                onTap: () {
                  langCur = item.key;
                  S.load(Locale(item.key));
                  myShared.setString('langCur', item.key);
                  langSteamController.sink.add(item.key);
                  Navigator.pop(context);
                },
              )
          ],
        ),
      ),
    );
  }
}
