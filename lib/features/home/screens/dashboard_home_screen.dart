import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/user_profile_header.dart';
import '../../../componets/cards.dart';
import '../../../shared/widgets/quick_action_button.dart';
import '../../../data/repositories/prescription_repository.dart';
import '../../prescription/providers/prescription_form_provider.dart';
import '../../prescription/screens/prescription_form_screen.dart';
import '../providers/home_provider.dart';

class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({super.key});

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey100,
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF4ECDC4)),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Header
                  Container(
                    color: AppTheme.white,
                    child: const UserProfileHeader(
                      name: 'Dr. Joseph Mukasa',
                      title: 'Senior Pharmacist',
                      location: 'Kampala Central Pharmacy',
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Dashboard Overview Title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Dashboard Overview',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Stats Cards Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.95,
                      children: [
                        DashboardStatsCard(
                          icon: Icons.description,
                          value: '${provider.prescriptions.length}',
                          label: 'Total Scripts',
                          iconColor: const Color(0xFF4ECDC4),
                        ),
                        DashboardStatsCard(
                          icon: Icons.schedule,
                          value: '${provider.todayCount}',
                          label: 'This Week',
                          iconColor: const Color(0xFF4ECDC4),
                        ),
                        DashboardStatsCard(
                          icon: Icons.edit_document,
                          value: '${provider.pendingSyncCount}',
                          label: 'Drafts',
                          iconColor: const Color(0xFFF59E0B),
                        ),
                        DashboardStatsCard(
                          icon: Icons.check_circle,
                          value:
                              '${provider.prescriptions.where((p) => p.syncStatus == 'synced').length}',
                          label: 'Uploaded',
                          iconColor: const Color(0xFF10B981),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Quick Actions Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        QuickActionButton(
                          icon: Icons.upload,
                          label: 'Upload Prescription',
                          isPrimary: true,
                          onPressed: () => _openPrescriptionForm(context),
                        ),
                        QuickActionButton(
                          icon: Icons.edit,
                          label: 'Enter Prescription',
                          onPressed: () => _openPrescriptionForm(context),
                        ),
                        QuickActionButton(
                          icon: Icons.view_list,
                          label: 'View All Prescriptions',
                          onPressed: () {
                            // This will be handled by the bottom navigation
                            // Switch to scripts tab
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _openPrescriptionForm(BuildContext context) {
    final repo = context.read<PrescriptionRepository>();
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => PrescriptionFormProvider(repo),
          child: const PrescriptionFormScreen(),
        ),
      ),
    ).then((_) {
      if (context.mounted) {
        context.read<HomeProvider>().load();
      }
    });
  }
}
