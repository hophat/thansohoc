import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/class/Lang.dart';
import 'package:flutter_app_than_so_hoc_2/generated/l10n.dart';
import 'package:flutter_app_than_so_hoc_2/provider/local_db/shared_pref.dart';
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
    if(langCur.isNotEmpty) return;
    listLang.forEach((ele) {
      if(Intl.getCurrentLocale() == ele.key) {
        langCur = ele.key;
      }
    });
  }

  @override
// const settingPage({Key ? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Material(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(46.0)),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg01.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Card(
            color: Color(0x000d2421),
            child: ListView(
              // mainAxisSize: MainAxisSize.min,
              padding: EdgeInsets.all(20.0),
              children: <Widget>[
                ListTile(
                  title: Text(
                    S.current.chon_ngon_ngu,
                    style: TextStyle(fontSize: 26, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 100,
                ),
                for (var item in listLang)
                  ListTile(
                    title: Text(
                      item.lable,
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                    leading: Radio(
                      activeColor: Colors.white,
                      value: item.key,
                      groupValue: langCur,
                      onChanged: (value) {
                        S.load(Locale(item.key));
                        myShared.setString('langCur', item.key);
                        langSteamController.sink.add(item.key);
                        Navigator.pop(context);
                      },
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
        ),
      ),
    );
  }
}
