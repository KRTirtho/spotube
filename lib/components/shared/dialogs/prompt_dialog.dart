import 'package:flutter/material.dart';

Future<bool> showPromptDialog({
  required BuildContext context,
  required String title,
  required String message,
  String okText = "Ok",
  String cancelText = "Cancel",
}) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          FilledButton(
            child: Text(okText),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
