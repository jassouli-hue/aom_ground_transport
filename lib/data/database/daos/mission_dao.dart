import 'package:drift/drift.dart';
import '../app_database.dart';

part 'mission_dao.g.dart';

@DriftAccessor(tables: [Missions, Drivers, Vehicles, KnownLocations])
class MissionDao extends DatabaseAccessor<AppDatabase> with _$MissionDaoMixin {
  MissionDao(super.db);

  Future<List<Mission>> getAll() =>
      (select(missions)..orderBy([(m) => OrderingTerm.desc(m.scheduledAt)])).get();

  Stream<List<Mission>> watchAll() =>
      (select(missions)..orderBy([(m) => OrderingTerm.desc(m.scheduledAt)])).watch();

  Future<List<Mission>> getByStatus(String status) =>
      (select(missions)..where((m) => m.status.equals(status))).get();

  Future<Mission?> getById(int id) =>
      (select(missions)..where((m) => m.id.equals(id))).getSingleOrNull();

  Future<int> insertMission(MissionsCompanion entry) =>
      into(missions).insert(entry);

  Future<bool> updateMission(MissionsCompanion entry) =>
      update(missions).replace(entry);

  Future<int> updateStatus(int id, String status) =>
      (update(missions)..where((m) => m.id.equals(id))).write(
        MissionsCompanion(
          status: Value(status),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<int> countByStatus(String status) async {
    final countExp = missions.id.count();
    final query = selectOnly(missions)
      ..addColumns([countExp])
      ..where(missions.status.equals(status));
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }
}
