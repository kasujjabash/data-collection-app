import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/dictionaries/drug_dictionary.dart';
import '../providers/prescription_form_provider.dart';
import 'labeled_dropdown.dart';
import '../../../shared/widgets/app_text_field.dart';

/// A card representing a single drug entry in the prescription form.
/// StatefulWidget to own the quantity TextEditingController lifecycle.
class DrugItemCard extends StatefulWidget {
  final int index;
  final DrugFormData data;
  final bool showRemove;
  final void Function(DrugFormData updated) onUpdate;
  final VoidCallback onRemove;

  const DrugItemCard({
    super.key,
    required this.index,
    required this.data,
    required this.showRemove,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  State<DrugItemCard> createState() => _DrugItemCardState();
}

class _DrugItemCardState extends State<DrugItemCard> {
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.data.quantity ?? '',
    );
  }

  @override
  void didUpdateWidget(DrugItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller if quantity was cleared externally (e.g. remove + re-add)
    if (widget.data.quantity != oldWidget.data.quantity &&
        widget.data.quantity != _quantityController.text) {
      _quantityController.text = widget.data.quantity ?? '';
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _update({
    String? drug,
    String? strength,
    String? form,
    String? quantity,
    String? frequency,
    String? duration,
  }) {
    widget.onUpdate(
      widget.data.copyWith(
        drug: drug,
        strength: strength,
        form: form,
        quantity: quantity,
        frequency: frequency,
        duration: duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            index: widget.index,
            showRemove: widget.showRemove,
            onRemove: widget.onRemove,
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LabeledDropdown(
                  label: 'Drug',
                  value: widget.data.drug,
                  items: DrugDictionary.drugs,
                  onChanged: (v) => _update(drug: v),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: LabeledDropdown(
                        label: 'Strength',
                        value: widget.data.strength,
                        items: DrugDictionary.strengths,
                        onChanged: (v) => _update(strength: v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: LabeledDropdown(
                        label: 'Form',
                        value: widget.data.form,
                        items: DrugDictionary.forms,
                        onChanged: (v) => _update(form: v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: LabeledDropdown(
                        label: 'Frequency',
                        value: widget.data.frequency,
                        items: DrugDictionary.frequencies,
                        onChanged: (v) => _update(frequency: v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: AppTextField(
                        label: 'Qty',
                        hint: '0',
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (v) => _update(quantity: v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LabeledDropdown(
                  label: 'Duration',
                  value: widget.data.duration,
                  items: DrugDictionary.durations,
                  onChanged: (v) => _update(duration: v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final int index;
  final bool showRemove;
  final VoidCallback onRemove;

  const _CardHeader({
    required this.index,
    required this.showRemove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
      child: Row(
        children: [
          Text(
            'Drug ${index + 1}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 0.2,
            ),
          ),
          const Spacer(),
          if (showRemove)
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded, size: 18),
              color: AppTheme.grey600,
              visualDensity: VisualDensity.compact,
              tooltip: 'Remove drug',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
