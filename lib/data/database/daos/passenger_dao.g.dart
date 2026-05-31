// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_dao.dart';

// ignore_for_file: type=lint
mixin _$PassengerDaoMixin on DatabaseAccessor<AppDatabase> {
  $PassengersTable get passengers => attachedDatabase.passengers;
  PassengerDaoManager get managers => PassengerDaoManager(this);
}

class PassengerDaoManager {
  final _$PassengerDaoMixin _db;
  PassengerDaoManager(this._db);
  $$PassengersTableTableManager get passengers =>
      $$PassengersTableTableManager(_db.attachedDatabase, _db.passengers);
}
