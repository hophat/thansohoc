import 'package:flutter/material.dart';

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
                    "THẦN SỐ HỌC LÀ GÌ ?",
                    style: TextStyle(fontSize: 26, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 100,
                ),
                ListTile(
                  subtitle: Text(
                    "Thần số học sẽ dựa trên tên và ngày sinh của bạn để dự đoán về bạn một cách toàn diện."
                    " Với Thần số học toàn diện, hãy xem những con số quan trọng có ảnh hưởng như thế nào với cuộc sống của bạn.",
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ),
                ListTile(
                  subtitle: Text(
                    "Ứng dụng sẽ phân tích tên và ngày sinh của bạn để đưa ra kết quả trong chớp mắt! Tìm hiểu về số"
                    " sinh hoặc số đường đời (nói lên tính cách và quan điểm của bạn trong cuộc sống)"
                    ". Hãy xem những con số này nói điều gì về bạn.",
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
