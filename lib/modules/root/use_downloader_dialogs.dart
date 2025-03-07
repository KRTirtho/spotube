import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/dialogs/replace_downloaded_dialog.dart';
import 'package:spotube/provider/download_manager_provider.dart';

void useDownloaderDialogs(WidgetRef ref) {
  final context = useContext();
  final showingDialogCompleter = useRef(Completer()..complete());
  final downloader = ref.watch(downloadManagerProvider);

  useEffect(() {
    downloader.onFileExists = (track) async {
      if (!context.mounted) return false;

      if (!showingDialogCompleter.value.isCompleted) {
        await showingDialogCompleter.value.future;
      }

      final replaceAll = ref.read(replaceDownloadedFileState);

      if (replaceAll != null) return replaceAll;

      showingDialogCompleter.value = Completer();

      if (context.mounted) {
        final result = await showDialog<bool>(
              context: context,
              builder: (context) => ReplaceDownloadedDialog(
                track: track,
              ),
            ) ??
            false;

        showingDialogCompleter.value.complete();
        return result;
      }

      // it'll never reach here as root_app is always mounted
      return false;
    };
    return null;
  }, [downloader]);
}
