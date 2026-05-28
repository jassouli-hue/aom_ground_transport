import '../database/app_database.dart';
import '../models/mission_model.dart';
import '../models/mission_step_model.dart';

class MissionRepository {
  final AppDatabase _db;

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

  Future<void> updateStatus(int id, String status) =>
      _db.missionDao.updateStatus(id, status);

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
      final passenger = await _db.passengerDao.getById(mp.passengerId);
      if (passenger == null) continue;
      KnownLocation? pickupLoc;
      if (mp.pickupLocationId != null) {
        pickupLoc = await _db.knownLocationDao.getById(mp.pickupLocationId!);
      }
      passengers.add(MissionPassengerEntry(
        passengerId: passenger.id,
        passengerName: passenger.name,
        passengerRole: passenger.role,
        passengerPhone: passenger.phone,
        pickupCity: mp.pickupCity ?? passenger.baseCity,
        pickupOrder: mp.pickupOrder,
        pickupLat: pickupLoc?.latitude,
        pickupLng: pickupLoc?.longitude,
        whatsappStatus: mp.whatsappStatus,
        missionPassengerId: mp.id,
      ));
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
