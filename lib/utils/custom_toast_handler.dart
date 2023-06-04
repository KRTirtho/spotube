import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';

class CustomToastHandler extends ReportHandler {
  CustomToastHandler();

  @override
  Future<bool> handle(Report error, BuildContext? context) async {
    final theme = Theme.of(context!);

    MotionToast(
      primaryColor: theme.colorScheme.errorContainer,
      icon: SpotubeIcons.error,
      title: Text(
        context.l10n.something_went_wrong,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onError,
        ),
      ),
      description: Text(
        error.error.toString(),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onError,
        ),
      ),
      dismissable: true,
      toastDuration: const Duration(seconds: 10),
      borderRadius: 10,
    ).show(context);
    return true;
  }

  @override
  List<PlatformType> getSupportedPlatforms() => [
        PlatformType.android,
        PlatformType.iOS,
        PlatformType.web,
        PlatformType.linux,
        PlatformType.macOS,
        PlatformType.windows,
      ];

  @override
  bool isContextRequired() {
    return true;
  }

  @override
  bool shouldHandleWhenRejected() {
    return false;
  }
}
