// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_passenger_dao.dart';

// ignore_for_file: type=lint
mixin _$MissionPassengerDaoMixin on DatabaseAccessor<AppDatabase> {
  $DriversTable get drivers => attachedDatabase.drivers;
  $VehiclesTable get vehicles => attachedDatabase.vehicles;
  $KnownLocationsTable get knownLocations => attachedDatabase.knownLocations;
  $MissionsTable get missions => attachedDatabase.missions;
  $PassengersTable get passengers => attachedDatabase.passengers;
  $MissionPassengersTable get missionPassengers =>
      attachedDatabase.missionPassengers;
  MissionPassengerDaoManager get managers => MissionPassengerDaoManager(this);
}

class MissionPassengerDaoManager {
  final _$MissionPassengerDaoMixin _db;
  MissionPassengerDaoManager(this._db);
  $$DriversTableTableManager get drivers =>
      $$DriversTableTableManager(_db.attachedDatabase, _db.drivers);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db.attachedDatabase, _db.vehicles);
  $$KnownLocationsTableTableManager get knownLocations =>
      $$KnownLocationsTableTableManager(
          _db.attachedDatabase, _db.knownLocations);
  $$MissionsTableTableManager get missions =>
      $$MissionsTableTableManager(_db.attachedDatabase, _db.missions);
  $$PassengersTableTableManager get passengers =>
      $$PassengersTableTableManager(_db.attachedDatabase, _db.passengers);
  $$MissionPassengersTableTableManager get missionPassengers =>
      $$MissionPassengersTableTableManager(
          _db.attachedDatabase, _db.missionPassengers);
}
