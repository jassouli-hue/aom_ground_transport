import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/known_location_model.dart';
import '../../providers/known_location_provider.dart';
import '../../providers/database_provider.dart';
import '../shared/widgets/aom_app_bar.dart';

class LocationsScreen extends ConsumerWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locAsync = ref.watch(locationsStreamProvider);

    return Scaffold(
      appBar: const AomAppBar(title: 'Destinations / Points connus'),
      body: locAsync.when(
        data: (locations) {
          if (locations.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.place_outlined, size: 48, color: AppColors.textSecondary),
                  SizedBox(height: 12),
                  Text('Aucune destination enregistrée',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            );
          }

          final airports = locations.where((l) => l.isAirport).toList();
          final others = locations.where((l) => !l.isAirport).toList();

          return ListView(
            children: [
              if (airports.isNotEmpty) ...[
                _SectionHeader(label: 'Aéroports (${airports.length})'),
                ...airports.map((l) => _LocationTile(loc: l, ref: ref)),
              ],
              if (others.isNotEmpty) ...[
                _SectionHeader(label: 'Autres points (${others.length})'),
                ...others.map((l) => _LocationTile(loc: l, ref: ref)),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/locations/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final KnownLocationModel loc;
  final WidgetRef ref;
  const _LocationTile({required this.loc, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: loc.isAirport
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.accent.withOpacity(0.1),
          child: Icon(
            loc.isAirport ? Icons.flight : Icons.place,
            color: loc.isAirport ? AppColors.primary : AppColors.accent,
            size: 20,
          ),
        ),
        title: Text(loc.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        subtitle: Text(
            '${loc.shortCode} • ${loc.city}\n${loc.latitude.toStringAsFixed(4)}, ${loc.longitude.toStringAsFixed(4)}'),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              color: AppColors.primary,
              onPressed: () => context.push('/locations/${loc.id}/edit'),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: AppColors.error,
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer destination'),
        content: Text('Supprimer ${loc.name} ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              ref.read(knownLocationRepositoryProvider).delete(loc.id);
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
