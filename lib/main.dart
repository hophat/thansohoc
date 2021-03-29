import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';
import 'file:///E:/AndroidStudioProjects/flutter_app_than_so_hoc_2/lib/Pages/introl/intro.dart';

// @dart=2.9
import 'Pages/home/home.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
    throw UnimplementedError();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int _currentIndex = 0;
  final List<Widget> _pages = [HomePage(), introPage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THẦN SỐ HỌC',
      initialRoute: '/',
      builder: EasyLoading.init(),
      home: BackdropScaffold(
        // backgroundColor: Color(0xff000d24),
        // backgroundColor: Color(0xffc9a70e),
        // frontLayerBackgroundColor: Color(0xffc9a70e),
        backLayerBackgroundColor: Color(0xffc9a70e),
        frontLayerBorderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        appBar: BackdropAppBar(
          title: Text(
            "THẦN SỐ HỌC",
            // style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color(0xffc9a70e),
          // backgroundColor: Color(0xff000d24),
          actions: <Widget>[
            BackdropToggleButton(
              icon: AnimatedIcons.list_view,
              color: Colors.white,
            )
          ],
          excludeHeaderSemantics: true,
        ),
        stickyFrontLayer: true,
        frontLayer: _pages[_currentIndex],
        backLayer: BackdropNavigationBackLayer(
          items: [
            ListTile(
                title: Text("Tính toàn ngày sinh",
                    style: TextStyle(color: Colors.white))),
            ListTile(
                title: Text(
              "Giới thiệu",
              style: TextStyle(color: Colors.white),
            )),
          ],
          onTap: (int position) => {setState(() => _currentIndex = position)},
        ),
      ),
    );
  }
}
