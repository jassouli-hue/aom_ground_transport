import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/driver_dao.dart';
import 'daos/vehicle_dao.dart';
import 'daos/passenger_dao.dart';
import 'daos/known_location_dao.dart';
import 'daos/mission_dao.dart';
import 'daos/mission_passenger_dao.dart';
import 'daos/mission_step_dao.dart';
import 'daos/notification_log_dao.dart';
import 'daos/settings_dao.dart';

part 'app_database.g.dart';

// ─── Tables ───────────────────────────────────────────────────────────────────

class Drivers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().withLength(min: 8, max: 20)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Vehicles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get brand => text().withLength(min: 1, max: 100)();
  TextColumn get plateNumber => text().withLength(min: 1, max: 20)();
  IntColumn get capacity => integer().withDefault(const Constant(4))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Passengers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get role => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().withLength(min: 8, max: 20)();
  TextColumn get baseCity => text().withLength(min: 1, max: 100)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class KnownLocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 150)();
  TextColumn get shortCode => text().withLength(min: 2, max: 10)();
  TextColumn get city => text().withLength(min: 1, max: 100)();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  BoolColumn get isAirport => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class Missions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get reference => text().withLength(min: 1, max: 50)();
  TextColumn get type => text().withLength(min: 1, max: 20)(); // 'DEPART' | 'ARRIVEE'
  IntColumn get driverId => integer().references(Drivers, #id)();
  IntColumn get vehicleId => integer().references(Vehicles, #id)();
  IntColumn get destinationId => integer().references(KnownLocations, #id)();
  DateTimeColumn get scheduledAt => dateTime()();
  TextColumn get status => text().withDefault(const Constant('PLANIFIEE'))();
  // PLANIFIEE | EN_COURS | TERMINEE | ANNULEE
  RealColumn get totalDistanceKm => real().nullable()();
  IntColumn get estimatedDurationMin => integer().nullable()();
  TextColumn get googleMapsUrl => text().nullable()();
  BoolColumn get returnToBase => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class MissionPassengers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get missionId => integer().references(Missions, #id)();
  IntColumn get passengerId => integer().references(Passengers, #id)();
  IntColumn get pickupLocationId => integer().references(KnownLocations, #id).nullable()();
  TextColumn get pickupCity => text().nullable()();
  IntColumn get pickupOrder => integer().withDefault(const Constant(0))();
  TextColumn get whatsappStatus => text().withDefault(const Constant('NON_ENVOYE'))();
  // NON_ENVOYE | OUVERT | MARQUE_ENVOYE
}

class MissionSteps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get missionId => integer().references(Missions, #id)();
  IntColumn get stepOrder => integer()();
  TextColumn get type => text()(); // DEPART_BASE | PICKUP | DESTINATION | RETOUR_BASE
  TextColumn get locationName => text()();
  TextColumn get city => text()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  RealColumn get distanceFromPrevKm => real().nullable()();
  IntColumn get durationFromPrevMin => integer().nullable()();
}

class NotificationLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get missionId => integer().references(Missions, #id)();
  TextColumn get recipientType => text()(); // CHAUFFEUR | PASSAGER
  IntColumn get recipientId => integer()();
  TextColumn get recipientName => text()();
  TextColumn get recipientPhone => text()();
  TextColumn get messageContent => text()();
  TextColumn get whatsappUrl => text()();
  TextColumn get status => text().withDefault(const Constant('GENERE'))();
  // GENERE | OUVERT_WHATSAPP | MARQUE_ENVOYE
  DateTimeColumn get generatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get openedAt => dateTime().nullable()();
  DateTimeColumn get markedSentAt => dateTime().nullable()();
}

class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ─── Database ─────────────────────────────────────────────────────────────────

@DriftDatabase(
  tables: [
    Drivers,
    Vehicles,
    Passengers,
    KnownLocations,
    Missions,
    MissionPassengers,
    MissionSteps,
    NotificationLogs,
    Settings,
  ],
  daos: [
    DriverDao,
    VehicleDao,
    PassengerDao,
    KnownLocationDao,
    MissionDao,
    MissionPassengerDao,
    MissionStepDao,
    NotificationLogDao,
    SettingsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
      );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'aom_ground_transport');
}
