import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class StatsBanner extends StatelessWidget {
  final int todayCount;
  final int pendingSync;

  const StatsBanner({
    super.key,
    required this.todayCount,
    required this.pendingSync,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: AppTheme.grey100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Stat(
              value: '$todayCount',
              label: 'Today',
            ),
          ),
          Container(width: 1, height: 40, color: AppTheme.grey200),
          Expanded(
            child: _Stat(
              value: '$pendingSync',
              label: 'Pending Sync',
              highlight: pendingSync > 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  final bool highlight;

  const _Stat({required this.value, required this.label, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: highlight ? const Color(0xFFF57F17) : AppTheme.black,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.grey600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
