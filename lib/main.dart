import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/hangngay/hangngay.dart';
import 'package:flutter_app_than_so_hoc_2/class/Lang.dart';
import 'package:flutter_app_than_so_hoc_2/provider/admob/admob_service.dart';
import 'package:flutter_app_than_so_hoc_2/provider/local_db/shared_pref.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/home/home.dart';
import 'Pages/setting/setting.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  myShared = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  // ignore: non_constant_identifier_names
  String title_app = '';

  // ignore: non_constant_identifier_names
  String title_app_2 = '';

  String menu_1 = '';

  String menu_2 = '';

  String menu_3 = '';

  InterstitialAd? _interstitialAd;

  int _currentIndex = 0;
  // final List<Widget> _pages = [HomePage(), HangNgayPage(), settingPage()];
  final List<Widget> _pages = [HomePage(), settingPage()];

  @override
  Widget build(BuildContext context) {
    title_app = 'Home';
    title_app_2 = 'Home';
    menu_1 = 'Home';
    // menu_2 = 'Today';
    menu_3 = 'Languages';
    if (Intl.getCurrentLocale() == 'vi_VN' || Intl.getCurrentLocale() == 'vi') {
      title_app = "Thần Số Học";
      title_app_2 = "Thần Số Học";
      menu_1 = "Xem ngày sinh";
      // menu_2 = "Tử vi hôm nay";
      menu_3 = "Ngôn ngữ";
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title_app,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      initialRoute: '/',
      builder: EasyLoading.init(),
      home: MainPage(),
      // home: BackdropScaffold(
      //   backLayerBackgroundColor: Color(0xffc9a70e),
      //   frontLayerBorderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      //   appBar: BackdropAppBar(
      //     title: Text(title_app_2),
      //     backgroundColor: Color(0xffc9a70e),
      //     // backgroundColor: Color(0xff000d24),
      //     actions: <Widget>[
      //       BackdropToggleButton(
      //         icon: AnimatedIcons.list_view,
      //         color: Colors.white,
      //       )
      //     ],
      //     excludeHeaderSemantics: true,
      //   ),
      //   stickyFrontLayer: true,
      //   frontLayer: _pages[_currentIndex],
      //   backLayer: BackdropNavigationBackLayer(
      //     items: [
      //       ListTile(
      //           title: Text(menu_1, style: TextStyle(color: Colors.white))),
      //       // ListTile(
      //       //     title: Text(
      //       //   menu_2,
      //       //   style: TextStyle(color: Colors.white),
      //       // )),
      //       ListTile(
      //           title: Text(
      //         menu_3,
      //         style: TextStyle(color: Colors.white),
      //       )),
      //     ],
      //     onTap: (int position) => {setState(() => _currentIndex = position)},
      //   ),
      // ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BannerAd? _banner;

  _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.banner,
      // adUnitId: 'ca-app-pub-5726417511192387/1590401387',
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      listener: AdMobService.instance.bannerAdListener,
      request: AdRequest(),
    );
    _banner?.load();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context, builder: (_) => settingPage());
              },
              icon: Icon(Icons.language)),
        ],
      ),
      body: StreamBuilder<String>(
        stream: langSteamController.stream,
        initialData: langCur,
        builder: (_, __){
          return HomePage();
        },
      ),
      bottomNavigationBar: _banner == null
          ? SizedBox.shrink()
          : Container(
              // margin: const EdgeInsets.only(bottom: 12),
              height: _banner?.size.height.toDouble(),
              width: _banner?.size.width.toDouble(),
              child: AdWidget(ad: _banner!),
            ),
    );
  }
}
