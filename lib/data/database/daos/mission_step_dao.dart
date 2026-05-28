import 'package:drift/drift.dart';
import '../app_database.dart';

part 'mission_step_dao.g.dart';

@DriftAccessor(tables: [MissionSteps])
class MissionStepDao extends DatabaseAccessor<AppDatabase>
    with _$MissionStepDaoMixin {
  MissionStepDao(super.db);

  Future<List<MissionStep>> getByMission(int missionId) =>
      (select(missionSteps)
            ..where((s) => s.missionId.equals(missionId))
            ..orderBy([(s) => OrderingTerm.asc(s.stepOrder)]))
          .get();

  Future<int> insertStep(MissionStepsCompanion entry) =>
      into(missionSteps).insert(entry);

  Future<int> deleteByMission(int missionId) =>
      (delete(missionSteps)..where((s) => s.missionId.equals(missionId))).go();
}
