import 'package:drift/drift.dart';
import '../app_database.dart';

part 'known_location_dao.g.dart';

@DriftAccessor(tables: [KnownLocations])
class KnownLocationDao extends DatabaseAccessor<AppDatabase>
    with _$KnownLocationDaoMixin {
  KnownLocationDao(super.db);

  Future<List<KnownLocation>> getAllActive() =>
      (select(knownLocations)..where((l) => l.isActive.equals(true))).get();

  Stream<List<KnownLocation>> watchAllActive() =>
      (select(knownLocations)..where((l) => l.isActive.equals(true))).watch();

  Future<List<KnownLocation>> getAirports() =>
      (select(knownLocations)
            ..where((l) => l.isAirport.equals(true) & l.isActive.equals(true)))
          .get();

  Future<KnownLocation?> getById(int id) =>
      (select(knownLocations)..where((l) => l.id.equals(id))).getSingleOrNull();

  Future<int> insertLocation(KnownLocationsCompanion entry) =>
      into(knownLocations).insert(entry);

  Future<bool> updateLocation(KnownLocationsCompanion entry) =>
      update(knownLocations).replace(entry);

  Future<int> softDelete(int id) => (update(knownLocations)
        ..where((l) => l.id.equals(id)))
      .write(const KnownLocationsCompanion(isActive: Value(false)));
}
