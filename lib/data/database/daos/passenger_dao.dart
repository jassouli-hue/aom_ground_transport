import 'package:drift/drift.dart';
import '../app_database.dart';

part 'passenger_dao.g.dart';

@DriftAccessor(tables: [Passengers])
class PassengerDao extends DatabaseAccessor<AppDatabase>
    with _$PassengerDaoMixin {
  PassengerDao(super.db);

  Future<List<Passenger>> getAllActive() =>
      (select(passengers)
            ..where((p) => p.isActive.equals(true))
            ..orderBy([(p) => OrderingTerm.asc(p.name)]))
          .get();

  Stream<List<Passenger>> watchAllActive() =>
      (select(passengers)
            ..where((p) => p.isActive.equals(true))
            ..orderBy([(p) => OrderingTerm.asc(p.name)]))
          .watch();

  Future<Passenger?> getById(int id) =>
      (select(passengers)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<int> insertPassenger(PassengersCompanion entry) =>
      into(passengers).insert(entry);

  Future<bool> updatePassenger(PassengersCompanion entry) =>
      update(passengers).replace(entry);

  Future<int> softDelete(int id) => (update(passengers)
        ..where((p) => p.id.equals(id)))
      .write(const PassengersCompanion(isActive: Value(false)));
}
