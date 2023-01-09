import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/event/event_success_page.dart';
import 'package:flutter_app_than_so_hoc_2/provider/admob/admob_service.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<int> _lixis = List.generate(30, (index) => Random().nextInt(4)).toList();
  Set<int> _chooses = {};

  RewardedAd? _rewardedAd;

  PageController _pageController =
  PageController(initialPage: 0, viewportFraction: 0.75);

  double _currentPage = 0.0;

  _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdMobService.instance.rewardAdUnitId,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          _rewardedAd = ad;
        }, onAdFailedToLoad: (err) {
          _rewardedAd = null;
        }));
  }

  _showRewardAd(int itemSelected) async {
    // showDialog(
    //   context: context,
    //   useSafeArea: true,
    //   builder: (_) => AlertDialog(
    //     content: EventSuccessPage(),
    //   ),
    // );
    //
    // return;

    if (_rewardedAd == null) {
      _createRewardedAd();
      return;
    }
    _rewardedAd?.fullScreenContentCallback =
        FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createRewardedAd();
          showDialog(
            context: context,
            useSafeArea: true,
            builder: (_) => AlertDialog(
              content: EventSuccessPage(),
            ),
          );
          _chooses.add(itemSelected);
          setState(() {});
        }, onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          _createRewardedAd();
        });
    await _rewardedAd?.show(onUserEarnedReward: (ad, reward) {});
    _rewardedAd = null;
  }

  _pageListener() {
    setState(() {
      _currentPage = _pageController.page!;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_pageListener);
    _createRewardedAd();
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double itemWidth = 100;
    return Scaffold(
      // appBar: AppBar(
      //   leading: const SizedBox.shrink(),
      //   backgroundColor: Colors.red,
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       image: DecorationImage(
      //         image: AssetImage(
      //           'assets/tet/pattern-bg.png',
      //         ),
      //         colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.darken),
      //         opacity: 0.5,
      //         fit: BoxFit.cover,
      //       )
      //     ),
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       icon: Icon(Icons.close),
      //     )
      //   ],
      // ),
      body: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: _lixis.length,
          itemBuilder: (_, index) {
            if (index == 0) return const SizedBox();
            final result = _currentPage - index + 1;
            print(result);
            int lixi = _lixis[index - 1];

            final value = -0.4 * result + 1;
            final size = MediaQuery.of(context).size;

            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..scale(value)
                ..translate(size.height / 2.6 * (1 - value).abs()),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/tet/lixi_$lixi.png'),
                      fit: BoxFit.fitHeight),
                ),
                alignment: Alignment.center,
                child: _chooses.contains(index)
                    ? Icon(
                  Icons.check_circle_outline,
                  color: Colors.white70,
                  size: itemWidth,
                )
                    : null,
              ),
            );
          }),
      // body: MasonryGridView.count(
      //   itemCount: _lixis.length,
      //   // crossAxisCount: 3,
      //   crossAxisCount: MediaQuery.of(context).size.width ~/ itemWidth,
      //   mainAxisSpacing: MediaQuery.of(context).size.width / itemWidth,
      //   crossAxisSpacing: MediaQuery.of(context).size.width / itemWidth,
      //   itemBuilder: (context, index) {
      //     return GestureDetector(
      //       onTap: () async {
      //         if(_chooses.contains(index)) return;
      //         await _showRewardAd(index);
      //       },
      //       child: Container(
      //         // color: Color.fromRGBO(Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 100),
      //         height: itemWidth * 2,
      //         width: itemWidth,
      //         decoration: BoxDecoration(
      //           image: DecorationImage(
      //               image: AssetImage('assets/tet/lixi_${_lixis[index]}.png'),
      //               fit: BoxFit.fitHeight),
      //         ),
      //         alignment: Alignment.center,
      //         child: _chooses.contains(index)
      //             ? Icon(
      //                 Icons.check_circle_outline,
      //                 color: Colors.white70,
      //                 size: itemWidth,
      //               )
      //             : null,
      //       ),
      //     );
      //   },
      // ),
    );
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}

