/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

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
  static const AssetGenImage emptyBox = AssetGenImage('assets/empty_box.png');
  static const AssetGenImage placeholder =
      AssetGenImage('assets/placeholder.png');
  static const AssetGenImage spotubeLogoForeground =
      AssetGenImage('assets/spotube-logo-foreground.jpg');
  static const AssetGenImage spotubeLogoPng =
      AssetGenImage('assets/spotube-logo.png');
  static const SvgGenImage spotubeLogoSvg =
      SvgGenImage('assets/spotube-logo.svg');
  static const AssetGenImage spotubeScreenshot =
      AssetGenImage('assets/spotube-screenshot.jpg');
  static const AssetGenImage spotubeBanner =
      AssetGenImage('assets/spotube_banner.png');
  static const AssetGenImage success = AssetGenImage('assets/success.png');
  static const $AssetsTutorialGen tutorial = $AssetsTutorialGen();
  static const AssetGenImage userPlaceholder =
      AssetGenImage('assets/user-placeholder.png');

  /// List of all assets
  List<dynamic> get values => [
        albumPlaceholder,
        emptyBox,
        placeholder,
        spotubeLogoForeground,
        spotubeLogoPng,
        spotubeLogoSvg,
        spotubeScreenshot,
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

  ImageProvider provider() => AssetImage(_assetName);

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    Clip clipBehavior = Clip.hardEdge,
    bool cacheColorFilter = false,
    SvgTheme? theme,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
      theme: theme,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
