import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../providers/mission_provider.dart';
import '../shared/widgets/aom_app_bar.dart';
import '../shared/widgets/status_badge.dart';

class MissionsScreen extends ConsumerStatefulWidget {
  const MissionsScreen({super.key});

  @override
  ConsumerState<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends ConsumerState<MissionsScreen> {
  String _filter = 'TOUS';

  @override
  Widget build(BuildContext context) {
    final missionsAsync = ref.watch(missionsStreamProvider);

    return Scaffold(
      appBar: AomAppBar(
        title: 'Missions',
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (v) => setState(() => _filter = v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'TOUS', child: Text('Toutes')),
              PopupMenuItem(value: 'PLANIFIEE', child: Text('Planifiées')),
              PopupMenuItem(value: 'EN_COURS', child: Text('En cours')),
              PopupMenuItem(value: 'TERMINEE', child: Text('Terminées')),
              PopupMenuItem(value: 'ANNULEE', child: Text('Annulées')),
            ],
          ),
        ],
      ),
      body: missionsAsync.when(
        data: (missions) {
          final filtered = _filter == 'TOUS'
              ? missions
              : missions.where((m) => m.status == _filter).toList();

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.assignment_outlined,
                      size: 48, color: AppColors.textSecondary),
                  const SizedBox(height: 12),
                  Text(
                    _filter == 'TOUS'
                        ? 'Aucune mission'
                        : 'Aucune mission — $_filter',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: filtered.length,
            itemBuilder: (context, i) {
              final m = filtered[i];
              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => context.push('/missions/${m.id}'),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                m.reference,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            StatusBadge(status: m.status),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                m.typeLabel,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.place, size: 14,
                                color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                m.destinationName,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 14,
                                color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              formatDateTime(m.scheduledAt),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary),
                            ),
                            const Spacer(),
                            const Icon(Icons.drive_eta, size: 14,
                                color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              m.driverName,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        if (m.totalDistanceKm != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.straighten, size: 14,
                                  color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                '${m.totalDistanceKm!.toStringAsFixed(1)} km',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary),
                              ),
                              if (m.estimatedDurationMin != null) ...[
                                const Text(' • ',
                                    style: TextStyle(
                                        color: AppColors.textSecondary)),
                                Text(
                                  formatDuration(m.estimatedDurationMin!),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/missions/new'),
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle mission'),
      ),
    );
  }
}
