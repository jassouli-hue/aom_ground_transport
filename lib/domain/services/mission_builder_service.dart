import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import '../../data/models/known_location_model.dart';
import '../../data/models/passenger_model.dart';
import 'distance_service.dart';
import 'google_maps_link_service.dart';

class PassengerPickup {
  final PassengerModel passenger;
  final KnownLocationModel? pickupLocation;
  final String pickupCity;
  final double? pickupLat;
  final double? pickupLng;

  const PassengerPickup({
    required this.passenger,
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
  });
}

class MissionBuilderService {
  final AppDatabase _db;
  final DistanceService _distanceService;
  final GoogleMapsLinkService _mapsService;

  MissionBuilderService(this._db, this._distanceService, this._mapsService);

  Future<int> buildAndSave(MissionBuildRequest req) async {
    final reference = _generateReference();

    // Build waypoints list
    final waypoints = <WaypointCoord>[];

    // Start: base
    waypoints.add(WaypointCoord(
      name: req.baseLocation.name,
      lat: req.baseLocation.latitude,
      lng: req.baseLocation.longitude,
    ));

    // Pickup stops
    for (final p in req.passengers) {
      if (p.pickupLat != null && p.pickupLng != null) {
        waypoints.add(WaypointCoord(
          name: '${p.passenger.name} — ${p.pickupCity}',
          lat: p.pickupLat!,
          lng: p.pickupLng!,
        ));
      } else {
        waypoints.add(WaypointCoord(
          name: p.pickupCity,
          lat: req.baseLocation.latitude,
          lng: req.baseLocation.longitude,
        ));
      }
    }

    // Destination
    waypoints.add(WaypointCoord(
      name: req.destination.name,
      lat: req.destination.latitude,
      lng: req.destination.longitude,
    ));

    // Return to base
    if (req.returnToBase) {
      waypoints.add(WaypointCoord(
        name: req.baseLocation.name,
        lat: req.baseLocation.latitude,
        lng: req.baseLocation.longitude,
      ));
    }

    final distResult = _distanceService.calculate(
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

    // Insert mission passengers
    for (int i = 0; i < req.passengers.length; i++) {
      final pp = req.passengers[i];
      await _db.missionPassengerDao.insertMissionPassenger(
        MissionPassengersCompanion(
          missionId: Value(missionId),
          passengerId: Value(pp.passenger.id),
          pickupCity: Value(pp.pickupCity),
          pickupOrder: Value(i),
          pickupLocationId: pp.pickupLocation != null
              ? Value(pp.pickupLocation!.id)
              : const Value.absent(),
        ),
      );
    }

    // Insert steps
    int order = 1;
    for (int i = 0; i < waypoints.length; i++) {
      final wp = waypoints[i];
      String stepType;
      if (i == 0) {
        stepType = 'DEPART_BASE';
      } else if (i == waypoints.length - 1 && req.returnToBase) {
        stepType = 'RETOUR_BASE';
      } else if (i == waypoints.length - (req.returnToBase ? 2 : 1)) {
        stepType = 'DESTINATION';
      } else {
        stepType = 'PICKUP';
      }

      final leg = i > 0 && i <= distResult.legs.length
          ? distResult.legs[i - 1]
          : null;

      await _db.missionStepDao.insertStep(MissionStepsCompanion(
        missionId: Value(missionId),
        stepOrder: Value(order++),
        type: Value(stepType),
        locationName: Value(wp.name),
        city: Value(wp.name.split('—').last.trim()),
        latitude: Value(wp.lat),
        longitude: Value(wp.lng),
        distanceFromPrevKm: leg != null ? Value(leg.distanceKm) : const Value.absent(),
        durationFromPrevMin: leg != null ? Value(leg.durationMin) : const Value.absent(),
      ));
    }

    return missionId;
  }

  String _generateReference() {
    final now = DateTime.now();
    final seq = now.millisecondsSinceEpoch % 1000;
    return 'AOM-${now.year}-${seq.toString().padLeft(3, '0')}';
  }
}
