import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class MessageListItem extends StatelessWidget {
  final String name;
  final String message;
  final int? unreadCount;
  final String? avatarUrl;
  final VoidCallback? onTap;

  const MessageListItem({
    super.key,
    required this.name,
    required this.message,
    this.unreadCount,
    this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppTheme.white,
        border: Border(bottom: BorderSide(color: AppTheme.grey200, width: 1)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.grey200,
                borderRadius: BorderRadius.circular(24),
              ),
              child: avatarUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(avatarUrl!, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.person, color: AppTheme.grey600, size: 24),
            ),

            const SizedBox(width: 16),

            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.grey600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Unread badge
            if (unreadCount != null && unreadCount! > 0)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '$unreadCount',
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ADRListItem extends StatelessWidget {
  final String patientName;
  final String reaction;
  final String medicine;
  final String severity;
  final bool isNew;
  final VoidCallback? onTap;

  const ADRListItem({
    super.key,
    required this.patientName,
    required this.reaction,
    required this.medicine,
    required this.severity,
    this.isNew = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppTheme.white,
        border: Border(bottom: BorderSide(color: AppTheme.grey200, width: 1)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Severity icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getSeverityColor(severity).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _getSeverityIcon(severity),
                color: _getSeverityColor(severity),
                size: 20,
              ),
            ),

            const SizedBox(width: 16),

            // Patient info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patientName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$reaction • $medicine • $severity',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.grey600,
                    ),
                  ),
                ],
              ),
            ),

            // New badge
            if (isNew)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'New',
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'severe':
        return const Color(0xFFEF4444);
      case 'moderate':
        return const Color(0xFFF59E0B);
      case 'mild':
        return const Color(0xFFF59E0B);
      default:
        return AppTheme.grey400;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'severe':
        return Icons.warning;
      case 'moderate':
      case 'mild':
        return Icons.error_outline;
      default:
        return Icons.info_outline;
    }
  }
}
