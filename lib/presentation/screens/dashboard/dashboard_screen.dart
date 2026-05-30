import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/mission_model.dart';
import '../../providers/mission_provider.dart';
import '../../providers/driver_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../providers/passenger_provider.dart';
import '../../providers/settings_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyAsync = ref.watch(companyNameProvider);
    final countsAsync = ref.watch(missionCountsProvider);
    final missionsAsync = ref.watch(missionsStreamProvider);
    final driversAsync = ref.watch(driversStreamProvider);
    final vehiclesAsync = ref.watch(vehiclesStreamProvider);
    final passengersAsync = ref.watch(passengersStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            Image.asset('assets/images/aom_logo.png', height: 34),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ground Transport',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                companyAsync.when(
                  data: (name) => Text(name,
                      style: const TextStyle(fontSize: 11, color: Colors.white70)),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            tooltip: 'Rapport PDF',
            onPressed: () => context.push('/reports'),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(missionCountsProvider);
          ref.invalidate(missionsStreamProvider);
        },
        child: ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: [
            // Stat cards
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Tableau de bord',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            countsAsync.when(
              data: (counts) => _StatRow(counts: counts),
              loading: () => const _StatRowSkeleton(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),

            // Quick nav
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('Navigation rapide',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            _QuickNavGrid(
              items: [
                _NavItem('Missions', Icons.assignment, '/missions', AppColors.primary),
                _NavItem('Chauffeurs', Icons.drive_eta, '/drivers', AppColors.primaryLight),
                _NavItem('Véhicules', Icons.directions_car, '/vehicles', AppColors.primaryLight),
                _NavItem('Passagers', Icons.people, '/passengers', AppColors.primaryLight),
                _NavItem('Destinations', Icons.place, '/locations', AppColors.primaryLight),
                _NavItem('Paramètres', Icons.settings, '/settings', AppColors.textSecondary),
              ],
            ),

            // Resources summary
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Ressources',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _ResourceCard(
                      label: 'Chauffeurs',
                      icon: Icons.drive_eta,
                      countAsync: driversAsync.when(
                        data: (d) => d.length,
                        loading: () => null,
                        error: (_, __) => 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ResourceCard(
                      label: 'Véhicules',
                      icon: Icons.directions_car,
                      countAsync: vehiclesAsync.when(
                        data: (v) => v.length,
                        loading: () => null,
                        error: (_, __) => 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ResourceCard(
                      label: 'Passagers',
                      icon: Icons.people,
                      countAsync: passengersAsync.when(
                        data: (p) => p.length,
                        loading: () => null,
                        error: (_, __) => 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Recent missions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Missions récentes',
                      style: Theme.of(context).textTheme.titleMedium),
                  TextButton(
                    onPressed: () => context.push('/missions'),
                    child: const Text('Voir tout'),
                  ),
                ],
              ),
            ),
            missionsAsync.when(
              data: (missions) {
                if (missions.isEmpty) {
                  return const _EmptyMissionsCard();
                }
                final recent = missions.take(3).toList();
                return Column(
                  children: recent.map((m) => _MissionTile(mission: m)).toList(),
                );
              },
              loading: () => const Center(
                  child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              )),
              error: (e, _) => Center(child: Text('Erreur: $e')),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/missions/new'),
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle mission'),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final Map<String, int> counts;
  const _StatRow({required this.counts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Planifiées',
              value: counts['PLANIFIEE'] ?? 0,
              color: AppColors.planifiee,
              icon: Icons.schedule,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatCard(
              label: 'En cours',
              value: counts['EN_COURS'] ?? 0,
              color: AppColors.enCours,
              icon: Icons.directions_car,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatCard(
              label: 'Terminées',
              value: counts['TERMINEE'] ?? 0,
              color: AppColors.terminee,
              icon: Icons.check_circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: color.withOpacity(0.8))),
        ],
      ),
    );
  }
}

class _StatRowSkeleton extends StatelessWidget {
  const _StatRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: SizedBox(height: 80)),
          SizedBox(width: 8),
          Expanded(child: SizedBox(height: 80)),
          SizedBox(width: 8),
          Expanded(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final String route;
  final Color color;
  const _NavItem(this.label, this.icon, this.route, this.color);
}

class _QuickNavGrid extends StatelessWidget {
  final List<_NavItem> items;
  const _QuickNavGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.1,
        children: items.map((item) {
          return InkWell(
            onTap: () => context.push(item.route),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: item.color, size: 26),
                  const SizedBox(height: 6),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: item.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final int? countAsync;

  const _ResourceCard({
    required this.label,
    required this.icon,
    required this.countAsync,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 4),
          Text(
            countAsync?.toString() ?? '—',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          Text(label,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _EmptyMissionsCard extends StatelessWidget {
  const _EmptyMissionsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.assignment_outlined,
                size: 40, color: AppColors.textSecondary.withOpacity(0.5)),
            const SizedBox(height: 8),
            const Text('Aucune mission',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _MissionTile extends StatelessWidget {
  final MissionModel mission;
  const _MissionTile({required this.mission});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: const Icon(Icons.assignment, color: AppColors.primary, size: 20),
        ),
        title: Text(
          mission.reference,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          '${mission.destinationName} • ${formatDateTime(mission.scheduledAt)}',
          style: const TextStyle(fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: () => context.push('/missions/${mission.id}'),
      ),
    );
  }
}
