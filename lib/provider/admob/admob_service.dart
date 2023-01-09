import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  AdMobService._();

  static AdMobService? _instance;

  static AdMobService get instance {
    _instance ??= AdMobService._();
    return _instance!;
  }

  String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-5726417511192387/1590401387'
      : 'ca-app-pub-5726417511192387/1590401387';

  String get InterstitialAdUnitId => 'ca-app-pub-5726417511192387/9970372711';

  String get rewardAdUnitId => 'ca-app-pub-3940256099942544/5224354917';

  BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Ad loaded.'),
    onAdFailedToLoad: (ad, err) {
      ad.dispose();
      debugPrint('ad failed to load => $err');
    }
  );
}
