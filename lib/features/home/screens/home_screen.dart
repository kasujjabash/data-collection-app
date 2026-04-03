import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/prescription_repository.dart';
import '../../../shared/widgets/section_title.dart';
import '../../prescription/providers/prescription_form_provider.dart';
import '../../prescription/screens/prescription_form_screen.dart';
import '../providers/home_provider.dart';
import '../widgets/prescription_tile.dart';
import '../widgets/stats_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('Pharma Capture'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync_rounded),
            tooltip: 'Refresh',
            onPressed: () => context.read<HomeProvider>().load(),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.black),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.load,
            color: AppTheme.black,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: StatsBanner(
                      todayCount: provider.todayCount,
                      pendingSync: provider.pendingSyncCount,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                  sliver: const SliverToBoxAdapter(
                    child: SectionTitle(title: 'Recent Entries'),
                  ),
                ),
                if (provider.prescriptions.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(),
                  )
                else
                  SliverList.separated(
                    itemCount: provider.prescriptions.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 20, endIndent: 20),
                    itemBuilder: (context, i) {
                      final p = provider.prescriptions[i];
                      return PrescriptionTile(
                        prescription: p,
                        onDelete: () => _confirmDelete(context, provider, p.id),
                      );
                    },
                  ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        backgroundColor: AppTheme.black,
        foregroundColor: AppTheme.white,
        elevation: 2,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'New Prescription',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _openForm(BuildContext context) {
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
      if (context.mounted) context.read<HomeProvider>().load();
    });
  }

  void _confirmDelete(
    BuildContext context,
    HomeProvider provider,
    String id,
  ) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete entry?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.delete(id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 56,
            color: AppTheme.grey200,
          ),
          const SizedBox(height: 16),
          const Text(
            'No prescriptions yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.grey600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap + New Prescription to get started',
            style: TextStyle(fontSize: 13, color: AppTheme.grey400),
          ),
        ],
      ),
    );
  }
}
