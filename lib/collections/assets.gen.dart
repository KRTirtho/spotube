/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsLogosGen {
  const $AssetsLogosGen();

  /// File path: assets/logos/songlink-transparent.png
  AssetGenImage get songlinkTransparent =>
      const AssetGenImage('assets/logos/songlink-transparent.png');

  /// File path: assets/logos/songlink.png
  AssetGenImage get songlink =>
      const AssetGenImage('assets/logos/songlink.png');

  /// List of all assets
  List<AssetGenImage> get values => [songlinkTransparent, songlink];
}

class $AssetsTutorialGen {
  const $AssetsTutorialGen();

  /// File path: assets/tutorial/step-1.png
  AssetGenImage get step1 => const AssetGenImage('assets/tutorial/step-1.png');

  /// File path: assets/tutorial/step-2.png
  AssetGenImage get step2 => const AssetGenImage('assets/tutorial/step-2.png');

  /// File path: assets/tutorial/step-3.png
  AssetGenImage get step3 => const AssetGenImage('assets/tutorial/step-3.png');

  /// List of all assets
  List<AssetGenImage> get values => [step1, step2, step3];
}

class Assets {
  Assets._();

  static const AssetGenImage albumPlaceholder =
      AssetGenImage('assets/album-placeholder.png');
  static const AssetGenImage bengaliPatternsBg =
      AssetGenImage('assets/bengali-patterns-bg.jpg');
  static const AssetGenImage branding = AssetGenImage('assets/branding.png');
  static const AssetGenImage emptyBox = AssetGenImage('assets/empty_box.png');
  static const AssetGenImage invidious = AssetGenImage('assets/invidious.jpg');
  static const AssetGenImage jiosaavn = AssetGenImage('assets/jiosaavn.png');
  static const AssetGenImage likedTracks =
      AssetGenImage('assets/liked-tracks.jpg');
  static const $AssetsLogosGen logos = $AssetsLogosGen();
  static const AssetGenImage placeholder =
      AssetGenImage('assets/placeholder.png');
  static const AssetGenImage spotubeHeroBanner =
      AssetGenImage('assets/spotube-hero-banner.png');
  static const AssetGenImage spotubeLogoForeground =
      AssetGenImage('assets/spotube-logo-foreground.jpg');
  static const AssetGenImage spotubeLogoBmp =
      AssetGenImage('assets/spotube-logo.bmp');
  static const String spotubeLogoIco = 'assets/spotube-logo.ico';
  static const AssetGenImage spotubeLogoPng =
      AssetGenImage('assets/spotube-logo.png');
  static const String spotubeLogoSvg = 'assets/spotube-logo.svg';
  static const AssetGenImage spotubeLogoAndroid12 =
      AssetGenImage('assets/spotube-logo_android12.png');
  static const AssetGenImage spotubeNightlyLogoForeground =
      AssetGenImage('assets/spotube-nightly-logo-foreground.jpg');
  static const AssetGenImage spotubeNightlyLogoPng =
      AssetGenImage('assets/spotube-nightly-logo.png');
  static const String spotubeNightlyLogoSvg = 'assets/spotube-nightly-logo.svg';
  static const AssetGenImage spotubeNightlyLogoAndroid12 =
      AssetGenImage('assets/spotube-nightly-logo_android12.png');
  static const AssetGenImage spotubeScreenshot =
      AssetGenImage('assets/spotube-screenshot.png');
  static const AssetGenImage spotubeTallCapsule =
      AssetGenImage('assets/spotube-tall-capsule.png');
  static const AssetGenImage spotubeWideCapsuleLarge =
      AssetGenImage('assets/spotube-wide-capsule-large.png');
  static const AssetGenImage spotubeWideCapsuleSmall =
      AssetGenImage('assets/spotube-wide-capsule-small.png');
  static const AssetGenImage spotubeBanner =
      AssetGenImage('assets/spotube_banner.png');
  static const AssetGenImage success = AssetGenImage('assets/success.png');
  static const $AssetsTutorialGen tutorial = $AssetsTutorialGen();
  static const AssetGenImage userPlaceholder =
      AssetGenImage('assets/user-placeholder.png');

  /// List of all assets
  static List<dynamic> get values => [
        albumPlaceholder,
        bengaliPatternsBg,
        branding,
        emptyBox,
        invidious,
        jiosaavn,
        likedTracks,
        placeholder,
        spotubeHeroBanner,
        spotubeLogoForeground,
        spotubeLogoBmp,
        spotubeLogoIco,
        spotubeLogoPng,
        spotubeLogoSvg,
        spotubeLogoAndroid12,
        spotubeNightlyLogoForeground,
        spotubeNightlyLogoPng,
        spotubeNightlyLogoSvg,
        spotubeNightlyLogoAndroid12,
        spotubeScreenshot,
        spotubeTallCapsule,
        spotubeWideCapsuleLarge,
        spotubeWideCapsuleSmall,
        spotubeBanner,
        success,
        userPlaceholder
      ];
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
