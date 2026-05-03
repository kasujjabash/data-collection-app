import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PrescriptionSearchBar extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;
  final VoidCallback? onFilterPressed;

  const PrescriptionSearchBar({
    super.key,
    this.hintText = 'Search patient...',
    this.onChanged,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.grey100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: AppTheme.grey400,
                  fontSize: 16,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppTheme.grey400,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
        if (onFilterPressed != null) ...[
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.grey100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: onFilterPressed,
              icon: const Icon(Icons.tune, color: AppTheme.grey600, size: 20),
            ),
          ),
        ],
      ],
    );
  }
}
