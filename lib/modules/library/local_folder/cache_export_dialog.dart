import 'dart:io';

import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:spotube/extensions/context.dart';
import 'package:spotube/services/logger/logger.dart';

const containers = ["m4a", "mp3", "mp4", "ogg", "wav", "flac"];

class LocalFolderCacheExportDialog extends HookConsumerWidget {
  final Directory exportDir;
  final Directory cacheDir;
  const LocalFolderCacheExportDialog({
    super.key,
    required this.exportDir,
    required this.cacheDir,
  });

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:typography, :colorScheme) = Theme.of(context);

    final files = useState<List<File>>([]);
    final filesExported = useState<int>(0);

    useEffect(() {
      final stream = cacheDir.list().where(
            (event) =>
                event is File &&
                containers
                    .contains(path.extension(event.path).replaceAll(".", "")),
          );

      stream.listen(
        (event) {
          files.value = [...files.value, event as File];
        },
        onError: (e, stack) {
          AppLogger.reportError(e, stack);
        },
      );
      return null;
    }, []);

    useEffect(() {
      if (filesExported.value == files.value.length &&
          filesExported.value > 0) {
        Navigator.of(context).pop();
      }
      return null;
    }, [filesExported.value, files.value]);

    final isExportInProgress =
        filesExported.value > 0 && filesExported.value != files.value.length;

    return AlertDialog(
      title: Text(context.l10n.export_cache_files),
      content: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: filesExported.value == 0
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.found_n_files(files.value.length.toString()),
                  ),
                  const Gap(10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: context.l10n.export_cache_confirmation,
                        ),
                        TextSpan(
                          text: "\n${exportDir.path}?",
                          style: typography.small.copyWith(
                            color: colorScheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.exported_n_out_of_m_files(
                      files.value.length.toString(),
                      filesExported.value.toString(),
                    ),
                  ),
                  const Gap(10),
                  LinearProgressIndicator(
                    value: filesExported.value / files.value.length,
                  ),
                ],
              ),
      ),
      actions: [
        Button.outline(
          onPressed: isExportInProgress
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          child: Text(context.l10n.cancel),
        ),
        Button.primary(
          onPressed: isExportInProgress
              ? null
              : () async {
                  for (final file in files.value) {
                    try {
                      final destinationFile = File(
                        path.join(exportDir.path, path.basename(file.path)),
                      );

                      if (await destinationFile.exists()) {
                        await destinationFile.delete();
                      }
                      await file.copy(destinationFile.path);
                      filesExported.value++;
                    } catch (e, stack) {
                      AppLogger.reportError(e, stack);
                      continue;
                    }
                  }
                },
          child: Text(context.l10n.export),
        ),
      ],
    );
  }
}
