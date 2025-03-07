import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocale on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
