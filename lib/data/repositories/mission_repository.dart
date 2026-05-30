import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/mission_model.dart';
import '../models/mission_step_model.dart';
import '../../domain/services/notification_service.dart';
import '../../domain/services/osrm_routing_service.dart';
import '../../domain/services/distance_service.dart';
import '../../domain/services/google_maps_link_service.dart';

class MissionRepository {
  final AppDatabase _db;
  final OsrmRoutingService _routing = OsrmRoutingService();
  final GoogleMapsLinkService _mapsService = GoogleMapsLinkService();

  MissionRepository(this._db);

  Stream<List<MissionModel>> watchAll() {
    return _db.missionDao.watchAll().asyncMap((missions) async {
      final result = <MissionModel>[];
      for (final m in missions) {
        final model = await _hydrate(m);
        result.add(model);
      }
      return result;
    });
  }

  Future<List<MissionModel>> getAll() async {
    final missions = await _db.missionDao.getAll();
    final result = <MissionModel>[];
    for (final m in missions) {
      result.add(await _hydrate(m));
    }
    return result;
  }

  Future<MissionModel?> getById(int id) async {
    final m = await _db.missionDao.getById(id);
    return m != null ? _hydrate(m) : null;
  }

  Future<void> updateStatus(int id, String status) async {
    await _db.missionDao.updateStatus(id, status);
    // Annuler le rappel si mission annulée ou terminée
    if (status == 'ANNULEE' || status == 'TERMINEE') {
      try { await NotificationService().cancelReminder(id); } catch (_) {}
    }
  }

  Future<void> updateMissionHeader(int id, {
    required int driverId,
    required int vehicleId,
    required int destinationId,
    required DateTime scheduledAt,
    required String type,
    required bool returnToBase,
    String? notes,
  }) =>
      _db.missionDao.updateMission(MissionsCompanion(
        id: Value(id),
        driverId: Value(driverId),
        vehicleId: Value(vehicleId),
        destinationId: Value(destinationId),
        scheduledAt: Value(scheduledAt),
        type: Value(type),
        returnToBase: Value(returnToBase),
        notes: Value(notes),
        updatedAt: Value(DateTime.now()),
      ));

  Future<void> deleteMission(int id) async {
    // Annuler le rappel de notification
    try { await NotificationService().cancelReminder(id); } catch (_) {}
    // Cascade : supprimer passagers, étapes et logs liés
    await _db.notificationLogDao.getByMission(id); // pre-check
    await (_db.delete(_db.notificationLogs)
          ..where((l) => l.missionId.equals(id)))
        .go();
    await _db.missionStepDao.deleteByMission(id);
    await _db.missionPassengerDao.deleteByMission(id);
    await _db.missionDao.deleteMission(id);
  }

  /// Ajoute une étape PICKUP à la position [insertAtIndex] et recalcule les distances.
  /// Les positions valides sont après DEPART_BASE et avant RETOUR_BASE.
  Future<void> addPickupStep({
    required int missionId,
    required String locationName,
    required String city,
    double? lat,
    double? lng,
    int? insertAtIndex,
  }) async {
    final steps = await _db.missionStepDao.getByMission(missionId);
    if (steps.isEmpty) return;

    // Bornes : après DEPART_BASE, avant RETOUR_BASE
    final departIdx = steps.indexWhere((s) => s.type == 'DEPART_BASE');
    final minIndex = departIdx >= 0 ? departIdx + 1 : 0;
    final retourIdx = steps.indexWhere((s) => s.type == 'RETOUR_BASE');
    final maxIndex = retourIdx >= 0 ? retourIdx : steps.length;
    final destIndex = steps.indexWhere((s) => s.type == 'DESTINATION');

    final targetIndex = insertAtIndex != null
        ? insertAtIndex.clamp(minIndex, maxIndex)
        : (destIndex >= minIndex ? destIndex : maxIndex);

    // Sauvegarder le stepOrder cible avant décalage
    final targetOrder = targetIndex < steps.length
        ? steps[targetIndex].stepOrder
        : (steps.isNotEmpty ? steps.last.stepOrder + 1 : 1);

    // Décaler tous les steps à partir de targetIndex
    for (int i = targetIndex; i < steps.length; i++) {
      await _db.missionStepDao.updateStep(MissionStepsCompanion(
        id: Value(steps[i].id),
        missionId: Value(steps[i].missionId),
        stepOrder: Value(steps[i].stepOrder + 1),
        type: Value(steps[i].type),
        locationName: Value(steps[i].locationName),
        city: Value(steps[i].city),
        latitude: Value(steps[i].latitude),
        longitude: Value(steps[i].longitude),
        distanceFromPrevKm: Value(steps[i].distanceFromPrevKm),
        durationFromPrevMin: Value(steps[i].durationFromPrevMin),
      ));
    }

    // Insérer la nouvelle étape à la position cible
    await _db.missionStepDao.insertStep(MissionStepsCompanion(
      missionId: Value(missionId),
      stepOrder: Value(targetOrder),
      type: const Value('PICKUP'),
      locationName: Value(locationName),
      city: Value(city),
      latitude: Value(lat),
      longitude: Value(lng),
    ));

    // Renuméroter et recalculer toutes les distances
    await _renumberAndRecalc(missionId);
  }

