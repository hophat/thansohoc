import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/generated/l10n.dart';
import 'package:intl/intl.dart';
enum SingingCharacter {  EN, VI }
// ignore: camel_case_types
class settingPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _MySettingPage();
  }


}
class _MySettingPage extends State<settingPage> {

  SingingCharacter?  _character = SingingCharacter.EN;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  print(Intl.getCurrentLocale());
    if(  Intl.getCurrentLocale() == 'vi') {
      _character = SingingCharacter.VI;
    }else{
      _character = SingingCharacter.EN;
    }

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
                  S.of(context).chon_ngon_ngu,
                  style: TextStyle(fontSize: 26, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
                width: 100,
              ),
              ListTile(
                title: Text(
                  "English",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                leading: Radio(
                  activeColor:Colors.white,
                  value: SingingCharacter.EN,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      S.load(Locale('en', 'US'));
                    });
                  },
                ),
                  onTap: (()=>{
                  setState(() {
                  _character = SingingCharacter.EN;
                  S.load(Locale('en', 'US'));
                  }),
                  }),
              ),
              ListTile(
                title: Text(
                  "Viet Nam",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                leading: Radio(
                  activeColor:Colors.white,
                  value: SingingCharacter.VI,
                  groupValue: _character,
                  onChanged: (SingingCharacter ? value) {
                    setState(() {
                      _character = value;
                      S.load(Locale('vi', 'VN'));
                    });
                  },
                ),
                onTap: (()=>{
                  setState(() {
                    _character = SingingCharacter.VI;
                    S.load(Locale('vi', 'VN'));
                  }),
                }),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

}

