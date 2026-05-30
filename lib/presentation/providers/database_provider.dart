import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/driver_repository.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../data/repositories/passenger_repository.dart';
import '../../data/repositories/known_location_repository.dart';
import '../../data/repositories/mission_repository.dart';
import '../../domain/services/distance_service.dart';
import '../../domain/services/google_maps_link_service.dart';
import '../../domain/services/whatsapp_message_service.dart';
import '../../domain/services/mission_builder_service.dart';
import '../../domain/services/osrm_routing_service.dart';
import '../../domain/services/notification_service.dart';
import '../../domain/services/backup_service.dart';
import '../../domain/services/settings_service.dart';
import '../../domain/services/seed_service.dart';
import '../../data/repositories/notification_log_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  return DriverRepository(ref.watch(appDatabaseProvider));
});

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepository(ref.watch(appDatabaseProvider));
});

final passengerRepositoryProvider = Provider<PassengerRepository>((ref) {
  return PassengerRepository(ref.watch(appDatabaseProvider));
});

final knownLocationRepositoryProvider = Provider<KnownLocationRepository>((ref) {
  return KnownLocationRepository(ref.watch(appDatabaseProvider));
});

final missionRepositoryProvider = Provider<MissionRepository>((ref) {
  return MissionRepository(ref.watch(appDatabaseProvider));
});

final distanceServiceProvider = Provider<DistanceService>((_) => DistanceService());

final osrmRoutingServiceProvider =
    Provider<OsrmRoutingService>((_) => OsrmRoutingService());

final notificationServiceProvider = Provider<NotificationService>((_) {
  return NotificationService();
});

final googleMapsLinkServiceProvider = Provider<GoogleMapsLinkService>(
    (_) => GoogleMapsLinkService());

final whatsAppMessageServiceProvider = Provider<WhatsAppMessageService>((ref) {
  return WhatsAppMessageService(ref.watch(appDatabaseProvider));
});

final missionBuilderServiceProvider = Provider<MissionBuilderService>((ref) {
  return MissionBuilderService(
    ref.watch(appDatabaseProvider),
    ref.watch(osrmRoutingServiceProvider),
    ref.watch(googleMapsLinkServiceProvider),
    ref.watch(notificationServiceProvider),
  );
});

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(appDatabaseProvider));
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(ref.watch(appDatabaseProvider));
});

final seedServiceProvider = Provider<SeedService>((ref) {
  return SeedService(ref.watch(appDatabaseProvider));
});

final notificationLogRepositoryProvider =
    Provider<NotificationLogRepository>((ref) {
  return NotificationLogRepository(ref.watch(appDatabaseProvider));
});
