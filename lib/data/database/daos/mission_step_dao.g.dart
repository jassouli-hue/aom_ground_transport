// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_step_dao.dart';

// ignore_for_file: type=lint
mixin _$MissionStepDaoMixin on DatabaseAccessor<AppDatabase> {
  $DriversTable get drivers => attachedDatabase.drivers;
  $VehiclesTable get vehicles => attachedDatabase.vehicles;
  $KnownLocationsTable get knownLocations => attachedDatabase.knownLocations;
  $MissionsTable get missions => attachedDatabase.missions;
  $MissionStepsTable get missionSteps => attachedDatabase.missionSteps;
  MissionStepDaoManager get managers => MissionStepDaoManager(this);
}

class MissionStepDaoManager {
  final _$MissionStepDaoMixin _db;
  MissionStepDaoManager(this._db);
  $$DriversTableTableManager get drivers =>
      $$DriversTableTableManager(_db.attachedDatabase, _db.drivers);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db.attachedDatabase, _db.vehicles);
  $$KnownLocationsTableTableManager get knownLocations =>
      $$KnownLocationsTableTableManager(
          _db.attachedDatabase, _db.knownLocations);
  $$MissionsTableTableManager get missions =>
      $$MissionsTableTableManager(_db.attachedDatabase, _db.missions);
  $$MissionStepsTableTableManager get missionSteps =>
      $$MissionStepsTableTableManager(_db.attachedDatabase, _db.missionSteps);
}
