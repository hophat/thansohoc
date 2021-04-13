import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/generated/l10n.dart';

// ignore: camel_case_types
class introPage extends StatelessWidget {
  @override
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
              padding: EdgeInsets.all(40.0),
              children: <Widget>[
                ListTile(
                  title: Text(
                    S.of(context).than_so_hoc_la_gi,
                    style: TextStyle(fontSize: 26, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 100,
                ),
                ListTile(
                  subtitle: Text(
                    S.of(context).introl_1,
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ),
                ListTile(
                  subtitle: Text(
                    S.of(context).introl_2,
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
