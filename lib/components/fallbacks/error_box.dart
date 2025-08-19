import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/spotube_icons.dart';

class ErrorBox extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  const ErrorBox({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // Make a monospace error log view. Make sure it's only 4 lines
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              const Basic(
                leading: Icon(SpotubeIcons.error),
                contentSpacing: 8,
                title: Text("An error occurred"),
              ),
              Card(
                padding: const EdgeInsets.all(8.0),
                filled: true,
                fillColor: context.theme.colorScheme.muted,
                child: Text(
                  error.toString(),
                  style: TextStyle(
                    // Use monospace
                    fontFamily: 'Ubuntu Mono',
                    color: context.theme.colorScheme.mutedForeground,
                    fontSize: 14,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Show a dialog with full log and a retry button as well
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button.text(
                    leading: const Icon(SpotubeIcons.logs),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 480,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.8,
                            ),
                            child: AlertDialog(
                              padding: const EdgeInsets.all(12),
                              title: Row(
                                spacing: 8,
                                children: [
                                  const Icon(SpotubeIcons.logs),
                                  const Text("Logs"),
                                  const Spacer(),
                                  IconButton.ghost(
                                    icon: const Icon(SpotubeIcons.close),
                                    onPressed: () => context.maybePop(),
                                  )
                                ],
                              ),
                              actions: [
                                HookBuilder(builder: (context) {
                                  final copied = useState(false);

                                  return Button.ghost(
                                    leading: copied.value
                                        ? const Icon(SpotubeIcons.done)
                                        : const Icon(SpotubeIcons.clipboard),
                                    child: const Text("Copy to clipboard"),
                                    onPressed: () {
                                      Clipboard.setData(
                                        ClipboardData(text: error.toString()),
                                      );
                                      copied.value = true;
                                    },
                                  );
                                })
                              ],
                              content: SingleChildScrollView(
                                child: Card(
                                  padding: const EdgeInsets.all(8.0),
                                  filled: true,
                                  fillColor: context.theme.colorScheme.muted,
                                  child: SelectableText(
                                    error.toString(),
                                    style: TextStyle(
                                      // Use monospace
                                      fontFamily: 'Ubuntu Mono',
                                      color: context
                                          .theme.colorScheme.mutedForeground,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text("View logs"),
                  ),
                  if (onRetry != null)
                    Button.text(
                      leading: const Icon(SpotubeIcons.refresh),
                      onPressed: onRetry,
                      child: const Text("Retry"),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
