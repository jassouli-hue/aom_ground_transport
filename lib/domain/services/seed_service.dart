import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import '../../data/database/app_database.dart';

class SeedService {
  final AppDatabase _db;

  SeedService(this._db);

  Future<void> seedIfNeeded() async {
    final done = await _db.settingsDao.getValue('seed_done');
    if (done == 'true') return;
    await _runSeed();
  }

  Future<void> _runSeed() async {
    final raw = await rootBundle.loadString('assets/demo/seed_data.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;

    // Drivers
    for (final d in data['drivers'] as List) {
      await _db.driverDao.insertDriver(DriversCompanion(
        name: Value(d['name'] as String),
        phone: Value(d['phone'] as String),
      ));
    }

    // Vehicles
    for (final v in data['vehicles'] as List) {
      await _db.vehicleDao.insertVehicle(VehiclesCompanion(
        brand: Value(v['brand'] as String),
        plateNumber: Value(v['plateNumber'] as String),
        capacity: Value(v['capacity'] as int),
      ));
    }

    // Passengers
    for (final p in data['passengers'] as List) {
      await _db.passengerDao.insertPassenger(PassengersCompanion(
        name: Value(p['name'] as String),
        role: Value(p['role'] as String),
        phone: Value(p['phone'] as String),
        baseCity: Value(p['baseCity'] as String),
      ));
    }

    // Known locations
    for (final l in data['locations'] as List) {
      await _db.knownLocationDao.insertLocation(KnownLocationsCompanion(
        name: Value(l['name'] as String),
        shortCode: Value(l['shortCode'] as String),
        city: Value(l['city'] as String),
        latitude: Value((l['latitude'] as num).toDouble()),
        longitude: Value((l['longitude'] as num).toDouble()),
        isAirport: Value(l['isAirport'] as bool),
      ));
    }

    // Settings
    for (final s in data['settings'] as List) {
      await _db.settingsDao.setValue(s['key'] as String, s['value'] as String);
    }

    await _insertDemoMission();
  }

  Future<void> _insertStep(
    int missionId, int order, String type,
    String locationName, String city,
    double lat, double lng,
    double? distKm, int? durMin,
  ) async {
    await _db.missionStepDao.insertStep(MissionStepsCompanion(
      missionId: Value(missionId),
      stepOrder: Value(order),
      type: Value(type),
      locationName: Value(locationName),
      city: Value(city),
      latitude: Value(lat),
      longitude: Value(lng),
      distanceFromPrevKm: Value(distKm),
      durationFromPrevMin: Value(durMin),
    ));
  }

  Future<void> _insertDemoMission() async {
    // Mission GMMB demo: chauffeur Youssef (#1), Mercedes (#1), passagers 1-3
    final missionId = await _db.missionDao.insertMission(MissionsCompanion(
      reference: const Value('AOM-2024-001'),
      type: const Value('DEPART'),
      driverId: const Value(1),
      vehicleId: const Value(1),
      destinationId: const Value(3), // GMMB
      scheduledAt: Value(DateTime.now().add(const Duration(hours: 2))),
      status: const Value('PLANIFIEE'),
      totalDistanceKm: const Value(120.5),
      estimatedDurationMin: const Value(91),
      googleMapsUrl: const Value(
        'https://www.google.com/maps/dir/33.5731,-7.5898/34.0531,-6.7985/33.6886,-7.3828/33.5731,-7.5898/33.6595,-7.2201',
      ),
      returnToBase: const Value(true),
      notes: const Value('Mission de démonstration'),
    ));

    // Passagers avec leurs villes de pickup
    final pickups = [
      (1, 'Salé', 34.0531, -6.7985),       // Mr Fouad
      (2, 'Mohammedia', 33.6886, -7.3828),  // Mr Mehdi
      (3, 'Casablanca', 33.5731, -7.5898),  // Saida
    ];
    for (int i = 0; i < pickups.length; i++) {
      final (pId, city, lat, lng) = pickups[i];
      await _db.missionPassengerDao.insertMissionPassenger(
        MissionPassengersCompanion(
          missionId: Value(missionId),
          passengerId: Value(pId),
          pickupCity: Value(city),
          pickupLocationId: const Value.absent(),
          pickupOrder: Value(i),
        ),
      );
    }

    // Steps
    await _insertStep(missionId, 1, 'DEPART_BASE', 'Base AOM Casablanca',  'Casablanca', 33.5731, -7.5898,  null,  null);
    await _insertStep(missionId, 2, 'PICKUP',       'Salé Centre',          'Salé',       34.0531, -6.7985,  95.0,  71);
    await _insertStep(missionId, 3, 'PICKUP',       'Mohammedia Centre',    'Mohammedia', 33.6886, -7.3828,  75.0,  56);
    await _insertStep(missionId, 4, 'PICKUP',       'Casablanca Centre',    'Casablanca', 33.5731, -7.5898,  45.0,  34);
    await _insertStep(missionId, 5, 'DESTINATION',  'Aéroport GMMB',       'Benslimane', 33.6595, -7.2201,  55.0,  41);
    await _insertStep(missionId, 6, 'RETOUR_BASE',  'Base AOM Casablanca',  'Casablanca', 33.5731, -7.5898,  55.0,  41);
  }
}
