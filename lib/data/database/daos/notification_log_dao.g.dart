// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_log_dao.dart';

// ignore_for_file: type=lint
mixin _$NotificationLogDaoMixin on DatabaseAccessor<AppDatabase> {
  $DriversTable get drivers => attachedDatabase.drivers;
  $VehiclesTable get vehicles => attachedDatabase.vehicles;
  $KnownLocationsTable get knownLocations => attachedDatabase.knownLocations;
  $MissionsTable get missions => attachedDatabase.missions;
  $NotificationLogsTable get notificationLogs =>
      attachedDatabase.notificationLogs;
  NotificationLogDaoManager get managers => NotificationLogDaoManager(this);
}

class NotificationLogDaoManager {
  final _$NotificationLogDaoMixin _db;
  NotificationLogDaoManager(this._db);
  $$DriversTableTableManager get drivers =>
      $$DriversTableTableManager(_db.attachedDatabase, _db.drivers);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db.attachedDatabase, _db.vehicles);
  $$KnownLocationsTableTableManager get knownLocations =>
      $$KnownLocationsTableTableManager(
          _db.attachedDatabase, _db.knownLocations);
  $$MissionsTableTableManager get missions =>
      $$MissionsTableTableManager(_db.attachedDatabase, _db.missions);
  $$NotificationLogsTableTableManager get notificationLogs =>
      $$NotificationLogsTableTableManager(
          _db.attachedDatabase, _db.notificationLogs);
}
