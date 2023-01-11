import 'dart:math';
import 'dart:ui';

// import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/Pages/event/event_success_page.dart';
import 'package:flutter_app_than_so_hoc_2/provider/admob/admob_service.dart';
import 'package:flutter_app_than_so_hoc_2/provider/local_db/shared_pref.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';



import '../../generated/l10n.dart';class EventPage2 extends StatefulWidget {
  const EventPage2({Key? key}) : super(key: key);

  @override
  State<EventPage2> createState() => _EventPageState2();
}

class _EventPageState2 extends State<EventPage2> {

  final _audio = AudioPlayer();

  List<int> _lixis = List.generate(30, (index) => Random().nextInt(7)).toList();
  Set<int> _chooses = {};
  List<String> _choosesStr = [];

  int get _initialIndex => 0;

  int _currentLixi = -1;

  Size get _size => MediaQuery.of(context).size;

  RewardedAd? _rewardedAd;

  _createRewardedAd() async {
    await RewardedAd.load(
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
        FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) async {
      ad.dispose();
      _createRewardedAd();
      await showDialog(
        context: context,
        useSafeArea: true,
        builder: (_) => AlertDialog(
          content: EventSuccessPage(),
        ),
      );
      _chooses.add(itemSelected);
      _choosesStr.clear();
      _choosesStr = _chooses.map((e) => e.toString()).toList();
      myShared.setStringList('_chooses', _choosesStr);
      await _audio.resume();
      setState(() {});
    }, onAdFailedToShowFullScreenContent: (ad, err) async {
      ad.dispose();
      _createRewardedAd();
      await _audio.resume();
    });
    await _rewardedAd?.show(onUserEarnedReward: (ad, reward) {});
    _rewardedAd = null;
  }

  _setUpChooseList() {
    _choosesStr = myShared.getStringList('_chooses') ?? [];
    _chooses = _choosesStr.map((e) => int.parse(e)).toSet();
  }

  @override
  void initState() {
    super.initState();
    _currentLixi = _initialIndex;
    _setUpChooseList();
    _createRewardedAd();
    _audio.play(AssetSource('tet/new_year_audio.wav'));
    _audio.onPlayerComplete.listen((event) async{
      await _audio.stop();
      _audio.play(AssetSource('tet/new_year_audio.wav'));
    });
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _audio.stop();
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 1.7;
    final _visibleItems = 5;
    final _itemExtent = size.height * 0.7 - kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        backgroundColor: Color(0xFFFF5449),
        title: Text(S.of(context).happy_new_year, style: GoogleFonts.getFont('Rye')),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/tet/bg_tet.png'), fit: BoxFit.cover)),
        child: Stack(
          children: [
            Column(
              children: [
                // Expanded(
                //   child: PerspectiveListView(
                //     visualizedItems: _visibleItems,
                //     itemExtent: _itemExtent,
                //     initialIndex: _initialIndex,
                //     enableBackItemsShadow: true,
                //     backItemsShadowColor:
                //         Theme.of(context).scaffoldBackgroundColor,
                //     padding: const EdgeInsets.all(10),
                //     // onTapFrontItem: (index) {
                //     //   print(index);
                //     // },
                //     onChangeFrontItem: (index) {
                //       _currentLixi = index;
                //     },
                //     children: List.generate(
                //       _lixis.length,
                //       (index) {
                //         int lixi = _lixis[index];
                //         return Container(
                //             decoration: BoxDecoration(
                //               image: DecorationImage(
                //                   image:
                //                       AssetImage('assets/tet/lixi_$lixi.png'),
                //                   fit: BoxFit.fitHeight),
                //             ),
                //             alignment: Alignment.center,
                //             child: _chooses.contains(index)
                //                 ? Icon(
                //                     Icons.check_circle_outline,
                //                     color: Colors.white70,
                //                     size: itemWidth,
                //                   )
                //                 : null);
                //       },
                //     ),
                //   ),
                // ),
                // Expanded(
                //   child: AppinioSwiper(
                //     duration:const Duration(milliseconds: 100),
                //     unlimitedUnswipe: true,
                //     onSwipe: (index, _) {
                //       _currentLixi = index;
                //       print(_currentLixi);
                //     },
                //     onEnd: () {
                //       _currentLixi = _initialIndex;
                //       print('end => $_currentLixi');
                //       setState(() {
                //
                //       });
                //     },
                //     cards: List.generate(
                //       _lixis.length,
                //       (index) {
                //         int lixi = _lixis[index];
                //         return Container(
                //             decoration: BoxDecoration(
                //               image: DecorationImage(
                //                   image:
                //                       AssetImage('assets/tet/lixi_$lixi.png'),
                //                   fit: BoxFit.fitHeight),
                //             ),
                //             alignment: Alignment.center,
                //             child: _chooses.contains(index)
                //                 ? Icon(
                //                     Icons.check_circle_outline,
                //                     color: Colors.white70,
                //                     size: itemWidth,
                //                   )
                //                 : null);
                //       },
                //     ),
                //   ),
                // ),
                const SizedBox(height: 15),
                Expanded(
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      int lixi = _lixis[index];
                      return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                AssetImage('assets/tet/lixi_$lixi.png'),
                                fit: BoxFit.fitHeight),
                          ),
                          alignment: Alignment.center,
                          child: _chooses.contains(index)
                              ? Icon(
                            Icons.check_circle_outline,
                            color: Colors.white70,
                            size: itemWidth/2.5,
                          )
                              : null);
                    },
                    onIndexChanged: (index) {
                      _currentLixi = index;
                    },
                    itemCount: _lixis.length,
                    // layout: SwiperLayout.STACK,
                    // itemWidth: 300.0,
                    // itemHeight: 300,
                    viewportFraction: 0.3,
                    scale: 0.5,

                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () async {
                    if (_chooses.contains(_currentLixi)) return;
                    await _audio.pause();
                    _showRewardAd(_currentLixi);
                  },
                  child: Container(
                    width: 186,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/tet/tet_btn.png'))),
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(S.of(context).open_red_envelopes,
                          style: GoogleFonts.getFont('Bahianita',
                              color: Colors.white, fontSize: 28)),
                    ),
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
            Transform.rotate(
                angle: pi / 12,
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/tet/hoa_mai.png',
                  fit: BoxFit.fitWidth,
                  width: _size.width / 3,
                ))
          ],
        ),
      ),
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

