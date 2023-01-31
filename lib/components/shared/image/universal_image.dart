import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/collections/assets.gen.dart';

class UniversalImage extends HookWidget {
  final String path;
  final double? height;
  final double? width;
  final double scale;
  final PlaceholderWidgetBuilder? placeholder;
  const UniversalImage({
    required this.path,
    this.height,
    this.width,
    this.placeholder,
    this.scale = 1,
    Key? key,
  }) : super(key: key);

  static ImageProvider imageProvider(
    String path, {
    final double? height,
    final double? width,
    final double scale = 1,
  }) {
    if (path.startsWith("http")) {
      return CachedNetworkImageProvider(
        path,
        maxHeight: height?.toInt(),
        maxWidth: width?.toInt(),
        cacheKey: path,
        scale: scale,
      );
    } else if (Uri.tryParse(path) != null) {
      return FileImage(File(path), scale: scale);
    }
    return MemoryImage(base64Decode(path), scale: scale);
  }

  @override
  Widget build(BuildContext context) {
    if (path.startsWith("http")) {
      return CachedNetworkImage(
        imageUrl: path,
        height: height,
        width: width,
        maxWidthDiskCache: width?.toInt(),
        maxHeightDiskCache: height?.toInt(),
        memCacheHeight: height?.toInt(),
        memCacheWidth: width?.toInt(),
        placeholder: placeholder,
        cacheKey: path,
      );
    } else if (Uri.tryParse(path) != null && !path.startsWith("assets")) {
      return Image.file(
        File(path),
        width: width,
        height: height,
        cacheHeight: height?.toInt(),
        cacheWidth: width?.toInt(),
        scale: scale,
        errorBuilder: (context, error, stackTrace) {
          return placeholder?.call(context, error.toString()) ??
              Assets.placeholder.image(
                width: width,
                height: height,
                cacheHeight: height?.toInt(),
                cacheWidth: width?.toInt(),
                scale: scale,
              );
        },
      );
    } else if (path.startsWith("assets")) {
      return Image.asset(
        path,
        width: width,
        height: height,
        cacheHeight: height?.toInt(),
        cacheWidth: width?.toInt(),
        scale: scale,
        errorBuilder: (context, error, stackTrace) {
          return placeholder?.call(context, error.toString()) ??
              Assets.placeholder.image(
                width: width,
                height: height,
                cacheHeight: height?.toInt(),
                cacheWidth: width?.toInt(),
                scale: scale,
              );
        },
      );
    }

    return Image.memory(
      base64Decode(path),
      width: width,
      height: height,
      cacheHeight: height?.toInt(),
      cacheWidth: width?.toInt(),
      scale: scale,
      errorBuilder: (context, error, stackTrace) {
        return placeholder?.call(context, error.toString()) ??
            Assets.placeholder.image(
              width: width,
              height: height,
              cacheHeight: height?.toInt(),
              cacheWidth: width?.toInt(),
              scale: scale,
            );
      },
    );
  }
}
