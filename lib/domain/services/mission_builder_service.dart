import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import '../../data/models/known_location_model.dart';
import '../../data/models/mission_model.dart';
import '../../data/models/passenger_model.dart';
import 'distance_service.dart';
import 'osrm_routing_service.dart';
import 'notification_service.dart';
import 'google_maps_link_service.dart';

class PassengerPickup {
  final PassengerModel? passenger;  // null = invité externe
  final String? guestName;          // pour les invités
  final String? guestPhone;         // pour les invités (optionnel)
  final KnownLocationModel? pickupLocation;
  final String pickupCity;
  final double? pickupLat;
  final double? pickupLng;

  bool get isGuest => passenger == null;
  String get displayName =>
      isGuest ? (guestName ?? 'Invité') : passenger!.name;

  const PassengerPickup({
    this.passenger,
    this.guestName,
    this.guestPhone,
    this.pickupLocation,
    required this.pickupCity,
    this.pickupLat,
    this.pickupLng,
  });
}

class MissionBuildRequest {
  final int driverId;
  final int vehicleId;
  final KnownLocationModel destination;
  final DateTime scheduledAt;
  final String type; // DEPART | ARRIVEE
  final bool returnToBase;
  final KnownLocationModel baseLocation;
  final List<PassengerPickup> passengers;
  final double averageSpeedKmh;
  final String? notes;
  final String? customReference;

  const MissionBuildRequest({
    required this.driverId,
    required this.vehicleId,
    required this.destination,
    required this.scheduledAt,
    required this.type,
    required this.returnToBase,
    required this.baseLocation,
    required this.passengers,
    this.averageSpeedKmh = 80.0,
    this.notes,
    this.customReference,
  });
}

class MissionBuilderService {
  final AppDatabase _db;
  final OsrmRoutingService _routingService;
  final GoogleMapsLinkService _mapsService;
  final NotificationService _notifService;

  MissionBuilderService(
      this._db, this._routingService, this._mapsService, this._notifService);

