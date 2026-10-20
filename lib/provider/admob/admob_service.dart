import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  AdMobService._();

  static AdMobService? _instance;

  static AdMobService get instance {
    _instance ??= AdMobService._();
    return _instance!;
  }

  // String get bannerAdUnitId => 'ca-app-pub-8539908368627646/4176119972';
  String get bannerAdUnitId {
    if(Platform.isAndroid) {
      return kDebugMode ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-8539908368627646/4176119972';
    }
    return 'ca-app-pub-3940256099942544/2934735716';
  }

  String get rewardAdUnitId {
    if(Platform.isAndroid) {
      return kDebugMode ? 'ca-app-pub-3940256099942544/5224354917' : 'ca-app-pub-8539908368627646/6003125396';
    }
    return 'ca-app-pub-3940256099942544/1712485313';
  }

  // String get InterstitialAdUnitId => 'ca-app-pub-8539908368627646/9674777099';
  String get InterstitialAdUnitId {
    if(Platform.isAndroid) {
      return kDebugMode ? 'ca-app-pub-3940256099942544/1033173712' : 'ca-app-pub-8539908368627646/9674777099';
    }
    return 'ca-app-pub-3940256099942544/6978759866';
  }
  // String get rewardAdUnitId => '';

  BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Ad loaded.'),
    onAdFailedToLoad: (ad, err) {
      ad.dispose();
      debugPrint('ad failed to load => $err');
    }
  );
}
