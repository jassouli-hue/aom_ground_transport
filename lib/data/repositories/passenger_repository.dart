import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/passenger_model.dart';

class PassengerRepository {
  final AppDatabase _db;

  PassengerRepository(this._db);

  Stream<List<PassengerModel>> watchAll() =>
      _db.passengerDao.watchAllActive().map(
        (rows) => rows.map(_toModel).toList(),
      );

  Future<List<PassengerModel>> getAll() async {
    final rows = await _db.passengerDao.getAllActive();
    return rows.map(_toModel).toList();
  }

  Future<PassengerModel?> getById(int id) async {
    final row = await _db.passengerDao.getById(id);
    return row != null ? _toModel(row) : null;
  }

  Future<int> create({
    required String name,
    required String role,
    required String phone,
    required String baseCity,
    double? baseLat,
    double? baseLng,
  }) =>
      _db.passengerDao.insertPassenger(PassengersCompanion(
        name: Value(name),
        role: Value(role),
        phone: Value(phone),
        baseCity: Value(baseCity),
        baseLat: Value(baseLat),
        baseLng: Value(baseLng),
      ));

  Future<void> update(PassengerModel passenger) =>
      _db.passengerDao.updatePassenger(PassengersCompanion(
        id: Value(passenger.id),
        name: Value(passenger.name),
        role: Value(passenger.role),
        phone: Value(passenger.phone),
        baseCity: Value(passenger.baseCity),
        baseLat: Value(passenger.baseLat),
        baseLng: Value(passenger.baseLng),
        isActive: Value(passenger.isActive),
        createdAt: Value(passenger.createdAt),
      ));

  Future<void> delete(int id) => _db.passengerDao.softDelete(id);

  PassengerModel _toModel(Passenger row) => PassengerModel(
        id: row.id,
        name: row.name,
        role: row.role,
        phone: row.phone,
        baseCity: row.baseCity,
        baseLat: row.baseLat,
        baseLng: row.baseLng,
        isActive: row.isActive,
        createdAt: row.createdAt,
      );
}