  /// Déplace une étape PICKUP d'une position (peut traverser DESTINATION).
  /// DEPART_BASE et RETOUR_BASE restent toujours aux extrémités.
  Future<void> moveStep({
    required int stepId,
    required int missionId,
    required bool moveUp,
  }) async {
    final steps = await _db.missionStepDao.getByMission(missionId);
    const fixedTypes = {'DEPART_BASE', 'RETOUR_BASE'};

    final idx = steps.indexWhere((s) => s.id == stepId);
    if (idx < 0) return;

    final swapIdx = moveUp ? idx - 1 : idx + 1;
    if (swapIdx < 0 || swapIdx >= steps.length) return;
    if (fixedTypes.contains(steps[swapIdx].type)) return;

    final stepA = steps[idx];
    final stepB = steps[swapIdx];

    await _db.missionStepDao.updateStep(MissionStepsCompanion(
      id: Value(stepA.id),
      missionId: Value(stepA.missionId),
      stepOrder: Value(stepB.stepOrder),
      type: Value(stepA.type),
      locationName: Value(stepA.locationName),
      city: Value(stepA.city),
      latitude: Value(stepA.latitude),
      longitude: Value(stepA.longitude),
      distanceFromPrevKm: Value(stepA.distanceFromPrevKm),
      durationFromPrevMin: Value(stepA.durationFromPrevMin),
    ));
    await _db.missionStepDao.updateStep(MissionStepsCompanion(
      id: Value(stepB.id),
      missionId: Value(stepB.missionId),
      stepOrder: Value(stepA.stepOrder),
      type: Value(stepB.type),
      locationName: Value(stepB.locationName),
      city: Value(stepB.city),
      latitude: Value(stepB.latitude),
      longitude: Value(stepB.longitude),
      distanceFromPrevKm: Value(stepB.distanceFromPrevKm),
      durationFromPrevMin: Value(stepB.durationFromPrevMin),
    ));

    await _renumberAndRecalc(missionId);
  }

  /// Ajoute ou remplace l'étape base (DEPART_BASE ou RETOUR_BASE).
  Future<void> setBaseStep({
    required int missionId,
    required String type,
    required String locationName,
    required String city,
    required double lat,
    required double lng,
  }) async {
    final steps = await _db.missionStepDao.getByMission(missionId);
    final existing = steps.where((s) => s.type == type).firstOrNull;

    if (existing != null) {
      await _db.missionStepDao.updateStep(MissionStepsCompanion(
        id: Value(existing.id),
        missionId: Value(existing.missionId),
        stepOrder: Value(existing.stepOrder),
        type: Value(type),
        locationName: Value(locationName),
        city: Value(city),
        latitude: Value(lat),
        longitude: Value(lng),
        distanceFromPrevKm: Value(existing.distanceFromPrevKm),
        durationFromPrevMin: Value(existing.durationFromPrevMin),
      ));
    } else {
      if (type == 'DEPART_BASE') {
        // Insérer en première position — décaler tous les autres
        for (final s in steps) {
          await _db.missionStepDao.updateStep(MissionStepsCompanion(
            id: Value(s.id),
            missionId: Value(s.missionId),
            stepOrder: Value(s.stepOrder + 1),
            type: Value(s.type),
            locationName: Value(s.locationName),
            city: Value(s.city),
            latitude: Value(s.latitude),
            longitude: Value(s.longitude),
            distanceFromPrevKm: Value(s.distanceFromPrevKm),
            durationFromPrevMin: Value(s.durationFromPrevMin),
          ));
        }
        await _db.missionStepDao.insertStep(MissionStepsCompanion(
          missionId: Value(missionId),
          stepOrder: const Value(1),
          type: Value(type),
          locationName: Value(locationName),
          city: Value(city),
          latitude: Value(lat),
          longitude: Value(lng),
          distanceFromPrevKm: const Value(0),
          durationFromPrevMin: const Value(0),
        ));
      } else {
        // RETOUR_BASE — insérer en dernière position
        final lastOrder = steps.isNotEmpty ? steps.last.stepOrder + 1 : 1;
        await _db.missionStepDao.insertStep(MissionStepsCompanion(
          missionId: Value(missionId),
          stepOrder: Value(lastOrder),
          type: Value(type),
          locationName: Value(locationName),
          city: Value(city),
          latitude: Value(lat),
          longitude: Value(lng),
        ));
      }
    }

    await _renumberAndRecalc(missionId);
  }

