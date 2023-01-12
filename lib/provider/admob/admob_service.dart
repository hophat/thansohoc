import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  AdMobService._();

  static AdMobService? _instance;

  static AdMobService get instance {
    _instance ??= AdMobService._();
    return _instance!;
  }

  String get bannerAdUnitId => 'ca-app-pub-8539908368627646/4176119972';
  // String get bannerAdUnitId => kDebugMode ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-8539908368627646/4176119972';

  String get InterstitialAdUnitId => 'ca-app-pub-8539908368627646/9674777099';
  // String get InterstitialAdUnitId => kDebugMode ? 'ca-app-pub-3940256099942544/1033173712' : 'ca-app-pub-8539908368627646/9674777099';

  // String get rewardAdUnitId => kDebugMode ? 'ca-app-pub-3940256099942544/5224354917' : '';
  String get rewardAdUnitId => '';

  BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Ad loaded.'),
    onAdFailedToLoad: (ad, err) {
      ad.dispose();
      debugPrint('ad failed to load => $err');
    }
  );
}
