import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/notification_log_model.dart';

class NotificationLogRepository {
  final AppDatabase _db;

  NotificationLogRepository(this._db);

  Future<List<NotificationLogModel>> getByMission(int missionId) async {
    final rows = await _db.notificationLogDao.getByMission(missionId);
    return rows.map(_toModel).toList();
  }

  Stream<List<NotificationLogModel>> watchByMission(int missionId) =>
      _db.notificationLogDao
          .watchByMission(missionId)
          .map((rows) => rows.map(_toModel).toList());

  Future<List<NotificationLogModel>> getAll() async {
    final rows = await _db.notificationLogDao.getAll();
    return rows.map(_toModel).toList();
  }

  Future<int> create({
    required int missionId,
    required String recipientType,
    required int recipientId,
    required String recipientName,
    required String recipientPhone,
    required String messageContent,
    required String whatsappUrl,
  }) =>
      _db.notificationLogDao.insertLog(NotificationLogsCompanion(
        missionId: Value(missionId),
        recipientType: Value(recipientType),
        recipientId: Value(recipientId),
        recipientName: Value(recipientName),
        recipientPhone: Value(recipientPhone),
        messageContent: Value(messageContent),
        whatsappUrl: Value(whatsappUrl),
      ));

  Future<void> markOpened(int id) =>
      _db.notificationLogDao.updateStatus(id, 'OUVERT_WHATSAPP',
          openedAt: DateTime.now());

  Future<void> markSent(int id) =>
      _db.notificationLogDao.updateStatus(id, 'MARQUE_ENVOYE',
          markedSentAt: DateTime.now());

  NotificationLogModel _toModel(NotificationLog row) => NotificationLogModel(
        id: row.id,
        missionId: row.missionId,
        recipientType: row.recipientType,
        recipientId: row.recipientId,
        recipientName: row.recipientName,
        recipientPhone: row.recipientPhone,
        messageContent: row.messageContent,
        whatsappUrl: row.whatsappUrl,
        status: row.status,
        generatedAt: row.generatedAt,
        openedAt: row.openedAt,
        markedSentAt: row.markedSentAt,
      );
}
