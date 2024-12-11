import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'admob_service.dart';

class AdmobProvider extends ChangeNotifier {
  InterstitialAd? _interstitialAd;

  void load() {
    InterstitialAd.load(
      // adUnitId: 'ca-app-pub-3940256099942544/1033173712',//test
        adUnitId: AdMobService.instance.InterstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          _interstitialAd = ad;
        }, onAdFailedToLoad: (err) {
          _interstitialAd = null;
        }));
  }

  show() async {
    if(kDebugMode) return;
    if(_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            print('admob => onAdDismissedFullScreenContent => $ad');
            ad.dispose();
            load();
          }, onAdFailedToShowFullScreenContent: (ad, err) {
            print('admob => onAdFailedToShowFullScreenContent => $err');
            ad.dispose();
            load();
          });
      _interstitialAd!.show();
      _interstitialAd = null;
    }

    await _interstitialAd?.show();
    print('admob => show completed');
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }
}