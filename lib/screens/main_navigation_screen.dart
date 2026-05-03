import 'package:flutter/material.dart';
import '../features/home/screens/dashboard_home_screen.dart';
import '../features/prescription/screens/scripts_screen.dart';
import '../features/messaging/screens/messages_screen.dart';
import '../features/adr/screens/adr_reports_screen.dart';
import '../shared/widgets/custom_bottom_navigation.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardHomeScreen(),
    const ScriptsScreen(),
    const MessagesScreen(),
    const ADRReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
