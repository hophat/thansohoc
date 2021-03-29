import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';
import 'Pages/detail/detail.dart';
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
  final List<Widget> _pages = [HomePage(), DetailPage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backdrop Demo',
      initialRoute: '/',
      builder: EasyLoading.init(),
      home: BackdropScaffold(
        frontLayerBorderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        appBar: BackdropAppBar(
          title: Text("THẦN SỐ HỌC"),
          actions: <Widget>[
            BackdropToggleButton(
              icon: AnimatedIcons.list_view,
            )
          ],
          excludeHeaderSemantics: true,
        ),
        // stickyFrontLayer: true,
        frontLayer: _pages[_currentIndex],
        backLayer: BackdropNavigationBackLayer(
          items: [
            ListTile(title: Text("Tính toàn ngày sinh")),
            ListTile(title: Text("Thư viên")),
          ],
          onTap: (int position) => {setState(() => _currentIndex = position)},
        ),
      ),
    );
  }
}