  Future<int> buildAndSave(MissionBuildRequest req) async {
    final reference = (req.customReference != null && req.customReference!.trim().isNotEmpty)
        ? req.customReference!.trim()
        : _generateReference();

    // Build waypoints list — commence par la base de départ
    final waypoints = <WaypointCoord>[];

    // Base de départ (toujours incluse comme premier waypoint)
    waypoints.add(WaypointCoord(
      name: req.baseLocation.name,
      lat: req.baseLocation.latitude,
      lng: req.baseLocation.longitude,
    ));

    // Pickup stops — seuls les passagers avec GPS contribuent au routage OSRM
    for (final p in req.passengers) {
      if (p.pickupLat != null && p.pickupLng != null) {
        waypoints.add(WaypointCoord(
          name: '${p.displayName} — ${p.pickupCity}',
          lat: p.pickupLat!,
          lng: p.pickupLng!,
        ));
      }
    }

    // Destination
    waypoints.add(WaypointCoord(
      name: req.destination.name,
      lat: req.destination.latitude,
      lng: req.destination.longitude,
    ));

    // Retour base
    if (req.returnToBase) {
      waypoints.add(WaypointCoord(
        name: req.baseLocation.name,
        lat: req.baseLocation.latitude,
        lng: req.baseLocation.longitude,
      ));
    }

    // Calcul distances réelles via OSRM (fallback Haversine si hors ligne)
    final distResult = await _routingService.calculate(
      waypoints,
      averageSpeedKmh: req.averageSpeedKmh,
    );
    final mapsUrl = _mapsService.buildDirectionsUrl(waypoints);

    // Insert mission
    final missionId = await _db.missionDao.insertMission(MissionsCompanion(
      reference: Value(reference),
      type: Value(req.type),
      driverId: Value(req.driverId),
      vehicleId: Value(req.vehicleId),
      destinationId: Value(req.destination.id),
      scheduledAt: Value(req.scheduledAt),
      totalDistanceKm: Value(distResult.totalKm),
      estimatedDurationMin: Value(distResult.estimatedMinutes),
      googleMapsUrl: Value(mapsUrl),
      returnToBase: Value(req.returnToBase),
      notes: Value(req.notes),
    ));

    // Insert mission passengers (équipage AOM ou invités)
    for (int i = 0; i < req.passengers.length; i++) {
      final pp = req.passengers[i];
      await _db.missionPassengerDao.insertMissionPassenger(
        MissionPassengersCompanion(
          missionId: Value(missionId),
          passengerId: pp.isGuest ? const Value.absent() : Value(pp.passenger!.id),
          guestName: pp.isGuest ? Value(pp.guestName) : const Value.absent(),
          guestPhone: pp.isGuest ? Value(pp.guestPhone) : const Value.absent(),
          pickupCity: Value(pp.pickupCity),
          pickupOrder: Value(i),
          pickupLocationId: pp.pickupLocation != null
              ? Value(pp.pickupLocation!.id)
              : const Value.absent(),
        ),
      );
    }

    // Insert steps : DEPART_BASE + passagers (GPS ou non) + destination + (retour base)
    int order = 1;
    // legs[0] = BASE→GPS_1, legs[1] = GPS_1→GPS_2, ..., legs[n] = last_GPS→DEST
    int gpIdx = 0;

    // Étape DEPART_BASE (toujours présente)
    await _db.missionStepDao.insertStep(MissionStepsCompanion(
      missionId: Value(missionId),
      stepOrder: Value(order++),
      type: const Value('DEPART_BASE'),
      locationName: Value(req.baseLocation.name),
      city: Value(req.baseLocation.city),
      latitude: Value(req.baseLocation.latitude),
      longitude: Value(req.baseLocation.longitude),
      distanceFromPrevKm: const Value(0),
      durationFromPrevMin: const Value(0),
    ));

    for (final p in req.passengers) {
      final hasGps = p.pickupLat != null && p.pickupLng != null;
      final leg = hasGps && gpIdx < distResult.legs.length ? distResult.legs[gpIdx] : null;
      if (hasGps) gpIdx++;

      await _db.missionStepDao.insertStep(MissionStepsCompanion(
        missionId: Value(missionId),
        stepOrder: Value(order++),
        type: const Value('PICKUP'),
        locationName: Value('${p.displayName} — ${p.pickupCity}'),
        city: Value(p.pickupCity),
        latitude: hasGps ? Value(p.pickupLat) : const Value.absent(),
        longitude: hasGps ? Value(p.pickupLng) : const Value.absent(),
        distanceFromPrevKm: leg != null ? Value(leg.distanceKm) : const Value.absent(),
        durationFromPrevMin: leg != null ? Value(leg.durationMin) : const Value.absent(),
      ));
    }

    // Destination
    final destLeg = gpIdx < distResult.legs.length ? distResult.legs[gpIdx] : null;
    await _db.missionStepDao.insertStep(MissionStepsCompanion(
      missionId: Value(missionId),
      stepOrder: Value(order++),
      type: const Value('DESTINATION'),
      locationName: Value(req.destination.name),
      city: Value(req.destination.city),
      latitude: Value(req.destination.latitude),
      longitude: Value(req.destination.longitude),
      distanceFromPrevKm: destLeg != null ? Value(destLeg.distanceKm) : const Value.absent(),
      durationFromPrevMin: destLeg != null ? Value(destLeg.durationMin) : const Value.absent(),
    ));

    // Retour base
    if (req.returnToBase) {
      final baseLeg = gpIdx + 1 < distResult.legs.length ? distResult.legs[gpIdx + 1] : null;
      await _db.missionStepDao.insertStep(MissionStepsCompanion(
        missionId: Value(missionId),
        stepOrder: Value(order++),
        type: const Value('RETOUR_BASE'),
        locationName: Value(req.baseLocation.name),
        city: Value(req.baseLocation.city),
        latitude: Value(req.baseLocation.latitude),
        longitude: Value(req.baseLocation.longitude),
        distanceFromPrevKm: baseLeg != null ? Value(baseLeg.distanceKm) : const Value.absent(),
        durationFromPrevMin: baseLeg != null ? Value(baseLeg.durationMin) : const Value.absent(),
      ));
    }

    // Planifier notification 15 min avant
    try {
      final created = await _db.missionDao.getById(missionId);
      if (created != null) {
        final driver = await _db.driverDao.getById(created.driverId);
        final vehicle = await _db.vehicleDao.getById(created.vehicleId);
        final dest = await _db.knownLocationDao.getById(created.destinationId);
        if (driver != null && vehicle != null && dest != null) {
          await _notifService.scheduleMissionReminder(_buildSimpleModel(
            mission: created,
            driverName: driver.name,
            driverPhone: driver.phone,
            vehicleBrand: vehicle.brand,
            vehiclePlate: vehicle.plateNumber,
            destinationName: dest.name,
          ));
        }
      }
    } catch (e) {
      // Notification non bloquante
    }

    return missionId;
  }

