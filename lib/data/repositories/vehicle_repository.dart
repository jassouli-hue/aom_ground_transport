import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/vehicle_model.dart';

class VehicleRepository {
  final AppDatabase _db;

  VehicleRepository(this._db);

  Stream<List<VehicleModel>> watchAll() =>
      _db.vehicleDao.watchAllActive().map(
        (rows) => rows.map(_toModel).toList(),
      );

  Future<List<VehicleModel>> getAll() async {
    final rows = await _db.vehicleDao.getAllActive();
    return rows.map(_toModel).toList();
  }

  Future<VehicleModel?> getById(int id) async {
    final row = await _db.vehicleDao.getById(id);
    return row != null ? _toModel(row) : null;
  }

  Future<int> create({
    required String brand,
    required String plateNumber,
    required int capacity,
  }) =>
      _db.vehicleDao.insertVehicle(VehiclesCompanion(
        brand: Value(brand),
        plateNumber: Value(plateNumber),
        capacity: Value(capacity),
      ));

  Future<void> update(VehicleModel vehicle) =>
      _db.vehicleDao.updateVehicle(VehiclesCompanion(
        id: Value(vehicle.id),
        brand: Value(vehicle.brand),
        plateNumber: Value(vehicle.plateNumber),
        capacity: Value(vehicle.capacity),
        isActive: Value(vehicle.isActive),
        createdAt: Value(vehicle.createdAt),
      ));

  Future<void> delete(int id) => _db.vehicleDao.softDelete(id);

  VehicleModel _toModel(Vehicle row) => VehicleModel(
        id: row.id,
        brand: row.brand,
        plateNumber: row.plateNumber,
        capacity: row.capacity,
        isActive: row.isActive,
        createdAt: row.createdAt,
      );
}
