import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/mission_model.dart';
import '../../../domain/services/pdf_report_service.dart';
import '../../providers/mission_provider.dart';
import '../../providers/driver_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../shared/widgets/aom_app_bar.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String? _driverFilter;
  String? _vehicleFilter;
  bool _generating = false;

  Future<void> _pickDate(bool isFrom) async {
    final initial = isFrom ? (_dateFrom ?? DateTime.now()) : (_dateTo ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _dateFrom = DateTime(picked.year, picked.month, picked.day);
      } else {
        _dateTo = DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
      }
    });
  }

  List<MissionModel> _applyFilters(List<MissionModel> all) {
    return all.where((m) {
      if (_dateFrom != null && m.scheduledAt.isBefore(_dateFrom!)) return false;
      if (_dateTo != null && m.scheduledAt.isAfter(_dateTo!)) return false;
      if (_driverFilter != null && m.driverName != _driverFilter) return false;
      if (_vehicleFilter != null && '${m.vehicleBrand} — ${m.vehiclePlate}' != _vehicleFilter) return false;
      return true;
    }).toList();
  }

  Future<void> _generatePdf(List<MissionModel> filtered) async {
    setState(() => _generating = true);
    try {
      final service = PdfReportService();
      final bytes = await service.generateMissionsReport(
        missions: filtered,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        driverFilter: _driverFilter,
        vehicleFilter: _vehicleFilter,
      );
      await Printing.layoutPdf(
        onLayout: (_) async => bytes,
        name: 'AOM_Missions_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur PDF: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final missionsAsync = ref.watch(missionsStreamProvider);
    final driversAsync = ref.watch(driversStreamProvider);
    final vehiclesAsync = ref.watch(vehiclesStreamProvider);

    return Scaffold(
      appBar: const AomAppBar(title: 'Rapport PDF'),
      body: missionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (allMissions) {
          final filtered = _applyFilters(allMissions);

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Période
                    _SectionCard(
                      title: 'Période',
                      child: Row(
                        children: [
                          Expanded(
                            child: _DateChip(
                              label: 'Du',
                              value: _dateFrom != null ? formatDate(_dateFrom!) : 'Toutes dates',
                              onTap: () => _pickDate(true),
                              onClear: _dateFrom != null ? () => setState(() => _dateFrom = null) : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _DateChip(
                              label: 'Au',
                              value: _dateTo != null ? formatDate(_dateTo!) : 'Toutes dates',
                              onTap: () => _pickDate(false),
                              onClear: _dateTo != null ? () => setState(() => _dateTo = null) : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Chauffeur
                    _SectionCard(
                      title: 'Chauffeur',
                      child: driversAsync.when(
                        data: (drivers) => DropdownButtonFormField<String>(
                          value: _driverFilter,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.drive_eta),
                            isDense: true,
                          ),
                          hint: const Text('Tous les chauffeurs'),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('Tous les chauffeurs')),
                            ...drivers.map((d) => DropdownMenuItem(value: d.name, child: Text(d.displayName))),
                          ],
                          onChanged: (v) => setState(() => _driverFilter = v),
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Véhicule
                    _SectionCard(
                      title: 'Véhicule',
                      child: vehiclesAsync.when(
                        data: (vehicles) => DropdownButtonFormField<String>(
                          value: _vehicleFilter,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.directions_car),
                            isDense: true,
                          ),
                          hint: const Text('Tous les véhicules'),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('Tous les véhicules')),
                            ...vehicles.map((v) => DropdownMenuItem(
                                value: '${v.brand} — ${v.plateNumber}',
                                child: Text(v.displayName))),
                          ],
                          onChanged: (v) => setState(() => _vehicleFilter = v),
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Preview count
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.summarize, color: AppColors.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${filtered.length} mission${filtered.length > 1 ? 's' : ''} sélectionnée${filtered.length > 1 ? 's' : ''}',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.primary),
                                ),
                                Text(
                                  _buildSummary(filtered),
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (filtered.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      // Mini-liste preview
                      Text('Aperçu', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 6),
                      ...filtered.take(5).map((m) => _MissionPreviewTile(mission: m)),
                      if (filtered.length > 5)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            '... et ${filtered.length - 5} autre${filtered.length - 5 > 1 ? 's' : ''}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ],
                ),
              ),

              // Bottom action bar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: ElevatedButton.icon(
                    onPressed: (filtered.isEmpty || _generating)
                        ? null
                        : () => _generatePdf(filtered),
                    icon: _generating
                        ? const SizedBox(height: 18, width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.picture_as_pdf),
                    label: Text(_generating
                        ? 'Génération...'
                        : 'Générer PDF (${filtered.length} mission${filtered.length > 1 ? 's' : ''})'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _buildSummary(List<MissionModel> m) {
    if (m.isEmpty) return 'Aucune mission correspondante';
    final km = m.fold<double>(0, (s, x) => s + (x.totalDistanceKm ?? 0));
    final terminees = m.where((x) => x.status == 'TERMINEE').length;
    return '${km.toStringAsFixed(0)} km total • $terminees terminée${terminees > 1 ? 's' : ''}';
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  const _DateChip({required this.label, required this.value, required this.onTap, this.onClear});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.clear, size: 14, color: AppColors.textSecondary),
              ),
          ],
        ),
      ),
    );
  }
}

class _MissionPreviewTile extends StatelessWidget {
  final MissionModel mission;
  const _MissionPreviewTile({required this.mission});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(mission.reference,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ),
          Text(formatDate(mission.scheduledAt),
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Text(mission.driverName,
              style: const TextStyle(fontSize: 11)),
          const SizedBox(width: 8),
          Text(mission.statusLabel,
              style: TextStyle(fontSize: 10, color: _statusColor(mission.status), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'PLANIFIEE': return AppColors.planifiee;
      case 'EN_COURS': return AppColors.enCours;
      case 'TERMINEE': return AppColors.terminee;
      default: return AppColors.textSecondary;
    }
  }
}