class PerspectiveListView extends StatefulWidget {
  const PerspectiveListView({
    Key? key,
    required this.visualizedItems,
    required this.itemExtent,
    required this.children,
    this.initialIndex = 0,
    this.padding = EdgeInsets.zero,
    this.onTapFrontItem,
    this.onChangeFrontItem,
    this.backItemsShadowColor = Colors.transparent,
    this.enableBackItemsShadow = false,
  });

  final List<Widget> children;
  final double? itemExtent;
  final int? visualizedItems;
  final int initialIndex;
  final EdgeInsetsGeometry padding;
  final ValueChanged<int?>? onTapFrontItem;
  final ValueChanged<int>? onChangeFrontItem;
  final Color backItemsShadowColor;
  final bool enableBackItemsShadow;

  @override
  PerspectiveListViewState createState() => PerspectiveListViewState();
}

class PerspectiveListViewState extends State<PerspectiveListView> {
  PageController? _pageController;
  int? _currentIndex;
  double? _pagePercent;

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    _pageController = PageController(
      viewportFraction: 1 / widget.visualizedItems!,
      initialPage: _currentIndex!,
    );
    _pagePercent = 0.0;
    _pageController!.addListener(_pageListener);
    super.initState();
  }

  @override
  void dispose() {
    _pageController!
      ..removeListener(_pageListener)
      ..dispose();
    super.dispose();
  }

  void _pageListener() {
    _currentIndex = _pageController!.page!.floor();
    _pagePercent = (_pageController!.page! - _currentIndex!).abs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return Stack(
          children: [
            //---------------------------------------
            // Perspective Items List
            //---------------------------------------
            Padding(
              padding: widget.padding,
              child: _PerspectiveItems(
                generatedItems: widget.visualizedItems! - 1,
                currentIndex: _currentIndex,
                heightItem: widget.itemExtent,
                pagePercent: _pagePercent,
                children: widget.children,
              ),
            ),
            //---------------------------------------
            // Back Items Shadow
            //---------------------------------------
            if (widget.enableBackItemsShadow)
              Positioned.fill(
                bottom: widget.itemExtent,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.backItemsShadowColor.withOpacity(.8),
                        widget.backItemsShadowColor.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ),
            //---------------------------------------
            // Void Page View
            //---------------------------------------
            PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              onPageChanged: widget.onChangeFrontItem?.call,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.children.length,
              itemBuilder: (context, index) {
                return const SizedBox();
              },
            ),
            //---------------------------------------
            // On Tap Item Area
            //---------------------------------------
            Positioned.fill(
              top: height - widget.itemExtent!,
              child: GestureDetector(
                onTap: () => widget.onTapFrontItem?.call(_currentIndex),
              ),
            )
          ],
        );
      },
    );
  }
}

