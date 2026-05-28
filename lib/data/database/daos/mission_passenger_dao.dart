import 'package:drift/drift.dart';
import '../app_database.dart';

part 'mission_passenger_dao.g.dart';

@DriftAccessor(tables: [MissionPassengers, Passengers])
class MissionPassengerDao extends DatabaseAccessor<AppDatabase>
    with _$MissionPassengerDaoMixin {
  MissionPassengerDao(super.db);

  Future<List<MissionPassenger>> getByMission(int missionId) =>
      (select(missionPassengers)
            ..where((mp) => mp.missionId.equals(missionId))
            ..orderBy([(mp) => OrderingTerm.asc(mp.pickupOrder)]))
          .get();

  Stream<List<MissionPassenger>> watchByMission(int missionId) =>
      (select(missionPassengers)
            ..where((mp) => mp.missionId.equals(missionId))
            ..orderBy([(mp) => OrderingTerm.asc(mp.pickupOrder)]))
          .watch();

  Future<int> insertMissionPassenger(MissionPassengersCompanion entry) =>
      into(missionPassengers).insert(entry);

  Future<int> deleteByMission(int missionId) =>
      (delete(missionPassengers)
            ..where((mp) => mp.missionId.equals(missionId)))
          .go();

  Future<int> updateWhatsappStatus(int id, String status) =>
      (update(missionPassengers)..where((mp) => mp.id.equals(id))).write(
        MissionPassengersCompanion(whatsappStatus: Value(status)),
      );
}
