import 'dart:developer' as dev;
import 'package:drift/drift.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/database/app_database.dart';
import '../../data/models/mission_model.dart';

class WhatsAppMessageService {
  final AppDatabase _db;

  WhatsAppMessageService(this._db);

  // ─── Génération des messages ──────────────────────────────────────────────

  String buildDriverMessage(MissionModel mission) {
    final buf = StringBuffer();
    buf.writeln('🚗 *MISSION AOM — ${mission.reference}*');
    buf.writeln('Date : ${_formatDate(mission.scheduledAt)}');
    buf.writeln('Type : ${mission.typeLabel}');
    buf.writeln();
    buf.writeln('📋 *Détails mission :*');
    buf.writeln('Véhicule : ${mission.vehicleBrand} (${mission.vehiclePlate})');
    buf.writeln('Destination : ${mission.destinationName}');
    if (mission.totalDistanceKm != null) {
      buf.writeln('Distance totale : ${mission.totalDistanceKm!.toStringAsFixed(1)} km');
    }
    if (mission.estimatedDurationMin != null) {
      buf.writeln('Durée estimée : ${_formatDuration(mission.estimatedDurationMin!)}');
    }
    buf.writeln();
    buf.writeln('👥 *Passagers à prendre en charge :*');
    for (int i = 0; i < mission.passengers.length; i++) {
      final p = mission.passengers[i];
      buf.writeln('${i + 1}. ${p.passengerName} (${p.passengerRole}) — ${p.pickupCity}');
    }
    buf.writeln();

    if (mission.steps.isNotEmpty) {
      buf.writeln('🗺️ *Itinéraire :*');
      for (final step in mission.steps) {
        buf.writeln('${step.stepOrder}. ${step.typeLabel} : ${step.locationName}');
        if (step.distanceFromPrevKm != null) {
          buf.write('   ↳ ${step.distanceFromPrevKm!.toStringAsFixed(1)} km');
          if (step.durationFromPrevMin != null) {
            buf.write(' / ${_formatDuration(step.durationFromPrevMin!)}');
          }
          buf.writeln();
        }
      }
      buf.writeln();
    }

    if (mission.googleMapsUrl != null) {
      buf.writeln('📍 *Itinéraire Google Maps :*');
      buf.writeln(mission.googleMapsUrl);
      buf.writeln();
    }

    buf.writeln('✅ Merci de confirmer réception.');
    buf.writeln('— AIR OCEAN MAROC');
    return buf.toString();
  }

  String buildPassengerMessage(MissionModel mission, MissionPassengerEntry p) {
    final buf = StringBuffer();
    buf.writeln('✈️ *CONVOCATION — AIR OCEAN MAROC*');
    buf.writeln('Bonjour ${p.passengerName},');
    buf.writeln();
    buf.writeln('📋 *Votre mission :*');
    buf.writeln('Référence : ${mission.reference}');
    buf.writeln('Date : ${_formatDate(mission.scheduledAt)}');
    buf.writeln('Type : ${mission.typeLabel}');
    buf.writeln('Destination : ${mission.destinationName}');
    buf.writeln();
    buf.writeln('🚗 *Votre prise en charge :*');
    buf.writeln('Lieu : ${p.pickupCity}');
    buf.writeln('Chauffeur : ${mission.driverName}');
    buf.writeln('Véhicule : ${mission.vehicleBrand} — ${mission.vehiclePlate}');
    buf.writeln();
    buf.writeln('📞 Contact chauffeur : ${mission.driverPhone}');
    buf.writeln();
    buf.writeln('⚠️ Merci d\'être présent(e) 10 min avant l\'heure prévue.');
    buf.writeln('— AIR OCEAN MAROC');
    return buf.toString();
  }

  // ─── URL WhatsApp ─────────────────────────────────────────────────────────

  String buildWhatsAppUrl(String phone, String message) {
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-()]'), '');
    final encoded = Uri.encodeComponent(message);
    return 'https://wa.me/$cleanPhone?text=$encoded';
  }

  // ─── Action ouvrir WhatsApp + log ────────────────────────────────────────

  Future<bool> openWhatsApp({
    required int missionId,
    required String recipientType,
    required int recipientId,
    required String recipientName,
    required String recipientPhone,
    required String message,
  }) async {
    final url = buildWhatsAppUrl(recipientPhone, message);
    final uri = Uri.parse(url);

    final logId = await _db.notificationLogDao.insertLog(
      NotificationLogsCompanion(
        missionId: Value(missionId),
        recipientType: Value(recipientType),
        recipientId: Value(recipientId),
        recipientName: Value(recipientName),
        recipientPhone: Value(recipientPhone),
        messageContent: Value(message),
        whatsappUrl: Value(url),
        status: const Value('GENERE'),
      ),
    );

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (launched) {
        await _db.notificationLogDao.updateStatus(
          logId,
          'OUVERT_WHATSAPP',
          openedAt: DateTime.now(),
        );
      }
      return launched;
    } catch (e) {
      dev.log('WhatsApp launch error: $e');
      return false;
    }
  }

  Future<void> markAsSent(int logId) async {
    await _db.notificationLogDao.updateStatus(
      logId,
      'MARQUE_ENVOYE',
      markedSentAt: DateTime.now(),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year} à '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}min';
    if (m == 0) return '${h}h';
    return '${h}h${m.toString().padLeft(2, '0')}';
  }
}
