// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_dao.dart';

// ignore_for_file: type=lint
mixin _$MissionDaoMixin on DatabaseAccessor<AppDatabase> {
  $DriversTable get drivers => attachedDatabase.drivers;
  $VehiclesTable get vehicles => attachedDatabase.vehicles;
  $KnownLocationsTable get knownLocations => attachedDatabase.knownLocations;
  $MissionsTable get missions => attachedDatabase.missions;
  MissionDaoManager get managers => MissionDaoManager(this);
}

class MissionDaoManager {
  final _$MissionDaoMixin _db;
  MissionDaoManager(this._db);
  $$DriversTableTableManager get drivers =>
      $$DriversTableTableManager(_db.attachedDatabase, _db.drivers);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db.attachedDatabase, _db.vehicles);
  $$KnownLocationsTableTableManager get knownLocations =>
      $$KnownLocationsTableTableManager(
          _db.attachedDatabase, _db.knownLocations);
  $$MissionsTableTableManager get missions =>
      $$MissionsTableTableManager(_db.attachedDatabase, _db.missions);
}
