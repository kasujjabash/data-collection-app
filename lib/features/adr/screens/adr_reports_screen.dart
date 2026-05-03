import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../componets/cards.dart';
import '../../../componets/list_items.dart';

class ADRReportsScreen extends StatelessWidget {
  const ADRReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey100,
      appBar: AppBar(
        title: const Text('ADR Reports'),
        backgroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stats Cards Section
            Container(
              color: AppTheme.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: const [
                  Expanded(
                    child: DashboardStatsCard(
                      icon: Icons.description,
                      value: '12',
                      label: 'Total',
                      iconColor: Color(0xFF4ECDC4),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DashboardStatsCard(
                      icon: Icons.warning,
                      value: '2',
                      label: 'Severe',
                      iconColor: Color(0xFFEF4444),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DashboardStatsCard(
                      icon: Icons.access_time,
                      value: '3',
                      label: 'Pending',
                      iconColor: Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ADR Reports List
            Container(
              color: AppTheme.white,
              child: Column(
                children: const [
                  ADRListItem(
                    patientName: 'Peter Okello',
                    reaction: 'Rash',
                    medicine: 'Amoxicillin',
                    severity: 'Severe',
                    isNew: true,
                  ),
                  ADRListItem(
                    patientName: 'Sarah Nakato',
                    reaction: 'Nausea',
                    medicine: 'Metformin',
                    severity: 'Mild',
                  ),
                  ADRListItem(
                    patientName: 'David Ssemakula',
                    reaction: 'Dizziness',
                    medicine: 'Amlodipine',
                    severity: 'Moderate',
                  ),
                  ADRListItem(
                    patientName: 'Grace Apio',
                    reaction: 'Headache',
                    medicine: 'Paracetamol',
                    severity: 'Mild',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
