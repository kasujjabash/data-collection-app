import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final Color? backgroundColor;
  final Color? textColor;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ??
        (isPrimary ? const Color(0xFF4ECDC4) : AppTheme.white);
    final foregroundColor =
        textColor ?? (isPrimary ? AppTheme.white : AppTheme.black);

    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: foregroundColor,
          elevation: isPrimary ? 2 : 0,
          shadowColor: isPrimary ? bgColor.withOpacity(0.3) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPrimary
                ? BorderSide.none
                : const BorderSide(color: AppTheme.grey200, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
