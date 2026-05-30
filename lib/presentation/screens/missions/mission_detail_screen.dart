import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/mission_model.dart';
import '../../../data/models/mission_step_model.dart';
import '../../providers/mission_provider.dart';
import '../../providers/database_provider.dart';
import '../shared/widgets/aom_app_bar.dart';
import '../shared/widgets/status_badge.dart';
import '../shared/widgets/whatsapp_action_buttons.dart';
import '../shared/map_picker_screen.dart';
import '../../../data/models/known_location_model.dart';
import '../../providers/known_location_provider.dart';

class MissionDetailScreen extends ConsumerStatefulWidget {
  final int missionId;
  const MissionDetailScreen({super.key, required this.missionId});

  @override
  ConsumerState<MissionDetailScreen> createState() => _MissionDetailScreenState();
}

class _MissionDetailScreenState extends ConsumerState<MissionDetailScreen> {
  bool _stepLoading = false;

  int get missionId => widget.missionId;

  bool _canEditSteps(String status) =>
      status == 'PLANIFIEE' || status == 'EN_COURS';

  Future<void> _showAddStepSheet(
      BuildContext context, List<MissionStepModel> currentSteps) async {
    // Charger les lieux enregistrés
    final knownLocs =
        await ref.read(knownLocationRepositoryProvider).getAll();

    // États du sheet
    bool useKnownLocation = true;
    KnownLocationModel? selectedKnownLoc;
    final nameCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    double? lat;
    double? lng;
    String searchQuery = '';

    // Bornes d'insertion : après DEPART_BASE, avant RETOUR_BASE
    final departIdx = currentSteps.indexWhere((s) => s.type == 'DEPART_BASE');
    final minInsert = departIdx >= 0 ? departIdx + 1 : 0;
    final retourIdx = currentSteps.indexWhere((s) => s.type == 'RETOUR_BASE');
    final maxInsert = retourIdx >= 0 ? retourIdx : currentSteps.length;
    final destIdx = currentSteps.indexWhere((s) => s.type == 'DESTINATION');
    int selectedPosition = (destIdx >= minInsert && destIdx <= maxInsert)
        ? destIdx
        : maxInsert; // par défaut : juste avant DESTINATION

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          // Lieux filtrés par recherche
          final filtered = knownLocs
              .where((l) =>
                  searchQuery.isEmpty ||
                  l.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  l.city.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.75,
            maxChildSize: 0.95,
            minChildSize: 0.4,
            builder: (_, scrollCtrl) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Column(
                children: [
                  // Handle + titre
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: 40, height: 4,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const Row(
                          children: [
                            Icon(Icons.add_location_alt,
                                color: AppColors.accent, size: 20),
                            SizedBox(width: 8),
                            Text('Ajouter une étape de prise en charge',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Toggle : Lieu enregistré | Nouveau lieu
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setSheetState(() => useKnownLocation = true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: useKnownLocation
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.bookmark,
                                            size: 14,
                                            color: useKnownLocation
                                                ? Colors.white
                                                : AppColors.textSecondary),
                                        const SizedBox(width: 6),
                                        Text('Lieu enregistré',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: useKnownLocation
                                                    ? Colors.white
                                                    : AppColors.textSecondary)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setSheetState(() => useKnownLocation = false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: !useKnownLocation
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.edit_location_alt,
                                            size: 14,
                                            color: !useKnownLocation
                                                ? Colors.white
                                                : AppColors.textSecondary),
                                        const SizedBox(width: 6),
                                        Text('Nouveau lieu',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: !useKnownLocation
                                                    ? Colors.white
                                                    : AppColors.textSecondary)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ─── Sélecteur de position ───
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.divider),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.swap_vert,
                                  color: AppColors.primary, size: 18),
                              const SizedBox(width: 8),
                              const Text('Position :',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: selectedPosition,
                                    isExpanded: true,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w500),
                                    items: [
                                      for (int i = minInsert; i <= maxInsert; i++)
                                        DropdownMenuItem(
                                          value: i,
                                          child: Text(
                                            () {
                                              if (i == minInsert) {
                                                return departIdx >= 0
                                                    ? '🏠 Après la base de départ'
                                                    : '🥇 En première position';
                                              }
                                              final prev = currentSteps[i - 1];
                                              if (prev.type == 'DESTINATION') return '📍 Après la destination';
                                              if (i < currentSteps.length &&
                                                  currentSteps[i].type == 'DESTINATION') {
                                                return '📍 Juste avant la destination';
                                              }
                                              return 'Après : ${prev.locationName}';
                                            }(),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                    ],
                                    onChanged: (v) => setSheetState(
                                        () => selectedPosition = v!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 16),

                  // ─── Contenu scrollable ───
                  Expanded(
                    child: useKnownLocation
                        ? _buildKnownLocationList(
                            ctx, scrollCtrl, filtered, selectedKnownLoc,
                            (loc) => setSheetState(() => selectedKnownLoc = loc),
                            (q) => setSheetState(() => searchQuery = q),
                            searchQuery)
                        : _buildFreeFormFields(
                            ctx, scrollCtrl, nameCtrl, cityCtrl, lat, lng,
                            (r) => setSheetState(() {
                              lat = r.lat;
                              lng = r.lng;
                            })),
                  ),

                  // ─── Bouton Ajouter ───
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          String name, city;
                          double? finalLat, finalLng;

                          if (useKnownLocation) {
                            if (selectedKnownLoc == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Sélectionnez un lieu')),
                              );
                              return;
                            }
                            name = selectedKnownLoc!.name;
                            city = selectedKnownLoc!.city;
                            finalLat = selectedKnownLoc!.latitude;
                            finalLng = selectedKnownLoc!.longitude;
                          } else {
                            name = nameCtrl.text.trim();
                            city = cityCtrl.text.trim();
                            finalLat = lat;
                            finalLng = lng;
                            if (name.isEmpty || city.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Nom et ville requis')),
                              );
                              return;
                            }
                          }

                          Navigator.of(sheetCtx).pop();
                          setState(() => _stepLoading = true);
                          try {
                            await ref
                                .read(missionRepositoryProvider)
                                .addPickupStep(
                                  missionId: missionId,
                                  locationName: name,
                                  city: city,
                                  lat: finalLat,
                                  lng: finalLng,
                                  insertAtIndex: selectedPosition,
                                );
                            ref.invalidate(missionByIdProvider(missionId));
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Erreur: $e'),
                                    backgroundColor: AppColors.error),
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _stepLoading = false);
                          }
                        },
                        icon: const Icon(Icons.add_location),
                        label: const Text('Ajouter cette étape',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKnownLocationList(
    BuildContext ctx,
    ScrollController scrollCtrl,
    List<KnownLocationModel> locs,
    KnownLocationModel? selected,
    ValueChanged<KnownLocationModel> onSelect,
    ValueChanged<String> onSearch,
    String query,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher un lieu…',
              prefixIcon: const Icon(Icons.search, size: 18),
              isDense: true,
              suffixIcon: query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 16),
                      onPressed: () => onSearch(''),
                    )
                  : null,
            ),
            onChanged: onSearch,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: locs.isEmpty
              ? const Center(
                  child: Text('Aucun lieu trouvé',
                      style: TextStyle(color: AppColors.textSecondary)))
              : ListView.separated(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: locs.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final loc = locs[i];
                    final isSelected = selected?.id == loc.id;
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: isSelected
                            ? AppColors.primary
                            : (loc.isAirport
                                ? AppColors.accent.withOpacity(0.12)
                                : AppColors.primary.withOpacity(0.08)),
                        child: Icon(
                          loc.isAirport
                              ? Icons.flight
                              : Icons.place,
                          size: 14,
                          color: isSelected
                              ? Colors.white
                              : (loc.isAirport
                                  ? AppColors.accent
                                  : AppColors.primary),
                        ),
                      ),
                      title: Text(loc.name,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500)),
                      subtitle: Text('${loc.shortCode} • ${loc.city}',
                          style:
                              const TextStyle(fontSize: 11)),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle,
                              color: AppColors.primary, size: 20)
                          : null,
                      selected: isSelected,
                      selectedTileColor:
                          AppColors.primary.withOpacity(0.05),
                      onTap: () => onSelect(loc),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFreeFormFields(
    BuildContext ctx,
    ScrollController scrollCtrl,
    TextEditingController nameCtrl,
    TextEditingController cityCtrl,
    double? lat,
    double? lng,
    ValueChanged<LatLngResult> onMapResult,
  ) {
    return ListView(
      controller: scrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(
            labelText: 'Nom du lieu *',
            prefixIcon: Icon(Icons.place),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: cityCtrl,
          decoration: const InputDecoration(
            labelText: 'Ville *',
            prefixIcon: Icon(Icons.location_city),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            final result = await Navigator.of(ctx).push<LatLngResult>(
              MaterialPageRoute(
                builder: (_) => MapPickerScreen(
                  initialLat: lat,
                  initialLng: lng,
                  title: 'Position de l\'étape',
                ),
              ),
            );
            if (result != null) {
              onMapResult(result);
              // Auto-remplir le nom et la ville depuis Nominatim
              if (result.city != null && result.city!.isNotEmpty
                  && cityCtrl.text.isEmpty) {
                cityCtrl.text = result.city!;
              }
              if (result.address != null && result.address!.isNotEmpty
                  && nameCtrl.text.isEmpty) {
                nameCtrl.text = result.address!;
              }
            }
          },
          icon: Icon(
              lat != null ? Icons.edit_location : Icons.add_location_alt,
              color: AppColors.primary),
          label: Text(
            lat != null
                ? '📍 ${lat.toStringAsFixed(4)}, ${lng!.toStringAsFixed(4)}'
                : 'Positionner sur la carte (optionnel)',
            style: const TextStyle(color: AppColors.primary),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _showSendAllSheet(BuildContext context, MissionModel mission) async {
    final waService = ref.read(whatsAppMessageServiceProvider);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (sheetCtx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.92,
        minChildSize: 0.4,
        builder: (_, scrollCtrl) => Column(
          children: [
            // Handle + titre
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.send_and_archive,
                          color: Color(0xFF25D366), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Envoyer à Tous — ${mission.reference}',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${1 + mission.passengers.length} destinataire(s)',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Divider(height: 16),

            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  // ── Chauffeur ──
                  _SendAllTile(
                    icon: Icons.drive_eta,
                    name: mission.driverName,
                    role: 'Chauffeur',
                    phone: mission.driverPhone,
                    message: waService.buildDriverMessage(mission),
                    onSend: () async {
                      Navigator.of(sheetCtx).pop();
                      await waService.openWhatsApp(
                        missionId: mission.id,
                        recipientType: 'CHAUFFEUR',
                        recipientId: mission.driverId,
                        recipientName: mission.driverName,
                        recipientPhone: mission.driverPhone,
                        message: waService.buildDriverMessage(mission),
                      );
                      ref.invalidate(missionByIdProvider(missionId));
                    },
                  ),
                  const Divider(height: 8),

                  // ── Passagers ──
                  ...mission.passengers.map((p) => _SendAllTile(
                        icon: Icons.person,
                        name: p.passengerName,
                        role: '${p.passengerRole} • ${p.pickupCity}',
                        phone: p.passengerPhone,
                        message: waService.buildPassengerMessage(mission, p),
                        onSend: () async {
                          Navigator.of(sheetCtx).pop();
                          await waService.openWhatsApp(
                            missionId: mission.id,
                            recipientType: 'PASSAGER',
                            recipientId: p.passengerId ?? 0,
                            recipientName: p.passengerName,
                            recipientPhone: p.passengerPhone,
                            message: waService.buildPassengerMessage(mission, p),
                          );
                          ref.invalidate(missionByIdProvider(missionId));
                        },
                      )),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // Fermer
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: TextButton(
                onPressed: () => Navigator.of(sheetCtx).pop(),
                child: const Text('Fermer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _moveStep(int stepId, {required bool moveUp}) async {
    setState(() => _stepLoading = true);
    try {
      await ref.read(missionRepositoryProvider).moveStep(
            stepId: stepId,
            missionId: missionId,
            moveUp: moveUp,
          );
      ref.invalidate(missionByIdProvider(missionId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _stepLoading = false);
    }
  }

  Future<void> _deleteStep(int stepId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer l\'étape ?'),
        content: const Text('Cette étape sera supprimée et les distances recalculées.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _stepLoading = true);
    try {
      await ref.read(missionRepositoryProvider).removePickupStep(stepId, missionId);
      ref.invalidate(missionByIdProvider(missionId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _stepLoading = false);
    }
  }

  Future<void> _removeBaseStep(String type) async {
    final label = type == 'DEPART_BASE' ? 'la base de départ' : 'le retour base';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Supprimer $label ?'),
        content: Text('L\'étape sera retirée de l\'itinéraire et les distances recalculées.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _stepLoading = true);
    try {
      await ref
          .read(missionRepositoryProvider)
          .removeBaseStep(missionId: missionId, type: type);
      ref.invalidate(missionByIdProvider(missionId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _stepLoading = false);
    }
  }

  Future<void> _showChangeBaseSheet(
      BuildContext context, MissionStepModel step) async {
    final knownLocs = await ref.read(knownLocationRepositoryProvider).getAll();
    bool useKnownLocation = true;
    KnownLocationModel? selectedKnownLoc;
    final nameCtrl = TextEditingController(text: step.locationName);
    final cityCtrl = TextEditingController(text: step.city);
    double? lat = step.latitude;
    double? lng = step.longitude;
    String searchQuery = '';

    final isDepart = step.type == 'DEPART_BASE';
    final title =
        isDepart ? 'Modifier la base de départ' : 'Modifier le retour base';

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final filtered = knownLocs
              .where((l) =>
                  searchQuery.isEmpty ||
                  l.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  l.city.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.75,
            maxChildSize: 0.95,
            minChildSize: 0.4,
            builder: (_, scrollCtrl) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: 40, height: 4,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(isDepart ? Icons.home : Icons.home_filled,
                                color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(title,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setSheetState(
                                      () => useKnownLocation = true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: useKnownLocation
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.bookmark,
                                            size: 14,
                                            color: useKnownLocation
                                                ? Colors.white
                                                : AppColors.textSecondary),
                                        const SizedBox(width: 6),
                                        Text('Lieu enregistré',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: useKnownLocation
                                                    ? Colors.white
                                                    : AppColors.textSecondary)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setSheetState(
                                      () => useKnownLocation = false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: !useKnownLocation
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.edit_location_alt,
                                            size: 14,
                                            color: !useKnownLocation
                                                ? Colors.white
                                                : AppColors.textSecondary),
                                        const SizedBox(width: 6),
                                        Text('Nouveau lieu',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: !useKnownLocation
                                                    ? Colors.white
                                                    : AppColors.textSecondary)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 16),
                  Expanded(
                    child: useKnownLocation
                        ? _buildKnownLocationList(
                            ctx, scrollCtrl, filtered, selectedKnownLoc,
                            (loc) => setSheetState(() => selectedKnownLoc = loc),
                            (q) => setSheetState(() => searchQuery = q),
                            searchQuery)
                        : _buildFreeFormFields(
                            ctx, scrollCtrl, nameCtrl, cityCtrl, lat, lng,
                            (r) => setSheetState(() {
                              lat = r.lat;
                              lng = r.lng;
                            })),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          String name, city;
                          double finalLat, finalLng;

                          if (useKnownLocation) {
                            if (selectedKnownLoc == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Sélectionnez un lieu')),
                              );
                              return;
                            }
                            name = selectedKnownLoc!.name;
                            city = selectedKnownLoc!.city;
                            finalLat = selectedKnownLoc!.latitude;
                            finalLng = selectedKnownLoc!.longitude;
                          } else {
                            name = nameCtrl.text.trim();
                            city = cityCtrl.text.trim();
                            if (name.isEmpty || city.isEmpty || lat == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Nom, ville et position GPS requis')),
                              );
                              return;
                            }
                            finalLat = lat!;
                            finalLng = lng!;
                          }

                          Navigator.of(sheetCtx).pop();
                          setState(() => _stepLoading = true);
                          try {
                            await ref
                                .read(missionRepositoryProvider)
                                .setBaseStep(
                                  missionId: missionId,
                                  type: step.type,
                                  locationName: name,
                                  city: city,
                                  lat: finalLat,
                                  lng: finalLng,
                                );
                            ref.invalidate(missionByIdProvider(missionId));
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Erreur: $e'),
                                    backgroundColor: AppColors.error),
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _stepLoading = false);
                          }
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Appliquer',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  if (v == 'EDIT') {
                    await context.push('/missions/${missionId}/edit');
                    ref.invalidate(missionByIdProvider(missionId));
                    return;
                  }
                  if (v == 'TERMINEE') {
                    final now = DateTime.now();
                    if (mission.scheduledAt.isAfter(now)) {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Mission future'),
                          content: Text(
                            'Cette mission est planifiée le ${mission.scheduledAt.day.toString().padLeft(2,'0')}/${mission.scheduledAt.month.toString().padLeft(2,'0')}/${mission.scheduledAt.year} à ${mission.scheduledAt.hour.toString().padLeft(2,'0')}:${mission.scheduledAt.minute.toString().padLeft(2,'0')}.\n\nConfirmer quand même la terminaison ?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Confirmer',
                                  style: TextStyle(color: AppColors.warning)),
                            ),
                          ],
                        ),
                      );
                      if (confirmed != true) return;
                    }
                    final repo = ref.read(missionRepositoryProvider);
                    await repo.updateStatus(mission.id, v);
                    ref.invalidate(missionByIdProvider(missionId));
                    return;
                  }
                  if (v == 'DELETE') {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Supprimer la mission ?'),
                        content: Text(
                            'Supprimer définitivement ${mission.reference} et toutes ses données ?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Supprimer',
                                style: TextStyle(color: AppColors.error)),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      await ref.read(missionRepositoryProvider).deleteMission(mission.id);
                      ref.invalidate(missionsStreamProvider);
                      if (context.mounted) context.pop();
                    }
                    return;
                  }
                  final repo = ref.read(missionRepositoryProvider);
                  await repo.updateStatus(mission.id, v);
                  ref.invalidate(missionByIdProvider(missionId));
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'EDIT', child: Row(children: [
                    Icon(Icons.edit, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Modifier la mission'),
                  ])),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 'EN_COURS', child: Text('Démarrer mission')),
                  const PopupMenuItem(value: 'TERMINEE', child: Text('Terminer mission')),
                  const PopupMenuItem(value: 'ANNULEE', child: Text('Annuler mission')),
                  const PopupMenuItem(value: 'PLANIFIEE', child: Text('Réinitialiser')),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'DELETE',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                        SizedBox(width: 8),
                        Text('Supprimer mission',
                            style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
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

              // Google Maps + Envoyer à Tous
              if (mission.googleMapsUrl != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final uri = Uri.parse(mission.googleMapsUrl!);
                          if (!await launchUrl(uri,
                              mode: LaunchMode.externalApplication)) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Impossible d\'ouvrir Google Maps')),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.map, size: 18),
                        label: const Text('Google Maps',
                            style: TextStyle(fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showSendAllSheet(context, mission),
                        icon: const Icon(Icons.send_and_archive, size: 18),
                        label: const Text('Envoyer à Tous',
                            style: TextStyle(fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // Itinerary steps
              if (mission.steps.isNotEmpty || _canEditSteps(mission.status)) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Itinéraire (${mission.steps.length} étapes)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (_canEditSteps(mission.status))
                      _stepLoading
                          ? const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : TextButton.icon(
                              onPressed: () => _showAddStepSheet(context, mission.steps),
                              icon: const Icon(Icons.add_location_alt, size: 18),
                              label: const Text('Ajouter étape'),
                              style: TextButton.styleFrom(
                                  foregroundColor: AppColors.accent),
                            ),
                  ],
                ),
                const SizedBox(height: 8),
                ...() {
                  return mission.steps.asMap().entries.map((entry) {
                    final allIdx = entry.key;
                    final step = entry.value;
                    final isLast = allIdx == mission.steps.length - 1;
                    final prevStep = allIdx > 0 ? mission.steps[allIdx - 1] : null;
                    final nextStep = allIdx < mission.steps.length - 1
                        ? mission.steps[allIdx + 1]
                        : null;

                    final canMoveStep = _canEditSteps(mission.status) &&
                        step.type == 'PICKUP';
                    final canEditBase = _canEditSteps(mission.status) &&
                        (step.type == 'DEPART_BASE' || step.type == 'RETOUR_BASE');

                    return _StepTile(
                      step: step,
                      isLast: isLast,
                      onDelete: canMoveStep ? () => _deleteStep(step.id) : null,
                      onMoveUp: (canMoveStep &&
                              prevStep != null &&
                              prevStep.type != 'DEPART_BASE')
                          ? () => _moveStep(step.id, moveUp: true)
                          : null,
                      onMoveDown: (canMoveStep &&
                              nextStep != null &&
                              nextStep.type != 'RETOUR_BASE')
                          ? () => _moveStep(step.id, moveUp: false)
                          : null,
                      onEdit: canEditBase
                          ? () => _showChangeBaseSheet(context, step)
                          : null,
                      onRemove: canEditBase
                          ? () => _removeBaseStep(step.type)
                          : null,
                    );
                  });
                }(),
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
  final VoidCallback? onDelete;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const _StepTile({
    required this.step,
    required this.isLast,
    this.onDelete,
    this.onMoveUp,
    this.onMoveDown,
    this.onEdit,
    this.onRemove,
  });

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
          if (onMoveUp != null || onMoveDown != null || onDelete != null ||
              onEdit != null || onRemove != null)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onMoveUp != null || onMoveDown != null) ...[
                  SizedBox(
                    width: 28, height: 28,
                    child: IconButton(
                      icon: Icon(Icons.keyboard_arrow_up,
                          size: 20,
                          color: onMoveUp != null
                              ? AppColors.primary
                              : AppColors.divider),
                      padding: EdgeInsets.zero,
                      onPressed: onMoveUp,
                      tooltip: 'Monter',
                    ),
                  ),
                  SizedBox(
                    width: 28, height: 28,
                    child: IconButton(
                      icon: Icon(Icons.keyboard_arrow_down,
                          size: 20,
                          color: onMoveDown != null
                              ? AppColors.primary
                              : AppColors.divider),
                      padding: EdgeInsets.zero,
                      onPressed: onMoveDown,
                      tooltip: 'Descendre',
                    ),
                  ),
                ],
                if (onEdit != null)
                  SizedBox(
                    width: 28, height: 28,
                    child: IconButton(
                      icon: const Icon(Icons.edit,
                          size: 16, color: AppColors.primary),
                      padding: EdgeInsets.zero,
                      onPressed: onEdit,
                      tooltip: 'Modifier',
                    ),
                  ),
                if (onDelete != null || onRemove != null)
                  SizedBox(
                    width: 28, height: 28,
                    child: IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          size: 16, color: AppColors.error),
                      padding: EdgeInsets.zero,
                      onPressed: onDelete ?? onRemove,
                      tooltip: 'Supprimer',
                    ),
                  ),
              ],
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

// ─── Tile pour le bottom sheet "Envoyer à Tous" ───────────────────────────────

class _SendAllTile extends StatelessWidget {
  final IconData icon;
  final String name;
  final String role;
  final String phone;
  final String message;
  final VoidCallback onSend;

  const _SendAllTile({
    required this.icon,
    required this.name,
    required this.role,
    required this.phone,
    required this.message,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withOpacity(0.08),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
                Text(role,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
                Text(phone,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: onSend,
            icon: const Icon(Icons.send, size: 14),
            label: const Text('Envoyer', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
