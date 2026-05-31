import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
  RealColumn get baseLat => real().nullable()();
  RealColumn get baseLng => real().nullable()();
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
  // Passager AOM (null = invité externe)
  IntColumn get passengerId => integer().references(Passengers, #id).nullable()();
  // Invité externe : passengerId = null, guestName/guestPhone renseignés
  TextColumn get guestName => text().nullable()();
  TextColumn get guestPhone => text().nullable()();
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
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(passengers, passengers.baseLat);
            await m.addColumn(passengers, passengers.baseLng);
          }
          if (from < 3) {
            // Recréation de mission_passengers :
            // passengerId devient nullable + ajout guestName/guestPhone
            await customStatement('''
              CREATE TABLE mission_passengers_v3 (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                mission_id INTEGER NOT NULL REFERENCES missions(id),
                passenger_id INTEGER REFERENCES passengers(id),
                guest_name TEXT,
                guest_phone TEXT,
                pickup_location_id INTEGER REFERENCES known_locations(id),
                pickup_city TEXT,
                pickup_order INTEGER NOT NULL DEFAULT 0,
                whatsapp_status TEXT NOT NULL DEFAULT 'NON_ENVOYE'
              )
            ''');
            await customStatement('''
              INSERT INTO mission_passengers_v3
                (id, mission_id, passenger_id, guest_name, guest_phone,
                 pickup_location_id, pickup_city, pickup_order, whatsapp_status)
              SELECT id, mission_id, passenger_id, NULL, NULL,
                     pickup_location_id, pickup_city, pickup_order, whatsapp_status
              FROM mission_passengers
            ''');
            await customStatement('DROP TABLE mission_passengers');
            await customStatement(
                'ALTER TABLE mission_passengers_v3 RENAME TO mission_passengers');
          }
        },
      );
}

QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'aom_ground_transport.sqlite'));
    // NativeDatabase.createInBackground peut échouer silencieusement
    // en mode release (AOT) avec Drift 2.33+ → on utilise NativeDatabase direct
    return NativeDatabase(file);
  });
}
