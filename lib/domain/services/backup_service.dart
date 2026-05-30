import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/database/app_database.dart';

class BackupService {
  final AppDatabase _db;
  BackupService(this._db);

  // ─── JSON EXPORT ──────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> _buildFullExport() async {
    final drivers    = await _db.select(_db.drivers).get();
    final vehicles   = await _db.select(_db.vehicles).get();
    final passengers = await _db.select(_db.passengers).get();
    final locations  = await _db.select(_db.knownLocations).get();
    final missions   = await _db.select(_db.missions).get();
    final mps        = await _db.select(_db.missionPassengers).get();
    final steps      = await _db.select(_db.missionSteps).get();
    final settings   = await _db.settingsDao.getAll();

    return {
      'version': 2,
      'exportedAt': DateTime.now().toIso8601String(),
      'drivers': drivers.map((d) => {
        'id': d.id, 'name': d.name, 'phone': d.phone,
        'isActive': d.isActive, 'createdAt': d.createdAt.toIso8601String(),
      }).toList(),
      'vehicles': vehicles.map((v) => {
        'id': v.id, 'brand': v.brand, 'plateNumber': v.plateNumber,
        'capacity': v.capacity, 'isActive': v.isActive,
        'createdAt': v.createdAt.toIso8601String(),
      }).toList(),
      'passengers': passengers.map((p) => {
        'id': p.id, 'name': p.name, 'role': p.role, 'phone': p.phone,
        'baseCity': p.baseCity, 'baseLat': p.baseLat, 'baseLng': p.baseLng,
        'isActive': p.isActive, 'createdAt': p.createdAt.toIso8601String(),
      }).toList(),
      'knownLocations': locations.map((l) => {
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
        'googleMapsUrl': m.googleMapsUrl,
        'returnToBase': m.returnToBase, 'notes': m.notes,
        'createdAt': m.createdAt.toIso8601String(),
        'updatedAt': m.updatedAt?.toIso8601String(),
      }).toList(),
      'missionPassengers': mps.map((mp) => {
        'id': mp.id, 'missionId': mp.missionId,
        'passengerId': mp.passengerId,
        'guestName': mp.guestName, 'guestPhone': mp.guestPhone,
        'pickupCity': mp.pickupCity, 'pickupOrder': mp.pickupOrder,
        'pickupLocationId': mp.pickupLocationId,
        'whatsappStatus': mp.whatsappStatus,
      }).toList(),
      'missionSteps': steps.map((s) => {
        'id': s.id, 'missionId': s.missionId, 'stepOrder': s.stepOrder,
        'type': s.type, 'locationName': s.locationName, 'city': s.city,
        'latitude': s.latitude, 'longitude': s.longitude,
        'distanceFromPrevKm': s.distanceFromPrevKm,
        'durationFromPrevMin': s.durationFromPrevMin,
      }).toList(),
      'settings': settings.map((s) => {'key': s.key, 'value': s.value}).toList(),
    };
  }

  Future<String> _writeJson() async {
    final data = await _buildFullExport();
    final json = const JsonEncoder.withIndent('  ').convert(data);
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/aom_backup_$ts.json');
    await file.writeAsString(json);
    return file.path;
  }

  /// Exporte tout en JSON et ouvre le partage système (WhatsApp, Drive, email…).
  Future<void> shareJson() async {
    final path = await _writeJson();
    await Share.shareXFiles(
      [XFile(path, mimeType: 'application/json')],
      subject: 'AOM Ground Transport — Sauvegarde JSON',
    );
  }

  // ─── CSV EXPORT ───────────────────────────────────────────────────────────

  String _csvRow(List<dynamic> values) => values.map((v) {
    if (v == null) return '';
    final s = v.toString();
    return (s.contains(',') || s.contains('"') || s.contains('\n'))
        ? '"${s.replaceAll('"', '""')}"'
        : s;
  }).join(',');

  Future<List<String>> _writeCsvFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final ts  = DateTime.now().millisecondsSinceEpoch;
    final paths = <String>[];

    Future<String> csv(String name, List<String> headers, List<List<dynamic>> rows) async {
      final sb = StringBuffer()..writeln(_csvRow(headers));
      for (final r in rows) sb.writeln(_csvRow(r));
      final path = '${dir.path}/aom_${name}_$ts.csv';
      await File(path).writeAsString(sb.toString());
      return path;
    }

    final drivers = await _db.select(_db.drivers).get();
    paths.add(await csv('chauffeurs',
      ['id', 'nom', 'telephone', 'actif'],
      drivers.map((d) => [d.id, d.name, d.phone, d.isActive ? 'oui' : 'non']).toList()));

    final vehicles = await _db.select(_db.vehicles).get();
    paths.add(await csv('vehicules',
      ['id', 'marque', 'immatriculation', 'capacite', 'actif'],
      vehicles.map((v) => [v.id, v.brand, v.plateNumber, v.capacity, v.isActive ? 'oui' : 'non']).toList()));

    final passengers = await _db.select(_db.passengers).get();
    paths.add(await csv('passagers',
      ['id', 'nom', 'role', 'telephone', 'ville_base', 'latitude', 'longitude', 'actif'],
      passengers.map((p) => [p.id, p.name, p.role, p.phone, p.baseCity, p.baseLat, p.baseLng, p.isActive ? 'oui' : 'non']).toList()));

    final locations = await _db.select(_db.knownLocations).get();
    paths.add(await csv('lieux',
      ['id', 'nom', 'code', 'ville', 'latitude', 'longitude', 'aeroport'],
      locations.map((l) => [l.id, l.name, l.shortCode, l.city, l.latitude, l.longitude, l.isAirport ? 'oui' : 'non']).toList()));

    final missions = await _db.select(_db.missions).get();
    paths.add(await csv('missions',
      ['id', 'reference', 'type', 'id_chauffeur', 'id_vehicule', 'id_destination',
       'date_heure', 'statut', 'distance_km', 'duree_min', 'retour_base', 'notes'],
      missions.map((m) => [
        m.id, m.reference, m.type, m.driverId, m.vehicleId, m.destinationId,
        m.scheduledAt.toIso8601String(), m.status,
        m.totalDistanceKm, m.estimatedDurationMin,
        m.returnToBase ? 'oui' : 'non', m.notes,
      ]).toList()));

    return paths;
  }

  /// Exporte toutes les tables en CSV et ouvre le partage système.
  Future<void> shareCsv() async {
    final paths = await _writeCsvFiles();
    await Share.shareXFiles(
      paths.map((p) => XFile(p, mimeType: 'text/csv')).toList(),
      subject: 'AOM Ground Transport — Export CSV',
    );
  }

  // ─── JSON IMPORT ─────────────────────────────────────────────────────────

  /// Ouvre le sélecteur de fichier et retourne le chemin JSON choisi.
  Future<String?> pickJsonFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      dialogTitle: 'Sélectionner une sauvegarde JSON',
    );
    return result?.files.single.path;
  }

  /// Importe depuis un fichier JSON (écrase toutes les données existantes).
  Future<void> importFromFile(String filePath) async {
    final content = await File(filePath).readAsString();
    final data = jsonDecode(content) as Map<String, dynamic>;

    await _db.transaction(() async {
      // Supprimer dans l'ordre correct (FK)
      await _db.delete(_db.missionSteps).go();
      await _db.delete(_db.missionPassengers).go();
      await _db.delete(_db.notificationLogs).go();
      await _db.delete(_db.missions).go();
      await _db.delete(_db.knownLocations).go();
      await _db.delete(_db.passengers).go();
      await _db.delete(_db.vehicles).go();
      await _db.delete(_db.drivers).go();

      for (final d in (data['drivers'] as List? ?? [])) {
        await _db.into(_db.drivers).insert(DriversCompanion(
          id: Value(d['id'] as int),
          name: Value(d['name'] as String),
          phone: Value(d['phone'] as String),
          isActive: Value(d['isActive'] as bool? ?? true),
          createdAt: Value(d['createdAt'] != null
              ? DateTime.parse(d['createdAt'] as String) : DateTime.now()),
        ));
      }

      for (final v in (data['vehicles'] as List? ?? [])) {
        await _db.into(_db.vehicles).insert(VehiclesCompanion(
          id: Value(v['id'] as int),
          brand: Value(v['brand'] as String),
          plateNumber: Value(v['plateNumber'] as String),
          capacity: Value(v['capacity'] as int? ?? 4),
          isActive: Value(v['isActive'] as bool? ?? true),
          createdAt: Value(v['createdAt'] != null
              ? DateTime.parse(v['createdAt'] as String) : DateTime.now()),
        ));
      }

      for (final p in (data['passengers'] as List? ?? [])) {
        await _db.into(_db.passengers).insert(PassengersCompanion(
          id: Value(p['id'] as int),
          name: Value(p['name'] as String),
          role: Value(p['role'] as String? ?? ''),
          phone: Value(p['phone'] as String? ?? ''),
          baseCity: Value(p['baseCity'] as String? ?? ''),
          baseLat: Value(p['baseLat'] as double?),
          baseLng: Value(p['baseLng'] as double?),
          isActive: Value(p['isActive'] as bool? ?? true),
          createdAt: Value(p['createdAt'] != null
              ? DateTime.parse(p['createdAt'] as String) : DateTime.now()),
        ));
      }

      // Support ancien format ('locations') et nouveau ('knownLocations')
      final locKey = data.containsKey('knownLocations') ? 'knownLocations' : 'locations';
      for (final l in (data[locKey] as List? ?? [])) {
        await _db.into(_db.knownLocations).insert(KnownLocationsCompanion(
          id: Value(l['id'] as int),
          name: Value(l['name'] as String),
          shortCode: Value(l['shortCode'] as String? ?? ''),
          city: Value(l['city'] as String? ?? ''),
          latitude: Value((l['latitude'] as num).toDouble()),
          longitude: Value((l['longitude'] as num).toDouble()),
          isAirport: Value(l['isAirport'] as bool? ?? false),
        ));
      }

      for (final m in (data['missions'] as List? ?? [])) {
        await _db.into(_db.missions).insert(MissionsCompanion(
          id: Value(m['id'] as int),
          reference: Value(m['reference'] as String),
          type: Value(m['type'] as String),
          driverId: Value(m['driverId'] as int),
          vehicleId: Value(m['vehicleId'] as int),
          destinationId: Value(m['destinationId'] as int),
          scheduledAt: Value(DateTime.parse(m['scheduledAt'] as String)),
          status: Value(m['status'] as String? ?? 'PLANIFIEE'),
          totalDistanceKm: Value((m['totalDistanceKm'] as num?)?.toDouble()),
          estimatedDurationMin: Value(m['estimatedDurationMin'] as int?),
          googleMapsUrl: Value(m['googleMapsUrl'] as String?),
          returnToBase: Value(m['returnToBase'] as bool? ?? false),
          notes: Value(m['notes'] as String?),
          createdAt: Value(m['createdAt'] != null
              ? DateTime.parse(m['createdAt'] as String) : DateTime.now()),
        ));
      }

      for (final mp in (data['missionPassengers'] as List? ?? [])) {
        await _db.into(_db.missionPassengers).insert(MissionPassengersCompanion(
          id: Value(mp['id'] as int),
          missionId: Value(mp['missionId'] as int),
          passengerId: Value(mp['passengerId'] as int?),
          guestName: Value(mp['guestName'] as String?),
          guestPhone: Value(mp['guestPhone'] as String?),
          pickupCity: Value(mp['pickupCity'] as String?),
          pickupOrder: Value(mp['pickupOrder'] as int? ?? 0),
          pickupLocationId: Value(mp['pickupLocationId'] as int?),
        ));
      }

      for (final s in (data['missionSteps'] as List? ?? [])) {
        await _db.into(_db.missionSteps).insert(MissionStepsCompanion(
          id: Value(s['id'] as int),
          missionId: Value(s['missionId'] as int),
          stepOrder: Value(s['stepOrder'] as int),
          type: Value(s['type'] as String),
          locationName: Value(s['locationName'] as String),
          city: Value(s['city'] as String? ?? ''),
          latitude: Value(s['latitude'] as double?),
          longitude: Value(s['longitude'] as double?),
          distanceFromPrevKm: Value((s['distanceFromPrevKm'] as num?)?.toDouble()),
          durationFromPrevMin: Value(s['durationFromPrevMin'] as int?),
        ));
      }

      for (final setting in (data['settings'] as List? ?? [])) {
        await _db.settingsDao.setValue(
          setting['key'] as String, setting['value'] as String);
      }
    });
  }

  // ─── Compatibilité (ancien code) ─────────────────────────────────────────

  Future<String> exportToFile() => _writeJson();

  Future<String> exportToJson() async {
    final data = await _buildFullExport();
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  Future<void> importFromJson(String jsonContent) async {
    final data = jsonDecode(jsonContent) as Map<String, dynamic>;
    if (data.containsKey('settings')) {
      for (final s in data['settings'] as List) {
        await _db.settingsDao.setValue(s['key'] as String, s['value'] as String);
      }
    }
  }
}
