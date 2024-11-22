import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/app/locator/app_locator.dart';
import 'package:flutter_app_than_so_hoc_2/class/Lang.dart';
import 'package:flutter_app_than_so_hoc_2/provider/auth/auth_provider.dart';
import 'package:flutter_app_than_so_hoc_2/provider/list_extension.dart';
import 'package:flutter_app_than_so_hoc_2/provider/local_db/shared_pref.dart';
import 'package:flutter_app_than_so_hoc_2/provider/navigator_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spine_flutter/spine_flutter.dart' as spine;
import 'Pages/home/home.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'provider/notification/app_notification_service.dart';

String langCur = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configLocator();
  await ScreenUtil.ensureScreenSize();
  await spine.initSpineFlutter(enableMemoryDebugging: false);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  AppNotiService().initNotifications();
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  if(Platform.isAndroid) {
    MobileAds.instance.initialize();
  }
  myShared = getIt.get<SharedPreferences>();
  langCur = await myShared.getString('langCur') ?? '';
  print('langCur before => $langCur');
  if (langCur.isNotEmpty) {
    await S.load(Locale(langCur));
  }else{
    final localeNames = Platform.localeName.split('_');
    if(localeNames.isNotEmpty){
      langCur = localeNames.first;
    }else{
      langCur = 'en';
    }
    await S.load(Locale(langCur));
  }

  print('langCur after => $langCur');
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }


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
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, c) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthProvider(), lazy: false),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: title_app,
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              locale: _findLocale(langCur),
              initialRoute: '/',
              navigatorKey: NavigatorService.I.navigatorKey,
              builder: EasyLoading.init(),
              home: MainPage(),
            ),
          );
        });
  }

  Locale _findLocale(String? code) {
    return Locale(listLang
        .firstWhereOrDefault(
            (element) => element.key.toUpperCase() == code?.toUpperCase(),
            defaultValue: listLang.first)
        .key);
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    langSteamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<String>(
        stream: langSteamController.stream,
        initialData: langCur,
        builder: (_, __) {
          return HomePage();
        },
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     // return;
      //     String jsonString = await rootBundle.loadString('assets/data/sochudao.json');
      //     final data = json.decode(jsonString);
      //     EasyLoading.show();
      //     for(final cc in data) {
      //       // cc['lang'] = 'vi';
      //       await FirebaseFirestore.instance.collection('sochudao').add(cc);
      //     }
      //     EasyLoading.dismiss();
      //
      //   },
      // ),
    );
  }
}



class MyAppQQ extends StatelessWidget {
  const MyAppQQ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Blend Mode Negative Example")),
        body: Center(
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix(
              <double>[
                -1,  0,  0,  0, 255, // Red
                0, -1,  0,  0, 255, // Green
                0,  0, -1,  0, 255, // Blue
                0,  0,  0,  1,   0, // Alpha
              ],
            ),
            child: Stack(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.matrix(
                    <double>[
                      1.5, 0, 0, 0, -75, // Tăng đỏ và giảm nền tối
                      0, 1.5, 0, 0, -75, // Tăng xanh lá và giảm nền tối
                      0, 0, 1.5, 0, -75, // Tăng xanh dương và giảm nền tối
                      0, 0, 0, 1, 0,    // Alpha không đổi
                    ],
                  ),
                  child: Image.asset(
                    'assets/IMG_4178.JPG',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
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

