// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_dao.dart';

// ignore_for_file: type=lint
mixin _$DriverDaoMixin on DatabaseAccessor<AppDatabase> {
  $DriversTable get drivers => attachedDatabase.drivers;
  DriverDaoManager get managers => DriverDaoManager(this);
}

class DriverDaoManager {
  final _$DriverDaoMixin _db;
  DriverDaoManager(this._db);
  $$DriversTableTableManager get drivers =>
      $$DriversTableTableManager(_db.attachedDatabase, _db.drivers);
}
