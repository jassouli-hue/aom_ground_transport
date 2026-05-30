import 'package:drift/drift.dart';
import '../app_database.dart';

part 'vehicle_dao.g.dart';

@DriftAccessor(tables: [Vehicles])
class VehicleDao extends DatabaseAccessor<AppDatabase> with _$VehicleDaoMixin {
  VehicleDao(super.db);

  Future<List<Vehicle>> getAllActive() =>
      (select(vehicles)
            ..where((v) => v.isActive.equals(true))
            ..orderBy([(v) => OrderingTerm.asc(v.brand)]))
          .get();

  Stream<List<Vehicle>> watchAllActive() =>
      (select(vehicles)
            ..where((v) => v.isActive.equals(true))
            ..orderBy([(v) => OrderingTerm.asc(v.brand)]))
          .watch();

  Future<Vehicle?> getById(int id) =>
      (select(vehicles)..where((v) => v.id.equals(id))).getSingleOrNull();

  Future<int> insertVehicle(VehiclesCompanion entry) =>
      into(vehicles).insert(entry);

  Future<bool> updateVehicle(VehiclesCompanion entry) =>
      update(vehicles).replace(entry);

  Future<int> softDelete(int id) => (update(vehicles)
        ..where((v) => v.id.equals(id)))
      .write(const VehiclesCompanion(isActive: Value(false)));
}
