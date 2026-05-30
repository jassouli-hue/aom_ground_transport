import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../../data/models/mission_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _channelId = 'aom_missions';
  static const _channelName = 'Missions AOM';
  static const _channelDesc = 'Rappels avant le départ de mission';
  static const _reminderMinutes = 15;

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    // Maroc = Africa/Casablanca (UTC+1)
    tz.setLocalLocation(tz.getLocation('Africa/Casablanca'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings);
    await _createChannel();
    _initialized = true;
    dev.log('[Notif] Service initialisé');
  }

  Future<void> _createChannel() async {
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Planifie une notification 15 min avant la mission.
  /// Si la mission est dans moins de 15 min ou dans le passé → notification immédiate.
  Future<void> scheduleMissionReminder(MissionModel mission) async {
    if (!_initialized) await initialize();

    final reminderTime =
        mission.scheduledAt.subtract(Duration(minutes: _reminderMinutes));
    final now = DateTime.now();

    // ID unique basé sur l'ID de mission
    final notifId = mission.id;

    // Annuler l'éventuelle notification précédente pour cette mission
    await _plugin.cancel(notifId);

    // Si le rappel est déjà passé, ne pas planifier
    if (reminderTime.isBefore(now)) {
      dev.log('[Notif] Mission ${mission.reference} : rappel déjà passé, pas de notification');
      return;
    }

    final scheduledTz = tz.TZDateTime.from(reminderTime, tz.local);

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        styleInformation: BigTextStyleInformation(
          _buildBody(mission),
          contentTitle: '🚗 Mission dans $_reminderMinutes min',
          summaryText: mission.reference,
        ),
        ticker: 'Mission AOM dans $_reminderMinutes min',
      ),
    );

    await _plugin.zonedSchedule(
      notifId,
      '🚗 Mission ${mission.reference} dans $_reminderMinutes min',
      _buildBody(mission),
      scheduledTz,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    dev.log('[Notif] Mission ${mission.reference} : rappel planifié à ${reminderTime.toString()}');
  }

  String _buildBody(MissionModel mission) {
    final lines = <String>[
      'Chauffeur : ${mission.driverName}',
      'Véhicule : ${mission.vehicleBrand} (${mission.vehiclePlate})',
      'Destination : ${mission.destinationName}',
    ];
    if (mission.passengers.isNotEmpty) {
      lines.add('${mission.passengers.length} passager(s)');
    }
    return lines.join('\n');
  }

  /// Annule le rappel d'une mission (annulation ou suppression).
  Future<void> cancelReminder(int missionId) async {
    if (!_initialized) await initialize();
    await _plugin.cancel(missionId);
    dev.log('[Notif] Rappel mission $missionId annulé');
  }

  /// Demande la permission de notifications (Android 13+).
  Future<bool> requestPermission(BuildContext context) async {
    if (!_initialized) await initialize();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission() ?? false;
    return granted;
  }
}