  Future<void> rebuildAndUpdate(int missionId, MissionBuildRequest req) async {
    // Delete existing steps and passengers
    await _db.missionStepDao.deleteByMission(missionId);
    await _db.missionPassengerDao.deleteByMission(missionId);

    // Rebuild waypoints — commence par la base de départ
    final waypoints = <WaypointCoord>[];

    waypoints.add(WaypointCoord(
      name: req.baseLocation.name,
      lat: req.baseLocation.latitude,
      lng: req.baseLocation.longitude,
    ));

    for (final p in req.passengers) {
      if (p.pickupLat != null && p.pickupLng != null) {
        waypoints.add(WaypointCoord(
          name: '${p.displayName} — ${p.pickupCity}',
          lat: p.pickupLat!,
          lng: p.pickupLng!,
        ));
      }
    }

    waypoints.add(WaypointCoord(
      name: req.destination.name,
      lat: req.destination.latitude,
      lng: req.destination.longitude,
    ));

    if (req.returnToBase) {
      waypoints.add(WaypointCoord(
        name: req.baseLocation.name,
        lat: req.baseLocation.latitude,
        lng: req.baseLocation.longitude,
      ));
    }

    final distResult = await _routingService.calculate(waypoints, averageSpeedKmh: req.averageSpeedKmh);
    final mapsUrl = _mapsService.buildDirectionsUrl(waypoints);

    // Resolve reference: custom if provided, else keep existing
    final existingMission = await _db.missionDao.getById(missionId);
    final resolvedRef = (req.customReference != null && req.customReference!.trim().isNotEmpty)
        ? req.customReference!.trim()
        : (existingMission?.reference ?? _generateReference());

    // Update mission header
    await _db.missionDao.updateMission(MissionsCompanion(
      id: Value(missionId),
      reference: Value(resolvedRef),
      type: Value(req.type),
      driverId: Value(req.driverId),
      vehicleId: Value(req.vehicleId),
      destinationId: Value(req.destination.id),
      scheduledAt: Value(req.scheduledAt),
      totalDistanceKm: Value(distResult.totalKm),
      estimatedDurationMin: Value(distResult.estimatedMinutes),
      googleMapsUrl: Value(mapsUrl),
      returnToBase: Value(req.returnToBase),
      notes: Value(req.notes),
      updatedAt: Value(DateTime.now()),
    ));

    // Re-insert passengers
    for (int i = 0; i < req.passengers.length; i++) {
      final pp = req.passengers[i];
      await _db.missionPassengerDao.insertMissionPassenger(
        MissionPassengersCompanion(
          missionId: Value(missionId),
          passengerId: pp.isGuest ? const Value.absent() : Value(pp.passenger!.id),
          guestName: pp.isGuest ? Value(pp.guestName) : const Value.absent(),
          guestPhone: pp.isGuest ? Value(pp.guestPhone) : const Value.absent(),
          pickupCity: Value(pp.pickupCity),
          pickupOrder: Value(i),
          pickupLocationId: pp.pickupLocation != null
              ? Value(pp.pickupLocation!.id)
              : const Value.absent(),
        ),
      );
    }

    // Re-insert steps : même logique que buildAndSave (avec DEPART_BASE)
    int order = 1;
    int gpIdx = 0;

    // Étape DEPART_BASE
    await _db.missionStepDao.insertStep(MissionStepsCompanion(
      missionId: Value(missionId),
      stepOrder: Value(order++),
      type: const Value('DEPART_BASE'),
      locationName: Value(req.baseLocation.name),
      city: Value(req.baseLocation.city),
      latitude: Value(req.baseLocation.latitude),
      longitude: Value(req.baseLocation.longitude),
      distanceFromPrevKm: const Value(0),
      durationFromPrevMin: const Value(0),
    ));

    for (final p in req.passengers) {
      final hasGps = p.pickupLat != null && p.pickupLng != null;
      final leg = hasGps && gpIdx < distResult.legs.length ? distResult.legs[gpIdx] : null;
      if (hasGps) gpIdx++;

      await _db.missionStepDao.insertStep(MissionStepsCompanion(
        missionId: Value(missionId),
        stepOrder: Value(order++),
        type: const Value('PICKUP'),
        locationName: Value('${p.displayName} — ${p.pickupCity}'),
        city: Value(p.pickupCity),
        latitude: hasGps ? Value(p.pickupLat) : const Value.absent(),
        longitude: hasGps ? Value(p.pickupLng) : const Value.absent(),
        distanceFromPrevKm: leg != null ? Value(leg.distanceKm) : const Value.absent(),
        durationFromPrevMin: leg != null ? Value(leg.durationMin) : const Value.absent(),
      ));
    }

    final destLeg = gpIdx < distResult.legs.length ? distResult.legs[gpIdx] : null;
    await _db.missionStepDao.insertStep(MissionStepsCompanion(
      missionId: Value(missionId),
      stepOrder: Value(order++),
      type: const Value('DESTINATION'),
      locationName: Value(req.destination.name),
      city: Value(req.destination.city),
      latitude: Value(req.destination.latitude),
      longitude: Value(req.destination.longitude),
      distanceFromPrevKm: destLeg != null ? Value(destLeg.distanceKm) : const Value.absent(),
      durationFromPrevMin: destLeg != null ? Value(destLeg.durationMin) : const Value.absent(),
    ));

    if (req.returnToBase) {
      final baseLeg = gpIdx + 1 < distResult.legs.length ? distResult.legs[gpIdx + 1] : null;
      await _db.missionStepDao.insertStep(MissionStepsCompanion(
        missionId: Value(missionId),
        stepOrder: Value(order++),
        type: const Value('RETOUR_BASE'),
        locationName: Value(req.baseLocation.name),
        city: Value(req.baseLocation.city),
        latitude: Value(req.baseLocation.latitude),
        longitude: Value(req.baseLocation.longitude),
        distanceFromPrevKm: baseLeg != null ? Value(baseLeg.distanceKm) : const Value.absent(),
        durationFromPrevMin: baseLeg != null ? Value(baseLeg.durationMin) : const Value.absent(),
      ));
    }

    // Replanifier la notification 15 min avant (après mise à jour)
    try {
      final driver = await _db.driverDao.getById(req.driverId);
      final vehicle = await _db.vehicleDao.getById(req.vehicleId);
      if (driver != null && vehicle != null) {
        await _notifService.scheduleMissionReminder(_buildSimpleModel(
          mission: (await _db.missionDao.getById(missionId))!,
          driverName: driver.name,
          driverPhone: driver.phone,
          vehicleBrand: vehicle.brand,
          vehiclePlate: vehicle.plateNumber,
          destinationName: req.destination.name,
        ));
      }
    } catch (_) {}
  }

