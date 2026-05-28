import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/mission_step_model.dart';
import '../../providers/mission_provider.dart';
import '../../providers/database_provider.dart';
import '../shared/widgets/aom_app_bar.dart';
import '../shared/widgets/status_badge.dart';
import '../shared/widgets/whatsapp_action_buttons.dart';

class MissionDetailScreen extends ConsumerWidget {
  final int missionId;
  const MissionDetailScreen({super.key, required this.missionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionAsync = ref.watch(missionByIdProvider(missionId));

    return missionAsync.when(
      data: (mission) {
        if (mission == null) {
          return Scaffold(
            appBar: const AomAppBar(title: 'Mission introuvable'),
            body: const Center(child: Text('Mission introuvable')),
          );
        }

        return Scaffold(
          appBar: AomAppBar(
            title: mission.reference,
            subtitle: mission.typeLabel,
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (v) async {
                  final repo = ref.read(missionRepositoryProvider);
                  await repo.updateStatus(mission.id, v);
                  ref.invalidate(missionByIdProvider(missionId));
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'EN_COURS', child: Text('Démarrer mission')),
                  PopupMenuItem(value: 'TERMINEE', child: Text('Terminer mission')),
                  PopupMenuItem(value: 'ANNULEE', child: Text('Annuler mission')),
                  PopupMenuItem(value: 'PLANIFIEE', child: Text('Réinitialiser')),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header card
              _InfoCard(
                children: [
                  _InfoRow(Icons.assignment, 'Référence', mission.reference),
                  _InfoRow(Icons.schedule, 'Date', formatDateTime(mission.scheduledAt)),
                  _InfoRow(Icons.place, 'Destination', mission.destinationName),
                  Row(
                    children: [
                      const SizedBox(width: 28),
                      const Text('Statut : ',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      StatusBadge(status: mission.status),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Driver & Vehicle
              _InfoCard(
                title: 'Équipage & Véhicule',
                children: [
                  _InfoRow(Icons.drive_eta, 'Chauffeur', mission.driverName),
                  _InfoRow(Icons.phone, 'Tél. chauffeur', mission.driverPhone),
                  _InfoRow(Icons.directions_car, 'Véhicule',
                      '${mission.vehicleBrand} — ${mission.vehiclePlate}'),
                ],
              ),
              const SizedBox(height: 12),

              // Distance
              if (mission.totalDistanceKm != null)
                _InfoCard(
                  title: 'Distance & Durée',
                  children: [
                    _InfoRow(Icons.straighten, 'Distance totale',
                        '${mission.totalDistanceKm!.toStringAsFixed(1)} km'),
                    if (mission.estimatedDurationMin != null)
                      _InfoRow(Icons.timer, 'Durée estimée',
                          formatDuration(mission.estimatedDurationMin!)),
                    if (mission.returnToBase)
                      _InfoRow(Icons.home, 'Retour base', 'Oui'),
                  ],
                ),
              if (mission.totalDistanceKm != null) const SizedBox(height: 12),

              // Google Maps
              if (mission.googleMapsUrl != null) ...[
                OutlinedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse(mission.googleMapsUrl!);
                    if (!await launchUrl(uri,
                        mode: LaunchMode.externalApplication)) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Impossible d\'ouvrir Google Maps')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.map),
                  label: const Text('Ouvrir itinéraire Google Maps'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Itinerary steps
              if (mission.steps.isNotEmpty) ...[
                Text('Itinéraire (${mission.steps.length} étapes)',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...mission.steps.asMap().entries.map((entry) {
                  final step = entry.value;
                  final isLast = entry.key == mission.steps.length - 1;
                  return _StepTile(step: step, isLast: isLast);
                }),
                const SizedBox(height: 12),
              ],

              // WhatsApp — Chauffeur
              Text('Notifications WhatsApp',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              WhatsAppDriverButtons(
                mission: mission,
                onStatusChanged: () => ref.invalidate(missionByIdProvider(missionId)),
              ),
              const SizedBox(height: 8),

              // WhatsApp — Passagers
              ...mission.passengers.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: WhatsAppPassengerButtons(
                      mission: mission,
                      passenger: p,
                      onStatusChanged: () =>
                          ref.invalidate(missionByIdProvider(missionId)),
                    ),
                  )),

              // Notes
              if (mission.notes != null && mission.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _InfoCard(
                  title: 'Notes',
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(mission.notes!,
                          style: const TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Erreur: $e')),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _InfoCard({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.primary)),
            const Divider(height: 16),
          ],
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text('$label : ',
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final MissionStepModel step;
  final bool isLast;

  const _StepTile({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _stepColor(step.type),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(_stepIcon(step.type),
                      size: 14, color: Colors.white),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.divider,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.typeLabel,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                  Text(step.locationName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  if (step.distanceFromPrevKm != null)
                    Text(
                      '+${step.distanceFromPrevKm!.toStringAsFixed(1)} km'
                      '${step.durationFromPrevMin != null ? ' / ${formatDuration(step.durationFromPrevMin!)}' : ''}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _stepColor(String type) {
    switch (type) {
      case 'DEPART_BASE':
        return AppColors.primary;
      case 'PICKUP':
        return AppColors.accent;
      case 'DESTINATION':
        return AppColors.success;
      case 'RETOUR_BASE':
        return AppColors.primaryLight;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _stepIcon(String type) {
    switch (type) {
      case 'DEPART_BASE':
        return Icons.home;
      case 'PICKUP':
        return Icons.person_pin;
      case 'DESTINATION':
        return Icons.flag;
      case 'RETOUR_BASE':
        return Icons.home_filled;
      default:
        return Icons.circle;
    }
  }
}
