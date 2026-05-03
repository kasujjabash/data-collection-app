import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';

class PharmacyApp extends StatelessWidget {
  const PharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharma Capture',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MainNavigationScreen(),
    );
  }
}
