import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/driver_provider.dart';
import '../../providers/database_provider.dart';
import '../shared/widgets/aom_app_bar.dart';

class DriversScreen extends ConsumerWidget {
  const DriversScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driversAsync = ref.watch(driversStreamProvider);

    return Scaffold(
      appBar: const AomAppBar(title: 'Chauffeurs'),
      body: driversAsync.when(
        data: (drivers) {
          if (drivers.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.drive_eta_outlined, size: 48, color: AppColors.textSecondary),
                  SizedBox(height: 12),
                  Text('Aucun chauffeur enregistré',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: drivers.length,
            itemBuilder: (context, i) {
              final d = drivers[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      d.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          color: AppColors.primary, fontWeight: FontWeight.w700),
                    ),
                  ),
                  title: Text(d.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(d.phone),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        color: AppColors.primary,
                        onPressed: () => context.push('/drivers/${d.id}/edit'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        color: AppColors.error,
                        onPressed: () => _confirmDelete(context, ref, d.id, d.name),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/drivers/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int id, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer chauffeur'),
        content: Text('Supprimer $name ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              ref.read(driverRepositoryProvider).delete(id);
              Navigator.pop(context);
            },
            child: const Text('Supprimer',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
