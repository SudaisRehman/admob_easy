import 'package:admob_easy/admob_easy.dart';
import 'package:flutter/material.dart';

/// A widget that displays a native ad from AdMob.
class AdmobEasyNative extends StatefulWidget {
  const AdmobEasyNative.smallTemplate({
    this.minWidth = 320,
    this.minHeight = 90,
    this.maxWidth = 400,
    this.maxHeight = 200,
    this.templateType = TemplateType.small,
    super.key,
    this.onAdClicked,
    this.onAdClosed,
    this.onAdImpression,
    this.onAdOpened,
    this.onAdWillDismissScreen,
    this.onPaidEvent,
  });

  final double minWidth;
  final double minHeight;
  final double maxWidth;
  final double maxHeight;
  final TemplateType templateType;
  final void Function(Ad)? onAdClicked;
  final void Function(Ad)? onAdClosed;
  final void Function(Ad)? onAdImpression;
  final void Function(Ad)? onAdOpened;
  final void Function(Ad)? onAdWillDismissScreen;
  final void Function(Ad, double, PrecisionType, String)? onPaidEvent;

  @override
  State<AdmobEasyNative> createState() => _AdmobEasyNativeState();
}

class _AdmobEasyNativeState extends State<AdmobEasyNative> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadNativeAd();
  }

  void _loadNativeAd() {
    final ad = NativeAd(
      adUnitId: AdmobEasy.instance.nativeAdID,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _nativeAd = ad as NativeAd;
            _isAdLoaded = true; // Ad is loaded
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('NativeAd failed to load: $error');
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: widget.templateType,
      ),
    );

    ad.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded) {
      return SizedBox(
        width: widget.minWidth,
        height: widget.minHeight,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.minWidth,
        minHeight: widget.minHeight,
        maxWidth: widget.maxWidth,
        maxHeight: widget.maxHeight,
      ),
      child: AdWidget(
        ad: _nativeAd!,
        key: ValueKey(_nativeAd!.hashCode),
      ),
    );
  }
}
