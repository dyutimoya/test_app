import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../widgets/banner_ad_widget.dart';
import '../config/app_config.dart';
import '../config/const.dart';

class AdService {
  static InterstitialAd? _interstitialAd;
  static bool _isInitialized = false;

  static AdSize get mediumRectangle => AdSize.mediumRectangle;
  static AdSize get largeBanner => AdSize.largeBanner;
  static AdSize get banner => AdSize.banner;

  static Future<void> initialize() async {
    if (!Const.enableAds || _isInitialized) return;

    await MobileAds.instance.initialize();

    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: [
          'D4FF9EF8A7418ECB47E9E0F7BB869051',
        ],
      ),
    );

    _isInitialized = true;
    await loadInterstitialAd();
  }

  static Widget bannerWidget(AdSize adSize) {
    if (!Const.enableAds) {
      return const SizedBox.shrink();
    }

    return BannerAdWidget(size: adSize);
  }

  static Future<void> loadInterstitialAd() async {
    if (!Const.enableAds || _interstitialAd != null) return;

    await InterstitialAd.load(
      adUnitId: Const.interstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed: ${error.message}');
          _interstitialAd = null;
        },
      ),
    );
  }

  static Future<void> showInterstitialAd() async {
    if (!Const.enableAds) return;

    if (_interstitialAd == null) {
      await loadInterstitialAd();
      return;
    }

    final ad = _interstitialAd!;
    _interstitialAd = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Interstitial display failed: ${error.message}');
        ad.dispose();
        loadInterstitialAd();
      },
    );

    await ad.show();
  }

  static void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
