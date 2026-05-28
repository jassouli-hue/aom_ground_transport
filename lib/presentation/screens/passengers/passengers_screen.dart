import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/passenger_provider.dart';
import '../../providers/database_provider.dart';
import '../shared/widgets/aom_app_bar.dart';

class PassengersScreen extends ConsumerWidget {
  const PassengersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passAsync = ref.watch(passengersStreamProvider);

    return Scaffold(
      appBar: const AomAppBar(title: 'Passagers / Équipage'),
      body: passAsync.when(
        data: (passengers) {
          if (passengers.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 48, color: AppColors.textSecondary),
                  SizedBox(height: 12),
                  Text('Aucun passager enregistré',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: passengers.length,
            itemBuilder: (context, i) {
              final p = passengers[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.accent.withOpacity(0.12),
                    child: Text(
                      p.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          color: AppColors.accent, fontWeight: FontWeight.w700),
                    ),
                  ),
                  title: Text(p.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${p.role} • ${p.baseCity} • ${p.phone}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        color: AppColors.primary,
                        onPressed: () => context.push('/passengers/${p.id}/edit'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        color: AppColors.error,
                        onPressed: () => _confirmDelete(context, ref, p.id, p.name),
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
        onPressed: () => context.push('/passengers/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int id, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer passager'),
        content: Text('Supprimer $name ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              ref.read(passengerRepositoryProvider).delete(id);
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
