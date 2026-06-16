import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdTrigger {
  roomCreated,
  matchCompleted,
  roomSettingsSaved,
}

class InterstitialAdService {
  InterstitialAd? _loadedAd;
  bool _loading = false;
  bool _useTestFallback = false;

  static const String _androidTestUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _iosTestUnitId =
      'ca-app-pub-3940256099942544/4411468910';

  Future<void> initialize() async {
    if (kIsWeb) {
      return;
    }
    await MobileAds.instance.initialize();
  }

  Future<void> preload() async {
    if (kIsWeb || _loading || _loadedAd != null) {
      return;
    }

    final adUnitId = _adUnitId;
    if (adUnitId.isEmpty) {
      if (kDebugMode) {
        debugPrint('[Ads] No ad unit id configured');
      }
      return;
    }

    _loading = true;
    final completer = Completer<void>();

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _loadedAd = ad;
          _loading = false;
          if (kDebugMode) {
            debugPrint('[Ads] Interstitial preloaded ($_adUnitId)');
          }
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
        onAdFailedToLoad: (error) {
          debugPrint('[Ads] Interstitial preload failed ($_adUnitId): $error');
          _loading = false;
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      ),
    );

    await completer.future;
  }

  Future<void> ensureReady({
    Duration timeout = const Duration(seconds: 8),
  }) async {
    if (kIsWeb) {
      return;
    }

    final deadline = DateTime.now().add(timeout);
    while (_loadedAd == null && DateTime.now().isBefore(deadline)) {
      await preload();

      if (_loadedAd != null) {
        return;
      }

      if (!_loading &&
          kDebugMode &&
          !_useTestFallback &&
          _hasProductionAdUnitId) {
        _useTestFallback = true;
        debugPrint(
          '[Ads] Production ad unit unavailable — using Google test ads in debug.',
        );
        continue;
      }

      await Future<void>.delayed(const Duration(milliseconds: 400));
    }
  }

  Future<void> showIfReady(AdTrigger trigger) async {
    if (kIsWeb) {
      return;
    }

    final ad = _loadedAd;
    if (ad == null) {
      debugPrint('[Ads] No interstitial ready for ${trigger.name}');
      return;
    }

    _loadedAd = null;
    final completer = Completer<void>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) {
        if (kDebugMode) {
          debugPrint('[Ads] Interstitial visible for ${trigger.name}');
        }
      },
      onAdDismissedFullScreenContent: (dismissedAd) {
        dismissedAd.dispose();
        unawaited(preload());
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
      onAdFailedToShowFullScreenContent: (failedAd, error) {
        debugPrint('[Ads] Interstitial show failed: $error');
        failedAd.dispose();
        unawaited(preload());
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );

    await ad.show();
    await completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {},
    );
  }

  void dispose() {
    _loadedAd?.dispose();
    _loadedAd = null;
  }

  bool get _hasProductionAdUnitId {
    final configured = defaultTargetPlatform == TargetPlatform.iOS
        ? dotenv.env['ADMOB_IOS_INTERSTITIAL_ID']
        : dotenv.env['ADMOB_ANDROID_INTERSTITIAL_ID'];
    return configured != null && configured.isNotEmpty;
  }

  String get _adUnitId {
    if (_useTestFallback && kDebugMode) {
      return defaultTargetPlatform == TargetPlatform.iOS
          ? _iosTestUnitId
          : _androidTestUnitId;
    }

    final configured = defaultTargetPlatform == TargetPlatform.iOS
        ? dotenv.env['ADMOB_IOS_INTERSTITIAL_ID']
        : dotenv.env['ADMOB_ANDROID_INTERSTITIAL_ID'];

    if (configured != null && configured.isNotEmpty) {
      return configured;
    }

    if (kDebugMode) {
      return defaultTargetPlatform == TargetPlatform.iOS
          ? _iosTestUnitId
          : _androidTestUnitId;
    }

    return '';
  }
}
