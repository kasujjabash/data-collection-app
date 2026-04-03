import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/prescription.dart';
import '../../prescription/screens/prescription_detail_screen.dart';

class PrescriptionTile extends StatelessWidget {
  final Prescription prescription;
  final VoidCallback? onDelete;

  const PrescriptionTile({
    super.key,
    required this.prescription,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final firstDrug =
        prescription.items.isNotEmpty ? prescription.items.first.drug : '—';
    final extraCount = prescription.items.length - 1;
    final drugSummary =
        extraCount > 0 ? '$firstDrug  +$extraCount more' : firstDrug;
    final isPending = prescription.syncStatus == 'pending';

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PrescriptionDetailScreen(prescription: prescription),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            _DateBadge(date: prescription.createdAt),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _patientLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    drugSummary,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.grey600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (isPending) const _PendingChip(),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDelete,
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: AppTheme.grey400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _patientLabel {
    final name = prescription.patientName;
    final age = prescription.patientAge;
    final gender = prescription.patientGender;

    if (name != null && name.isNotEmpty) return name;

    final parts = <String>[];
    if (age != null) parts.add('${age}y');
    if (gender != null) parts.add(gender == 'M' ? 'Male' : 'Female');
    return parts.isEmpty ? 'Anonymous' : parts.join(', ');
  }
}

class _DateBadge extends StatelessWidget {
  final DateTime date;

  const _DateBadge({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.grey100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('d').format(date),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          Text(
            DateFormat('MMM').format(date).toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppTheme.grey600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingChip extends StatelessWidget {
  const _PendingChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Pending',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF57F17),
        ),
      ),
    );
  }
}
