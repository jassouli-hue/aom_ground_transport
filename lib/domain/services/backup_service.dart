import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' show Share, XFile;
import '../../data/database/app_database.dart';

class BackupService {
  final AppDatabase _db;

  BackupService(this._db);

  Future<String> exportToJson() async {
    final drivers = await _db.driverDao.getAllActive();
    final vehicles = await _db.vehicleDao.getAllActive();
    final passengers = await _db.passengerDao.getAllActive();
    final locations = await _db.knownLocationDao.getAllActive();
    final missions = await _db.missionDao.getAll();
    final settings = await _db.settingsDao.getAll();

    final data = {
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0',
      'drivers': drivers.map((d) => {
        'id': d.id, 'name': d.name, 'phone': d.phone, 'isActive': d.isActive,
      }).toList(),
      'vehicles': vehicles.map((v) => {
        'id': v.id, 'brand': v.brand, 'plateNumber': v.plateNumber,
        'capacity': v.capacity, 'isActive': v.isActive,
      }).toList(),
      'passengers': passengers.map((p) => {
        'id': p.id, 'name': p.name, 'role': p.role, 'phone': p.phone,
        'baseCity': p.baseCity, 'isActive': p.isActive,
      }).toList(),
      'locations': locations.map((l) => {
        'id': l.id, 'name': l.name, 'shortCode': l.shortCode, 'city': l.city,
        'latitude': l.latitude, 'longitude': l.longitude, 'isAirport': l.isAirport,
      }).toList(),
      'missions': missions.map((m) => {
        'id': m.id, 'reference': m.reference, 'type': m.type,
        'driverId': m.driverId, 'vehicleId': m.vehicleId,
        'destinationId': m.destinationId,
        'scheduledAt': m.scheduledAt.toIso8601String(),
        'status': m.status,
        'totalDistanceKm': m.totalDistanceKm,
        'estimatedDurationMin': m.estimatedDurationMin,
        'returnToBase': m.returnToBase,
        'notes': m.notes,
      }).toList(),
      'settings': settings.map((s) => {'key': s.key, 'value': s.value}).toList(),
    };

    return jsonEncode(data);
  }

  Future<void> shareBackup() async {
    final json = await exportToJson();
    final dir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/aom_backup_$timestamp.json');
    await file.writeAsString(json);
    await Share.shareXFiles([XFile(file.path)], text: 'Sauvegarde AOM Ground Transport');
  }

  Future<void> importFromJson(String jsonContent) async {
    final data = jsonDecode(jsonContent) as Map<String, dynamic>;
    // Import simplifié: settings uniquement pour MVP
    // Une restauration complète nécessiterait une transaction et gestion des conflits
    if (data.containsKey('settings')) {
      for (final s in data['settings'] as List) {
        await _db.settingsDao.setValue(s['key'] as String, s['value'] as String);
      }
    }
  }
}
