import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_title.dart';
import '../providers/prescription_form_provider.dart';
import '../widgets/drug_item_card.dart';

class PrescriptionFormScreen extends StatelessWidget {
  const PrescriptionFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('New Prescription'),
      ),
      body: Consumer<PrescriptionFormProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(title: 'Patient Info'),
                      const SizedBox(height: 12),
                      _PatientSection(provider: provider),
                      const SizedBox(height: 28),
                      const SectionTitle(title: 'Prescription Image'),
                      const SizedBox(height: 12),
                      _ImageCapture(provider: provider),
                      const SizedBox(height: 28),
                      SectionTitle(
                        title: 'Drugs',
                        trailing: TextButton.icon(
                          onPressed: provider.addDrug,
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text(
                            'Add Drug',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(provider.drugs.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DrugItemCard(
                            key: ValueKey(i),
                            index: i,
                            data: provider.drugs[i],
                            showRemove: provider.drugs.length > 1,
                            onUpdate: (d) => provider.updateDrug(i, d),
                            onRemove: () => provider.removeDrug(i),
                          ),
                        );
                      }),
                      const SizedBox(height: 28),
                      const SectionTitle(title: 'Additional Info'),
                      const SizedBox(height: 12),
                      AppTextField(
                        label: 'Diagnosis',
                        hint: 'e.g. Malaria, UTI, Pneumonia…',
                        optional: true,
                        maxLines: 2,
                        onChanged: provider.setDiagnosis,
                      ),
                      if (provider.error != null) ...[
                        const SizedBox(height: 16),
                        _ErrorBanner(message: provider.error!),
                      ],
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              _SaveBar(provider: provider),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Patient section
// ---------------------------------------------------------------------------

class _PatientSection extends StatelessWidget {
  final PrescriptionFormProvider provider;

  const _PatientSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          label: 'Patient Name',
          hint: 'Full name',
          optional: true,
          onChanged: provider.setPatientName,
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextField(
                label: 'Age',
                hint: '25',
                optional: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: provider.setPatientAge,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GenderSelector(
                value: provider.patientGender,
                onChanged: provider.setPatientGender,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String? value;
  final void Function(String?) onChanged;

  const _GenderSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '(optional)',
              style: TextStyle(fontSize: 12, color: AppTheme.grey400),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _GenderChip(
                label: 'Male',
                selected: value == 'M',
                onTap: () => onChanged(value == 'M' ? null : 'M'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _GenderChip(
                label: 'Female',
                selected: value == 'F',
                onTap: () => onChanged(value == 'F' ? null : 'F'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenderChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 48,
        decoration: BoxDecoration(
          color: selected ? AppTheme.black : AppTheme.grey100,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? AppTheme.white : AppTheme.grey600,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Image capture
// ---------------------------------------------------------------------------

class _ImageCapture extends StatelessWidget {
  final PrescriptionFormProvider provider;
  static final _picker = ImagePicker();

  const _ImageCapture({required this.provider});

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (file != null && context.mounted) {
      context.read<PrescriptionFormProvider>().setImagePath(file.path);
    }
  }

  void _showSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pick(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pick(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final captured = provider.imagePath != null;

    return GestureDetector(
      onTap: () => _showSheet(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 88,
        decoration: BoxDecoration(
          color: AppTheme.grey100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: captured ? AppTheme.black : AppTheme.grey200,
            width: captured ? 1.5 : 1,
          ),
        ),
        child: captured
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline_rounded, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Image captured',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => provider.setImagePath(null),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppTheme.grey600,
                    ),
                  ),
                ],
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 26,
                    color: AppTheme.grey400,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Capture or upload prescription',
                    style: TextStyle(fontSize: 13, color: AppTheme.grey600),
                  ),
                ],
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom save bar
// ---------------------------------------------------------------------------

class _SaveBar extends StatelessWidget {
  final PrescriptionFormProvider provider;

  const _SaveBar({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.white,
        border: Border(top: BorderSide(color: AppTheme.grey200)),
      ),
      child: PrimaryButton(
        label: 'Save Prescription',
        isLoading: provider.isSaving,
        onPressed: () async {
          final saved = await provider.save();
          if (saved && context.mounted) Navigator.pop(context);
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error banner
// ---------------------------------------------------------------------------

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, size: 16, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