class _PerspectiveItems extends StatelessWidget {
  const _PerspectiveItems({
    required this.generatedItems,
    required this.currentIndex,
    required this.heightItem,
    required this.pagePercent,
    required this.children,
  });

  final int generatedItems;
  final int? currentIndex;
  final double? heightItem;
  final double? pagePercent;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return Stack(
          fit: StackFit.expand,
          children: [
            //---------------------------------
            // Static Last Item
            //---------------------------------
            if (currentIndex! > (generatedItems - 1))
              _TransformedItem(
                heightItem: heightItem,
                factorChange: 1,
                endScale: .5,
                child: children[currentIndex! - generatedItems],
              )
            else
              const SizedBox(),
            //----------------------------------
            // Perspective Items
            //----------------------------------
            for (int index = 0; index < generatedItems; index++)
              (currentIndex! > ((generatedItems - 2) - index))
                  ? _TransformedItem(
                      heightItem: heightItem,
                      factorChange: pagePercent,
                      scale: lerpDouble(0.5, 1, (index + 1) / generatedItems),
                      translateY:
                          (height - heightItem!) * (index + 1) / generatedItems,
                      endScale: lerpDouble(0.5, 1, index / generatedItems),
                      endTranslateY:
                          (height - heightItem!) * (index / generatedItems),
                      child: children[
                          currentIndex! - (((generatedItems - 2) - index) + 1)],
                    )
                  : const SizedBox(),
            //---------------------------------
            // Bottom Hide Item
            //---------------------------------
            if (currentIndex! < (children.length - 1))
              Opacity(
                opacity: 0.5,
                child: _TransformedItem(
                  // alignment: Alignment.topRight,
                  // rotateZ: -2*pi/12,
                  // scale: 0.0,
                  heightItem: heightItem,
                  factorChange: pagePercent,
                  translateY: height * 1.2 + 20,
                  endTranslateY: height * 1.2 - heightItem!,
                  child: children[currentIndex! + 1],
                ),
              )
            else
              const SizedBox()
          ],
        );
      },
    );
  }
}

class _TransformedItem extends StatelessWidget {
  const _TransformedItem({
    Key? key,
    required this.heightItem,
    required this.child,
    required this.factorChange,
    this.endScale = 1.0,
    this.scale = 1.0,
    this.endTranslateY = 0.0,
    this.translateY = 0.0,
    this.alignment = Alignment.topCenter,
    this.rotateZ = 0.0,
  }) : super(key: key);

  final double rotateZ;
  final Alignment alignment;
  final Widget child;
  final double? heightItem;
  final double? factorChange;
  final double? endScale;
  final double endTranslateY;
  final double translateY;
  final double? scale;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: alignment,
      transform: Matrix4.identity()
        ..scale(lerpDouble(scale, endScale, factorChange!))
        ..rotateZ(rotateZ)
        ..translate(
          0.0,
          lerpDouble(translateY, endTranslateY, factorChange!)!,
        ),
      child: Align(
        alignment: alignment,
        child: SizedBox(
          height: heightItem,
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
