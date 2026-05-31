// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'known_location_dao.dart';

// ignore_for_file: type=lint
mixin _$KnownLocationDaoMixin on DatabaseAccessor<AppDatabase> {
  $KnownLocationsTable get knownLocations => attachedDatabase.knownLocations;
  KnownLocationDaoManager get managers => KnownLocationDaoManager(this);
}

class KnownLocationDaoManager {
  final _$KnownLocationDaoMixin _db;
  KnownLocationDaoManager(this._db);
  $$KnownLocationsTableTableManager get knownLocations =>
      $$KnownLocationsTableTableManager(
          _db.attachedDatabase, _db.knownLocations);
}
