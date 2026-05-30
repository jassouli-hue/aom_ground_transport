import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/driver_model.dart';
import '../../../data/models/vehicle_model.dart';
import '../../../data/models/passenger_model.dart';
import '../../../data/models/known_location_model.dart';
import '../../../data/models/mission_model.dart';
import '../../../domain/services/mission_builder_service.dart';
import '../../providers/driver_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../providers/passenger_provider.dart';
import '../../providers/known_location_provider.dart';
import '../../providers/database_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/mission_provider.dart';
import '../shared/widgets/aom_app_bar.dart';
import '../shared/map_picker_screen.dart';

class _PassengerPickupEntry {
  PassengerModel passenger;
  KnownLocationModel? pickupLocation;
  String pickupCity;
  double? pickupLat;
  double? pickupLng;

  _PassengerPickupEntry({
    required this.passenger,
    this.pickupLocation,
    required this.pickupCity,
    this.pickupLat,
    this.pickupLng,
  });
}

class MissionEditScreen extends ConsumerStatefulWidget {
  final int missionId;
  const MissionEditScreen({super.key, required this.missionId});

  @override
  ConsumerState<MissionEditScreen> createState() => _MissionEditScreenState();
}

class _MissionEditScreenState extends ConsumerState<MissionEditScreen> {
  final _formKey = GlobalKey<FormState>();

  DriverModel? _driver;
  VehicleModel? _vehicle;
  KnownLocationModel? _destination;
  String _type = 'DEPART';
  bool _returnToBase = true;
  DateTime _scheduledAt = DateTime.now().add(const Duration(hours: 1));
  final List<_PassengerPickupEntry> _passengers = [];
  final _notesCtrl = TextEditingController();
  final _refCtrl = TextEditingController();
  bool _saving = false;
  bool _loaded = false;

  @override
  void dispose() {
    _notesCtrl.dispose();
    _refCtrl.dispose();
    super.dispose();
  }

