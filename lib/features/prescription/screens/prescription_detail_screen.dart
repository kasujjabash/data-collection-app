import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/prescription.dart';
import '../../../data/models/prescription_item.dart';
import '../../../shared/widgets/section_title.dart';

class PrescriptionDetailScreen extends StatelessWidget {
  final Prescription prescription;

  const PrescriptionDetailScreen({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Prescription'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _SyncBadge(status: prescription.syncStatus),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _MetaCard(prescription: prescription),
          const SizedBox(height: 28),
          const SectionTitle(title: 'Drugs Prescribed'),
          const SizedBox(height: 12),
          ...prescription.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _DrugCard(item: item),
            ),
          ),
          if (prescription.diagnosis != null) ...[
            const SizedBox(height: 28),
            const SectionTitle(title: 'Diagnosis'),
            const SizedBox(height: 12),
            _InfoBox(text: prescription.diagnosis!),
          ],
          if (prescription.imagePath != null) ...[
            const SizedBox(height: 28),
            const SectionTitle(title: 'Prescription Image'),
            const SizedBox(height: 12),
            _ImagePreview(path: prescription.imagePath!),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Meta card — patient info + date
// ---------------------------------------------------------------------------

class _MetaCard extends StatelessWidget {
  final Prescription prescription;

  const _MetaCard({required this.prescription});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM yyyy, HH:mm').format(prescription.createdAt);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.grey100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _Row(
            label: 'Patient',
            value: prescription.patientName?.isNotEmpty == true
                ? prescription.patientName!
                : 'Anonymous',
          ),
          if (prescription.patientAge != null) ...[
            const _Divider(),
            _Row(label: 'Age', value: '${prescription.patientAge} years'),
          ],
          if (prescription.patientGender != null) ...[
            const _Divider(),
            _Row(
              label: 'Gender',
              value: prescription.patientGender == 'M' ? 'Male' : 'Female',
            ),
          ],
          const _Divider(),
          _Row(label: 'Captured', value: date),
          const _Divider(),
          _Row(
            label: 'Drugs',
            value: '${prescription.items.length} item${prescription.items.length == 1 ? '' : 's'}',
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppTheme.grey600),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppTheme.grey200);
  }
}

// ---------------------------------------------------------------------------
// Drug card
// ---------------------------------------------------------------------------

class _DrugCard extends StatelessWidget {
  final PrescriptionItem item;

  const _DrugCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drug name + form
          Row(
            children: [
              Expanded(
                child: Text(
                  item.drug,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _Pill(label: item.form),
            ],
          ),
          const SizedBox(height: 10),
          // Details row
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _DetailChip(icon: Icons.scale_outlined, label: item.strength),
              _DetailChip(icon: Icons.numbers_rounded, label: 'Qty: ${item.quantity}'),
              _DetailChip(icon: Icons.repeat_rounded, label: item.frequency),
              _DetailChip(icon: Icons.calendar_today_outlined, label: item.duration),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;

  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.grey100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppTheme.grey600,
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppTheme.grey400),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.grey600),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Diagnosis info box
// ---------------------------------------------------------------------------

class _InfoBox extends StatelessWidget {
  final String text;

  const _InfoBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, height: 1.5),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Image preview
// ---------------------------------------------------------------------------

class _ImagePreview extends StatelessWidget {
  final String path;

  const _ImagePreview({required this.path});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 120,
          decoration: BoxDecoration(
            color: AppTheme.grey100,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Image not available',
            style: TextStyle(color: AppTheme.grey400, fontSize: 13),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sync badge in app bar
// ---------------------------------------------------------------------------

class _SyncBadge extends StatelessWidget {
  final String status;

  const _SyncBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isPending = status == 'pending';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPending ? const Color(0xFFFFF9C4) : AppTheme.grey100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPending ? 'Pending Sync' : 'Synced',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isPending ? const Color(0xFFF57F17) : AppTheme.grey600,
        ),
      ),
    );
  }
}
