import 'package:drift/drift.dart';
import '../app_database.dart';

part 'driver_dao.g.dart';

@DriftAccessor(tables: [Drivers])
class DriverDao extends DatabaseAccessor<AppDatabase> with _$DriverDaoMixin {
  DriverDao(super.db);

  Future<List<Driver>> getAllActive() =>
      (select(drivers)
            ..where((d) => d.isActive.equals(true))
            ..orderBy([(d) => OrderingTerm.asc(d.name)]))
          .get();

  Stream<List<Driver>> watchAllActive() =>
      (select(drivers)
            ..where((d) => d.isActive.equals(true))
            ..orderBy([(d) => OrderingTerm.asc(d.name)]))
          .watch();

  Future<Driver?> getById(int id) =>
      (select(drivers)..where((d) => d.id.equals(id))).getSingleOrNull();

  Future<int> insertDriver(DriversCompanion entry) =>
      into(drivers).insert(entry);

  Future<bool> updateDriver(DriversCompanion entry) =>
      update(drivers).replace(entry);

  Future<int> softDelete(int id) => (update(drivers)
        ..where((d) => d.id.equals(id)))
      .write(const DriversCompanion(isActive: Value(false)));
}
