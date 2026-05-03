import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../componets/list_items.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey100,
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: ListView(
        children: const [
          MessageListItem(
            name: 'Mary Namukasa',
            message: 'Can I get a refill for...',
            unreadCount: 2,
          ),
          MessageListItem(
            name: 'Peter Okello',
            message: 'Thank you for the prescription',
          ),
          MessageListItem(
            name: 'Sarah Nakato',
            message: 'What time can I pick up?',
            unreadCount: 1,
          ),
          MessageListItem(
            name: 'David Ssemakula',
            message: 'Is this medicine available?',
          ),
        ],
      ),
    );
  }
}
