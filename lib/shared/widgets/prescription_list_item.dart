import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/prescription.dart';

class PrescriptionListItem extends StatelessWidget {
  final Prescription prescription;
  final VoidCallback? onTap;

  const PrescriptionListItem({
    super.key,
    required this.prescription,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(prescription.syncStatus);
    final statusText = _getStatusText(prescription.syncStatus);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    prescription.patientName ?? 'Unknown Patient',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(prescription.createdAt),
              style: const TextStyle(fontSize: 14, color: AppTheme.grey600),
            ),
            const SizedBox(height: 4),
            Text(
              '${prescription.items.length} medicine${prescription.items.length != 1 ? 's' : ''}',
              style: const TextStyle(fontSize: 14, color: AppTheme.grey600),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'synced':
        return const Color(0xFF4ECDC4);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'failed':
        return const Color(0xFFEF4444);
      default:
        return AppTheme.grey400;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'synced':
        return 'Uploaded';
      case 'pending':
        return 'Draft';
      case 'failed':
        return 'Failed';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }
}