  // Helper léger pour créer un MissionModel minimal pour les notifications
  MissionModel _buildSimpleModel({
    required Mission mission,
    required String driverName,
    required String driverPhone,
    required String vehicleBrand,
    required String vehiclePlate,
    required String destinationName,
  }) {
    return MissionModel(
      id: mission.id,
      reference: mission.reference,
      type: mission.type,
      driverId: mission.driverId,
      driverName: driverName,
      driverPhone: driverPhone,
      vehicleId: mission.vehicleId,
      vehicleBrand: vehicleBrand,
      vehiclePlate: vehiclePlate,
      destinationId: mission.destinationId,
      destinationName: destinationName,
      destinationCity: '',
      scheduledAt: mission.scheduledAt,
      status: mission.status,
      totalDistanceKm: mission.totalDistanceKm,
      estimatedDurationMin: mission.estimatedDurationMin,
      googleMapsUrl: mission.googleMapsUrl,
      returnToBase: mission.returnToBase,
      notes: mission.notes,
      createdAt: mission.createdAt,
      passengers: [],
      steps: [],
      driverWhatsappStatus: 'NON_ENVOYE',
    );
  }

  String _generateReference() {
    final now = DateTime.now();
    final seq = now.millisecondsSinceEpoch % 1000;
    return 'AOM-${now.year}-${seq.toString().padLeft(3, '0')}';
  }
}
