import 'package:flutter/material.dart';
import 'package:test_brik/core/utils/extension/context_ext.dart';
import 'package:test_brik/core/utils/themes/color.dart';

import '../utils/debouncer.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    this.onTap,
    this.readOnly = false,
    required this.initialValue,
    required this.hintText,
    required this.onChanged,
    this.focusNode,
  });

  final bool readOnly;
  final String initialValue;
  final String hintText;
  final void Function(String) onChanged;
  final void Function()? onTap;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(milliseconds: 1000);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: secondaryColor.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: primaryColor.shade50,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              onTap: onTap,
              focusNode: focusNode,
              initialValue: initialValue,
              onTapOutside: (_) => context.dismissKeyboard(),
              onChanged: (val) {
                debouncer.run(() => onChanged(val));
              },
              readOnly: readOnly,
              onFieldSubmitted: (_) => context.dismissKeyboard(),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: primaryColor.shade50,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
