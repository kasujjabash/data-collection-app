import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class LabeledDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;
  final bool optional;

  const LabeledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label: label, optional: optional),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: const InputDecoration(),
          hint: const Text('Select', style: TextStyle(fontSize: 14)),
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.black,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: AppTheme.grey600,
          ),
          items: items
              .map(
                (item) => DropdownMenuItem(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: onChanged,
          validator: optional ? null : (v) => v == null ? 'Required' : null,
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool optional;

  const _FieldLabel({required this.label, required this.optional});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        if (optional) ...[
          const SizedBox(width: 4),
          const Text(
            '(optional)',
            style: TextStyle(fontSize: 12, color: AppTheme.grey400),
          ),
        ],
      ],
    );
  }
}
