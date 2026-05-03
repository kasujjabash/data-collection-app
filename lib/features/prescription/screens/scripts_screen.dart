import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/prescription_search_bar.dart';
import '../../../componets/cards.dart';
import '../../../shared/widgets/quick_action_button.dart';
import '../../../shared/widgets/prescription_list_item.dart';
import '../../../data/repositories/prescription_repository.dart';
import '../../home/providers/home_provider.dart';
import '../providers/prescription_form_provider.dart';
import '../screens/prescription_form_screen.dart';

class ScriptsScreen extends StatefulWidget {
  const ScriptsScreen({super.key});

  @override
  State<ScriptsScreen> createState() => _ScriptsScreenState();
}

class _ScriptsScreenState extends State<ScriptsScreen> {
  String _searchQuery = '';

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
      appBar: AppBar(
        title: const Text('Prescriptions'),
        backgroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF4ECDC4)),
            );
          }

          final uploadedCount = provider.prescriptions
              .where((p) => p.syncStatus == 'synced')
              .length;
          final draftsCount = provider.pendingSyncCount;

          // Filter prescriptions based on search query
          final filteredPrescriptions = provider.prescriptions
              .where(
                (p) =>
                    _searchQuery.isEmpty ||
                    (p.patientName?.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ??
                        false),
              )
              .toList();

          return RefreshIndicator(
            onRefresh: provider.load,
            color: const Color(0xFF4ECDC4),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  PrescriptionSearchBar(
                    hintText: 'Search patient...',
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    onFilterPressed: () {
                      // TODO: Implement filter functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Filter functionality coming soon!'),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Stats Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatsCard(
                          icon: Icons.check_circle,
                          value: '$uploadedCount',
                          label: 'Uploaded',
                          iconColor: const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DashboardStatsCard(
                          icon: Icons.edit_document,
                          value: '$draftsCount',
                          label: 'Drafts',
                          iconColor: const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
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

                  const SizedBox(height: 24),

                  // Recent Section
                  const Text(
                    'Recent',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Prescriptions List
                  if (filteredPrescriptions.isEmpty)
                    _buildEmptyState()
                  else
                    ...filteredPrescriptions.map(
                      (prescription) => PrescriptionListItem(
                        prescription: prescription,
                        onTap: () =>
                            _viewPrescriptionDetails(context, prescription.id),
                      ),
                    ),

                  const SizedBox(height: 100), // Bottom padding for nav bar
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            _searchQuery.isNotEmpty
                ? Icons.search_off
                : Icons.description_outlined,
            size: 64,
            color: AppTheme.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'No results found'
                : 'No prescriptions yet',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search terms'
                : 'Start by adding your first prescription',
            style: const TextStyle(fontSize: 14, color: AppTheme.grey400),
            textAlign: TextAlign.center,
          ),
        ],
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

  void _viewPrescriptionDetails(BuildContext context, String prescriptionId) {
    // TODO: Navigate to prescription details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View prescription details: $prescriptionId')),
    );
  }
}
