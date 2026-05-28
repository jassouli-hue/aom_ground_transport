import 'package:drift/drift.dart';
import '../app_database.dart';

part 'notification_log_dao.g.dart';

@DriftAccessor(tables: [NotificationLogs])
class NotificationLogDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationLogDaoMixin {
  NotificationLogDao(super.db);

  Future<List<NotificationLog>> getByMission(int missionId) =>
      (select(notificationLogs)
            ..where((l) => l.missionId.equals(missionId))
            ..orderBy([(l) => OrderingTerm.desc(l.generatedAt)]))
          .get();

  Stream<List<NotificationLog>> watchByMission(int missionId) =>
      (select(notificationLogs)
            ..where((l) => l.missionId.equals(missionId))
            ..orderBy([(l) => OrderingTerm.desc(l.generatedAt)]))
          .watch();

  Future<List<NotificationLog>> getAll() =>
      (select(notificationLogs)
            ..orderBy([(l) => OrderingTerm.desc(l.generatedAt)]))
          .get();

  Future<int> insertLog(NotificationLogsCompanion entry) =>
      into(notificationLogs).insert(entry);

  Future<int> updateStatus(int id, String status,
      {DateTime? openedAt, DateTime? markedSentAt}) =>
      (update(notificationLogs)..where((l) => l.id.equals(id))).write(
        NotificationLogsCompanion(
          status: Value(status),
          openedAt: openedAt != null ? Value(openedAt) : const Value.absent(),
          markedSentAt: markedSentAt != null
              ? Value(markedSentAt)
              : const Value.absent(),
        ),
      );
}
