import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:test_brik/core/utils/extension/context_ext.dart';
import 'package:test_brik/generated/locale_keys.g.dart';

class PermissionDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final VoidCallback onOk;

  const PermissionDialog({
    super.key,
    this.title,
    this.content,
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.theme.colorScheme.background,
      title: Text(
        title ?? LocaleKeys.permissionTitle.tr(),
        style: context.textTheme.titleLarge,
      ),
      content: Text(
        content ?? LocaleKeys.defaultPermissionMessage.tr(),
        style: context.textTheme.titleMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            LocaleKeys.cancel.tr(),
            style: context.textTheme.titleMedium,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onOk();
            Navigator.pop(context);
          },
          child: Text(
            LocaleKeys.next.tr(),
            style: context.textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
