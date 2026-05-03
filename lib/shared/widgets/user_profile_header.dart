import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class UserProfileHeader extends StatelessWidget {
  final String name;
  final String title;
  final String location;
  final String? avatarUrl;

  const UserProfileHeader({
    super.key,
    required this.name,
    required this.title,
    required this.location,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.grey600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: const TextStyle(fontSize: 16, color: AppTheme.grey600),
                ),
              ],
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF4ECDC4).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: avatarUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(avatarUrl!, fit: BoxFit.cover),
                  )
                : const Icon(Icons.person, size: 32, color: Color(0xFF4ECDC4)),
          ),
        ],
      ),
    );
  }
}