  /// Supprime l'étape base (DEPART_BASE ou RETOUR_BASE).
  Future<void> removeBaseStep({
    required int missionId,
    required String type,
  }) async {
    final steps = await _db.missionStepDao.getByMission(missionId);
    final step = steps.where((s) => s.type == type).firstOrNull;
    if (step == null) return;
    await _db.missionStepDao.deleteStep(step.id);
    await _renumberAndRecalc(missionId);
  }

  /// Supprime une étape PICKUP et recalcule la distance du tronçon restant.
  Future<void> removePickupStep(int stepId, int missionId) async {
    await _db.missionStepDao.deleteStep(stepId);
    // Renumeroter et recalculer
    await _renumberAndRecalc(missionId);
  }

  /// Recalcule toutes les distances/durées de la mission.
  Future<void> _renumberAndRecalc(int missionId) async {
    final steps = await _db.missionStepDao.getByMission(missionId);
    if (steps.length < 2) return;

    // Renuméroter stepOrder
    for (int i = 0; i < steps.length; i++) {
      await _db.missionStepDao.updateStep(MissionStepsCompanion(
        id: Value(steps[i].id),
        missionId: Value(steps[i].missionId),
        stepOrder: Value(i + 1),
        type: Value(steps[i].type),
        locationName: Value(steps[i].locationName),
        city: Value(steps[i].city),
        latitude: Value(steps[i].latitude),
        longitude: Value(steps[i].longitude),
        distanceFromPrevKm: const Value.absent(),
        durationFromPrevMin: const Value.absent(),
      ));
    }

    // Recalculer avec OSRM
    final waypoints = steps
        .where((s) => s.latitude != null && s.longitude != null)
        .map((s) => WaypointCoord(name: s.locationName, lat: s.latitude!, lng: s.longitude!))
        .toList();

    if (waypoints.length < 2) return;
    final distResult = await _routing.calculate(waypoints);
    final freshSteps = await _db.missionStepDao.getByMission(missionId);

    double total = 0;
    int totalMin = 0;
    for (int i = 1; i < freshSteps.length; i++) {
      if (i - 1 < distResult.legs.length) {
        final leg = distResult.legs[i - 1];
        total += leg.distanceKm;
        totalMin += leg.durationMin;
        await _db.missionStepDao.updateStep(MissionStepsCompanion(
          id: Value(freshSteps[i].id),
          missionId: Value(freshSteps[i].missionId),
          stepOrder: Value(freshSteps[i].stepOrder),
          type: Value(freshSteps[i].type),
          locationName: Value(freshSteps[i].locationName),
          city: Value(freshSteps[i].city),
          latitude: Value(freshSteps[i].latitude),
          longitude: Value(freshSteps[i].longitude),
          distanceFromPrevKm: Value(leg.distanceKm),
          durationFromPrevMin: Value(leg.durationMin),
        ));
      }
    }

    // Régénérer le lien Google Maps avec tous les stops
    final mapsUrl = _mapsService.buildDirectionsUrl(waypoints);

    // Mise à jour partielle (write = UPDATE SET, pas replace)
    await (_db.update(_db.missions)..where((m) => m.id.equals(missionId)))
        .write(MissionsCompanion(
      totalDistanceKm: Value(double.parse(total.toStringAsFixed(1))),
      estimatedDurationMin: Value(totalMin),
      googleMapsUrl: Value(mapsUrl),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> _recalcAdjacentLegs(int missionId, int newStepId) async {
    await _renumberAndRecalc(missionId);
  }

  Future<Map<String, int>> getCounts() async {
    return {
      'PLANIFIEE': await _db.missionDao.countByStatus('PLANIFIEE'),
      'EN_COURS': await _db.missionDao.countByStatus('EN_COURS'),
      'TERMINEE': await _db.missionDao.countByStatus('TERMINEE'),
    };
  }

  Future<MissionModel> _hydrate(Mission m) async {
    final driver = await _db.driverDao.getById(m.driverId);
    final vehicle = await _db.vehicleDao.getById(m.vehicleId);
    final destination = await _db.knownLocationDao.getById(m.destinationId);
    final mpRows = await _db.missionPassengerDao.getByMission(m.id);
    final stepRows = await _db.missionStepDao.getByMission(m.id);

    // Fetch driver WhatsApp log status
    final logs = await _db.notificationLogDao.getByMission(m.id);
    final driverLog = logs.where((l) => l.recipientType == 'CHAUFFEUR').toList();
    final driverWaStatus = driverLog.isNotEmpty
        ? driverLog.first.status
        : 'NON_ENVOYE';

    final passengers = <MissionPassengerEntry>[];
    for (final mp in mpRows) {
      KnownLocation? pickupLoc;
      if (mp.pickupLocationId != null) {
        pickupLoc = await _db.knownLocationDao.getById(mp.pickupLocationId!);
      }

      if (mp.passengerId == null) {
        // Invité externe
        final guestName = mp.guestName ?? 'Invité';
        passengers.add(MissionPassengerEntry(
          passengerId: null,
          passengerName: guestName,
          passengerRole: 'Invité',
          passengerPhone: mp.guestPhone ?? '',
          isGuest: true,
          guestName: guestName,
          guestPhone: mp.guestPhone,
          pickupCity: mp.pickupCity ?? '',
          pickupOrder: mp.pickupOrder,
          pickupLat: pickupLoc?.latitude,
          pickupLng: pickupLoc?.longitude,
          whatsappStatus: mp.whatsappStatus,
          missionPassengerId: mp.id,
        ));
      } else {
        // Passager AOM
        final passenger = await _db.passengerDao.getById(mp.passengerId!);
        if (passenger == null) continue;
        passengers.add(MissionPassengerEntry(
          passengerId: passenger.id,
          passengerName: passenger.name,
          passengerRole: passenger.role,
          passengerPhone: passenger.phone,
          isGuest: false,
          pickupCity: mp.pickupCity ?? passenger.baseCity,
          pickupOrder: mp.pickupOrder,
          pickupLat: pickupLoc?.latitude,
          pickupLng: pickupLoc?.longitude,
          whatsappStatus: mp.whatsappStatus,
          missionPassengerId: mp.id,
        ));
      }
    }

    final steps = stepRows.map((s) => MissionStepModel(
      id: s.id,
      missionId: s.missionId,
      stepOrder: s.stepOrder,
      type: s.type,
      locationName: s.locationName,
      city: s.city,
      latitude: s.latitude,
      longitude: s.longitude,
      distanceFromPrevKm: s.distanceFromPrevKm,
      durationFromPrevMin: s.durationFromPrevMin,
    )).toList();

    return MissionModel(
      id: m.id,
      reference: m.reference,
      type: m.type,
      driverId: m.driverId,
      driverName: driver?.name ?? '—',
      driverPhone: driver?.phone ?? '',
      vehicleId: m.vehicleId,
      vehicleBrand: vehicle?.brand ?? '—',
      vehiclePlate: vehicle?.plateNumber ?? '—',
      destinationId: m.destinationId,
      destinationName: destination?.name ?? '—',
      destinationCity: destination?.city ?? '—',
      scheduledAt: m.scheduledAt,
      status: m.status,
      totalDistanceKm: m.totalDistanceKm,
      estimatedDurationMin: m.estimatedDurationMin,
      googleMapsUrl: m.googleMapsUrl,
      returnToBase: m.returnToBase,
      notes: m.notes,
      createdAt: m.createdAt,
      passengers: passengers,
      steps: steps,
      driverWhatsappStatus: driverWaStatus,
    );
  }
}
