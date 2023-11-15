import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:test_brik/core/components/spacer.dart';
import 'package:test_brik/core/utils/themes/color.dart';
import 'package:test_brik/generated/locale_keys.g.dart';

class ErrorScreen extends StatelessWidget {
  final String? message;
  final void Function()? onRefresh;

  const ErrorScreen({
    super.key,
    required this.message,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message ?? LocaleKeys.defaultErrorMessage.tr(),
            textAlign: TextAlign.center,
          ),
          // icon Refresh
          if (onRefresh != null) ...[
            const VSpacer(),
            IconButton(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              color: defaultColor.shade50,
            ),
          ]
        ],
      ),
    );
  }
}