  Future<void> _preload(MissionModel mission, List<DriverModel> drivers,
      List<VehicleModel> vehicles, List<KnownLocationModel> locations,
      List<PassengerModel> allPassengers) async {
    if (_loaded) return;
    _loaded = true;

    final driver = drivers.where((d) => d.id == mission.driverId).firstOrNull;
    final vehicle = vehicles.where((v) => v.id == mission.vehicleId).firstOrNull;
    final dest = locations.where((l) => l.id == mission.destinationId).firstOrNull;

    final passengerEntries = <_PassengerPickupEntry>[];
    for (final mp in mission.passengers) {
      final p = allPassengers.where((x) => x.id == mp.passengerId).firstOrNull;
      if (p == null) continue;
      passengerEntries.add(_PassengerPickupEntry(
        passenger: p,
        pickupCity: mp.pickupCity,
        pickupLat: mp.pickupLat,
        pickupLng: mp.pickupLng,
      ));
    }

    setState(() {
      _driver = driver;
      _vehicle = vehicle;
      _destination = dest;
      _type = mission.type;
      _returnToBase = mission.returnToBase;
      _scheduledAt = mission.scheduledAt;
      _notesCtrl.text = mission.notes ?? '';
      _refCtrl.text = mission.reference;
      _passengers.clear();
      _passengers.addAll(passengerEntries);
    });
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d == null) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt),
    );
    if (t == null) return;
    setState(() {
      _scheduledAt = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    });
  }

  Future<void> _addPassenger(List<PassengerModel> available) async {
    final already = _passengers.map((e) => e.passenger.id).toSet();
    final choices = available.where((p) => !already.contains(p.id)).toList();
    if (choices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tous les passagers sont déjà ajoutés')));
      return;
    }
    final selected = await showDialog<PassengerModel>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ajouter un passager'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: choices.length,
            itemBuilder: (_, i) {
              final p = choices[i];
              return ListTile(
                leading: CircleAvatar(child: Text(p.name.substring(0, 1))),
                title: Text(p.name),
                subtitle: Text('${p.role} • ${p.baseCity}'),
                onTap: () => Navigator.pop(context, p),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
        ],
      ),
    );
    if (selected == null) return;
    setState(() {
      _passengers.add(_PassengerPickupEntry(
        passenger: selected,
        pickupCity: selected.baseCity,
        // Pré-remplir le GPS depuis le profil du passager si disponible
        pickupLat: selected.baseLat,
        pickupLng: selected.baseLng,
      ));
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_driver == null) { _showError('Sélectionner un chauffeur'); return; }
    if (_vehicle == null) { _showError('Sélectionner un véhicule'); return; }
    if (_destination == null) { _showError('Sélectionner une destination'); return; }

    setState(() => _saving = true);
    try {
      final baseLocId = await ref.read(settingsServiceProvider).getBaseLocationId();
      final baseRepo = ref.read(knownLocationRepositoryProvider);
      final baseLoc = baseLocId != null ? await baseRepo.getById(baseLocId) : null;
      if (baseLoc == null) {
        _showError('Base non configurée. Configurez la base dans les paramètres.');
        return;
      }

      final speed = await ref.read(settingsServiceProvider).getAverageSpeedKmh();
      final req = MissionBuildRequest(
        driverId: _driver!.id,
        vehicleId: _vehicle!.id,
        destination: _destination!,
        scheduledAt: _scheduledAt,
        type: _type,
        returnToBase: _returnToBase,
        baseLocation: baseLoc,
        averageSpeedKmh: speed,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        customReference: _refCtrl.text.trim(),
        passengers: _passengers.map((e) => PassengerPickup(
          passenger: e.passenger,
          pickupLocation: e.pickupLocation,
          pickupCity: e.pickupCity,
          pickupLat: e.pickupLat ?? e.pickupLocation?.latitude,
          pickupLng: e.pickupLng ?? e.pickupLocation?.longitude,
        )).toList(),
      );

      await ref.read(missionBuilderServiceProvider).rebuildAndUpdate(widget.missionId, req);
      ref.invalidate(missionByIdProvider(widget.missionId));
      ref.invalidate(missionsStreamProvider);

      if (mounted) context.pop();
    } catch (e) {
      _showError('Erreur: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.error));
  }

  @override
  Widget build(BuildContext context) {
    final missionAsync = ref.watch(missionByIdProvider(widget.missionId));
    final driversAsync = ref.watch(driversStreamProvider);
    final vehiclesAsync = ref.watch(vehiclesStreamProvider);
    final passengersAsync = ref.watch(passengersStreamProvider);
    final locationsAsync = ref.watch(locationsStreamProvider);

    return missionAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Erreur: $e'))),
      data: (mission) {
        if (mission == null) {
          return const Scaffold(body: Center(child: Text('Mission introuvable')));
        }
        // Preload once all data is ready
        driversAsync.whenData((drivers) => vehiclesAsync.whenData((vehicles) =>
            locationsAsync.whenData((locs) => passengersAsync.whenData((pax) =>
                _preload(mission, drivers, vehicles, locs, pax)))));

        return Scaffold(
          appBar: AomAppBar(title: 'Modifier ${mission.reference}'),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Référence
                _SectionTitle('Référence mission'),
                TextFormField(
                  controller: _refCtrl,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.tag),
                    hintText: 'AOM-2026-001',
                  ),
                  textCapitalization: TextCapitalization.characters,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Référence requise' : null,
                ),
                const SizedBox(height: 20),

                // Type
                _SectionTitle('Type de mission'),
                Row(
                  children: [
                    Expanded(
                      child: _TypeButton(
                        label: 'Départ',
                        icon: Icons.flight_takeoff,
                        selected: _type == 'DEPART',
                        onTap: () => setState(() => _type = 'DEPART'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TypeButton(
                        label: 'Arrivée',
                        icon: Icons.flight_land,
                        selected: _type == 'ARRIVEE',
                        onTap: () => setState(() => _type = 'ARRIVEE'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Date/heure
                _SectionTitle('Date et heure'),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.divider),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.event, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Text(
                          '${_scheduledAt.day.toString().padLeft(2, '0')}/${_scheduledAt.month.toString().padLeft(2, '0')}/${_scheduledAt.year}  ${_scheduledAt.hour.toString().padLeft(2, '0')}:${_scheduledAt.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const Spacer(),
                        const Icon(Icons.edit, size: 16, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Chauffeur
                _SectionTitle('Chauffeur'),
                driversAsync.when(
                  data: (drivers) => DropdownButtonFormField<DriverModel>(
                    value: _driver,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.drive_eta)),
                    hint: const Text('Sélectionner un chauffeur'),
                    items: drivers.map((d) => DropdownMenuItem(value: d, child: Text(d.displayName))).toList(),
                    onChanged: (v) => setState(() => _driver = v),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Erreur chargement chauffeurs'),
                ),
                const SizedBox(height: 16),

                // Véhicule
                _SectionTitle('Véhicule'),
                vehiclesAsync.when(
                  data: (vehicles) => DropdownButtonFormField<VehicleModel>(
                    value: _vehicle,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.directions_car)),
                    hint: const Text('Sélectionner un véhicule'),
                    items: vehicles.map((v) => DropdownMenuItem(value: v, child: Text(v.displayName))).toList(),
                    onChanged: (v) => setState(() => _vehicle = v),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Erreur chargement véhicules'),
                ),
                const SizedBox(height: 16),

                // Destination
                _SectionTitle('Destination'),
                locationsAsync.when(
                  data: (locations) => DropdownButtonFormField<KnownLocationModel>(
                    value: _destination,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.place)),
                    hint: const Text('Sélectionner une destination'),
                    items: locations.map((l) => DropdownMenuItem(value: l, child: Text(l.displayName))).toList(),
                    onChanged: (v) => setState(() => _destination = v),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Erreur chargement destinations'),
                ),
                const SizedBox(height: 16),

                // Retour base
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Retour à la base'),
                  subtitle: const Text('Inclure un retour à la base dans l\'itinéraire'),
                  value: _returnToBase,
                  onChanged: (v) => setState(() => _returnToBase = v),
                ),
                const Divider(),
                const SizedBox(height: 8),

                // Passagers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle('Passagers (${_passengers.length})'),
                    passengersAsync.when(
                      data: (pax) => TextButton.icon(
                        onPressed: () => _addPassenger(pax),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Ajouter'),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
                if (_passengers.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Aucun passager ajouté',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  )
                else
                  ..._passengers.asMap().entries.map((entry) {
                    final i = entry.key;
                    final e = entry.value;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.accent.withOpacity(0.1),
                              child: Text('${i + 1}',
                                  style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.passenger.displayName,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  const SizedBox(height: 4),
                                  TextFormField(
                                    initialValue: e.pickupCity,
                                    decoration: const InputDecoration(
                                      labelText: 'Lieu de prise en charge',
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    ),
                                    onChanged: (v) => setState(() => e.pickupCity = v),
                                  ),
                                  const SizedBox(height: 6),
                                  if (e.pickupLat != null)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        '📍 ${e.pickupLat!.toStringAsFixed(4)}, ${e.pickupLng!.toStringAsFixed(4)}',
                                        style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: () async {
                                        final result = await Navigator.of(context).push<LatLngResult>(
                                          MaterialPageRoute(
                                            builder: (_) => MapPickerScreen(
                                              initialLat: e.pickupLat,
                                              initialLng: e.pickupLng,
                                              title: 'Position de ${e.passenger.name}',
                                            ),
                                          ),
                                        );
                                        if (result != null && mounted) {
                                          setState(() {
                                            e.pickupLat = result.lat;
                                            e.pickupLng = result.lng;
                                            // Auto-remplir la ville depuis Nominatim
                                            if (result.city != null && result.city!.isNotEmpty) {
                                              e.pickupCity = result.city!;
                                            }
                                          });
                                        }
                                      },
                                      icon: Icon(e.pickupLat != null ? Icons.edit_location : Icons.add_location_alt,
                                          size: 16, color: AppColors.primary),
                                      label: Text(e.pickupLat != null ? 'Modifier position' : 'Choisir sur la carte',
                                          style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        side: BorderSide(color: AppColors.primary.withOpacity(0.4)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
                              onPressed: () => setState(() => _passengers.removeAt(i)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 16),

                // Notes
                TextFormField(
                  controller: _notesCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optionnel)',
                    prefixIcon: Icon(Icons.notes),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 32),

                ElevatedButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(height: 16, width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.save),
                  label: const Text('Enregistrer les modifications'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _TypeButton({required this.label, required this.icon, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          border: Border.all(color: selected ? AppColors.primary : AppColors.divider, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? Colors.white : AppColors.textSecondary, size: 20),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            )),
          ],
        ),
      ),
    );
  }
}
