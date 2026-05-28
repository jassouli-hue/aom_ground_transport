import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/driver_model.dart';

class DriverRepository {
  final AppDatabase _db;

  DriverRepository(this._db);

  Stream<List<DriverModel>> watchAll() =>
      _db.driverDao.watchAllActive().map(
        (rows) => rows.map(_toModel).toList(),
      );

  Future<List<DriverModel>> getAll() async {
    final rows = await _db.driverDao.getAllActive();
    return rows.map(_toModel).toList();
  }

  Future<DriverModel?> getById(int id) async {
    final row = await _db.driverDao.getById(id);
    return row != null ? _toModel(row) : null;
  }

  Future<int> create({required String name, required String phone}) =>
      _db.driverDao.insertDriver(DriversCompanion(
        name: Value(name),
        phone: Value(phone),
      ));

  Future<void> update(DriverModel driver) =>
      _db.driverDao.updateDriver(DriversCompanion(
        id: Value(driver.id),
        name: Value(driver.name),
        phone: Value(driver.phone),
        isActive: Value(driver.isActive),
        createdAt: Value(driver.createdAt),
      ));

  Future<void> delete(int id) => _db.driverDao.softDelete(id);

  DriverModel _toModel(Driver row) => DriverModel(
        id: row.id,
        name: row.name,
        phone: row.phone,
        isActive: row.isActive,
        createdAt: row.createdAt,
      );
}
